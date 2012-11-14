//
//  WFSXMLParser.m
//  WFSWorkflow
//
//  Created by Simon Booth on 15/10/2012.
//  Copyright (c) 2012 CRedit360. All rights reserved.
//

#import "WFSXMLParser.h"
#import "WFSSchema.h"
#import "WFSParameterProxy.h"
#import "WFSSchemaParameter.h"

#define WFSParserLog(X, args...) { if ([[[NSProcessInfo processInfo] environment] objectForKey:@"WFS_DEBUG_PARSER"]) NSLog(X, ## args); }

@interface WFSXMLParser () <NSXMLParserDelegate>

@property (nonatomic, strong) NSXMLParser *parser;
@property (nonatomic, strong) NSString *documentType;
@property (nonatomic, strong) NSMutableArray *parseStack;

@property (nonatomic, strong) NSError *resultError;
@property (nonatomic, strong) WFSSchema *resultSchema;

@end

@implementation WFSXMLParser

- (id)initWithParser:(NSXMLParser *)parser
{
    self = [super init];
    if (self)
    {
        _parser = parser;
        _parser.delegate = self;
        
        _parseStack = [NSMutableArray array];
    }
    return self;
}

- (id)initWithContentsOfURL:(NSURL *)url
{
    return [self initWithParser:[[NSXMLParser alloc] initWithContentsOfURL:url]];
}

- (id)initWithString:(NSString *)string
{
    return [self initWithParser:[[NSXMLParser alloc] initWithData:[string dataUsingEncoding:NSUTF8StringEncoding]]];
}

- (WFSSchema *)parse:(NSError **)outError
{
    @try
    {
        [_parser parse];
    }
    @catch (NSException *exception)
    {
        self.resultError = WFSErrorFromException(exception);
        self.resultSchema = nil;
    }
    
    if (outError) *outError = self.resultError;
    return self.resultSchema;
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
    WFSParserLog(@"Parser error: %@", [parseError localizedDescription]);
}

- (void)parser:(NSXMLParser *)parser conditionErrorOccurred:(NSError *)conditionError
{
    WFSParserLog(@"Parser condition error: %@", [conditionError localizedDescription]);
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    if (!self.documentType)
    {
        WFSParserLog(@"Found document type %@", elementName);
        if (self.parseStack.count > 0) [NSException raise:@"WFSXMLInvalidException" format:@"Invalid XML"];
        if (self.resultSchema || self.resultError) [NSException raise:@"WFSXMLInvalidException" format:@"Invalid XML"];
        self.documentType = elementName;
        return;
    }
    
    Class schemaClass = [WFSSchema registeredClassForTypeName:elementName];
    
    if (schemaClass)
    {
        WFSSchema *schema = nil;
        
        NSString *parameterKeyPath = attributeDict[@"keyPath"];
        if (parameterKeyPath)
        {
            WFSParserLog(@"Found proxied parameter %@ for %@", parameterKeyPath, elementName);
            schema = [[WFSParameterProxy alloc] initWithTypeName:elementName attributes:attributeDict];
        }
        else
        {
            WFSParserLog(@"Found class %@ for %@", schemaClass, elementName);
            schema = [[WFSMutableSchema alloc] initWithTypeName:elementName attributes:attributeDict];
        }
                
        [self.parseStack addObject:schema];
    }
    else
    {
        WFSParserLog(@"No class found for %@", elementName);
        WFSSchemaParameter *parameter = [[WFSSchemaParameter alloc] initWithName:elementName];
        [self.parseStack addObject:parameter];
    }
}


- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    id element = [self.parseStack lastObject];
    string = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if (string.length > 0)
    {   
        if ([element isKindOfClass:[WFSSchemaParameter class]])
        {
            WFSSchemaParameter *parameter = element;
            WFSParserLog(@"Found value %@ for %@", string, parameter.name);
            if (!parameter.value) parameter.value = string;
        }
        else if ([element isKindOfClass:[WFSSchema class]])
        {
            WFSMutableSchema *schema = element;
            WFSParserLog(@"Found parameter %@ for %@", string, schema.typeName);
            [schema addParameter:string];
        }
        else [NSException raise:@"WFSXMLInvalidException" format:@"Invalid XML"];
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if (elementName == self.documentType)
    {
        if (self.parseStack.count > 0) [NSException raise:@"WFSXMLInvalidException" format:@"Invalid XML"];
        return;
    }
    
    id element = [self.parseStack lastObject];
    [self.parseStack removeLastObject];
 
    if (element)
    {
        NSString *name = nil;
        
        if ([element isKindOfClass:[WFSSchema class]])
        {
            name = [element typeName];
        }
        else if ([element isKindOfClass:[WFSSchemaParameter class]])
        {
            WFSSchemaParameter *parameter = element;
            name = parameter.name;
            
            if (!parameter.value)
            {
                parameter.value = @"";
            }
        }
        
        id parentElement = [self.parseStack lastObject];
        if ([parentElement isKindOfClass:[WFSSchemaParameter class]] && [element isKindOfClass:[WFSSchema class]])
        {
            WFSSchemaParameter *parentParameter = parentElement;
            WFSParserLog(@"Adding schema %@ to %@", name, parentParameter.name);
            [parentParameter addValue:element];
        }
        else if ([parentElement isKindOfClass:[WFSSchema class]])
        {
            WFSMutableSchema *parentSchema = parentElement;
            WFSParserLog(@"Adding element %@ to %@", name, parentSchema.typeName);
            [parentSchema addParameter:element];
        }
        else if ([element isKindOfClass:[WFSSchema class]])
        {
            self.resultSchema = element;
        }
        else [NSException raise:@"WFSXMLInvalidException" format:@"Invalid XML"];
    }
    else [NSException raise:@"WFSXMLInvalidException" format:@"Invalid XML"];
}

@end
