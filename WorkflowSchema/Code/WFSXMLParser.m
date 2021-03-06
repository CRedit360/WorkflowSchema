//
//  WFSXMLParser.m
//  WFSWorkflow
//
//  Created by Simon Booth on 15/10/2012.
//  Copyright (c) 2012 CRedit360. All rights reserved.
//

#import "WFSXMLParser.h"
#import "WFSSchema.h"
#import "WFSSchema+WFSGroupedParameters.h"
#import "WFSParameterProxy.h"
#import "WFSConditionalSchema.h"
#import "WFSSchemaParameter.h"
#import "WFSSchematising.h"

NSString * const WFSXMLParserException = @"WFSXMLParserException";
NSString * const WFSXMLParserStackKey = @"WFSXMLParserStackKey";

#define WFSParserLog(X, args...) { if ([[[NSProcessInfo processInfo] environment] objectForKey:@"WFS_DEBUG_PARSER"]) NSLog(X, ## args); }

@interface WFSXMLParser () <NSXMLParserDelegate>

@property (nonatomic, strong) NSXMLParser *parser;
@property (nonatomic, strong) NSString *documentType;
@property (nonatomic, strong) NSLocale *documentLocale;
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
    self.resultError = parseError;
}

- (void)parser:(NSXMLParser *)parser conditionErrorOccurred:(NSError *)conditionError
{
    WFSParserLog(@"Parser condition error: %@", [conditionError localizedDescription]);
    self.resultError = conditionError;
}

- (void)parser:(NSXMLParser *)parser validationErrorOccurred:(NSError *)validationError
{
    WFSParserLog(@"Parser validation error: %@", [validationError localizedDescription]);
    self.resultError = validationError;
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    if (!self.documentType)
    {
        WFSParserLog(@"Found document type %@", elementName);
        if (self.parseStack.count > 0) [self raiseException:@"Stack non-empty at start"];
        if (self.resultSchema || self.resultError) [self raiseException:@"Attempted to reuse parser"];
        
        self.documentType = elementName;
        
        NSString *lang = attributeDict[@"lang"];
        if ([lang isKindOfClass:[NSString class]])
        {
            self.documentLocale = [[NSLocale alloc] initWithLocaleIdentifier:lang];
            if (!self.documentLocale) [self raiseException:@"Invalid locale identifier %@", lang];
        }
        
        return;
    }
    
    Class schemaClass = [WFSSchema registeredClassForTypeName:elementName];
    
    if (schemaClass)
    {
        WFSSchema *currentSchema = [self.parseStack lastObject];
        if ([currentSchema isKindOfClass:[WFSSchema class]])
        {
            BOOL classIsValidInCurrentSchema = NO;
            
            for (NSArray *defaultPair in [(Class)[currentSchema classForGroupedParameters] defaultSchemaParameters])
            {
                Class possibleClass = defaultPair[0];

                if ([schemaClass isSubclassOfClass:possibleClass])
                {
                    classIsValidInCurrentSchema = YES;
                    break;
                }
            }
            
            if (!classIsValidInCurrentSchema)
            {
                schemaClass = nil;
            }
        }
    }
    
    WFSSchema *schema = nil;
    
    if (schemaClass)
    {
        NSString *parameterKeyPath = attributeDict[@"keyPath"];
        BOOL conditional = [attributeDict[@"conditional"] boolValue];
        
        if (parameterKeyPath)
        {
            WFSParserLog(@"Found proxied parameter %@ for %@", parameterKeyPath, elementName);
            schema = [[WFSParameterProxy alloc] initWithTypeName:elementName attributes:attributeDict];
        }
        else if (conditional)
        {
            WFSParserLog(@"Found conditional schema for %@", elementName);
            schema = [[WFSConditionalSchema alloc] initWithTypeName:elementName attributes:attributeDict];
        }
        else if ([schemaClass isSchematisableClass])
        {
            WFSParserLog(@"Found schematisable class %@ for %@", schemaClass, elementName);
            schema = [[WFSMutableSchema alloc] initWithTypeName:elementName attributes:attributeDict];
        }
        else
        {
            WFSParserLog(@"Found abstract class %@ for %@", schemaClass, elementName);
        }
    }
    
    if (schema)
    {
        schema.locale = self.documentLocale;
        [self.parseStack addObject:schema];
    }
    else
    {
        WFSParserLog(@"Class %@ not schematisable; treating %@ as parameter", schemaClass, elementName);
        WFSSchemaParameter *parameter = [[WFSSchemaParameter alloc] initWithName:elementName];
        [self.parseStack addObject:parameter];
    }
}

- (void)parser:(NSXMLParser *)parser foundCDATA:(NSData *)CDATABlock
{
    NSString *string = [[NSString alloc] initWithData:CDATABlock encoding:NSUTF8StringEncoding];
    [self parser:parser foundCharacters:string];
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
        else if ([element isKindOfClass:[WFSMutableSchema class]])
        {
            WFSMutableSchema *schema = element;
            WFSParserLog(@"Found parameter %@ for %@", string, schema.typeName);
            [schema addParameter:string];
        }
        else [self raiseException:@"Cannot add characters to current element"];
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if (elementName == self.documentType)
    {
        if (self.parseStack.count > 0) [self raiseException:@"Document ended but stack non-empty"];
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
        else [self raiseException:@"Element ended but no valid parent or result is not a schema"];
    }
    else [self raiseException:@"Tag ended but no current element"];
}

- (void)raiseException:(NSString *)format, ...
{
    va_list args;
    va_start(args, format);
    NSString *reason = [[NSString alloc] initWithFormat:format arguments:args];
    va_end(args);
    
    NSMutableArray *stack = [NSMutableArray array];
    for (id element in self.parseStack)
    {
        if ([element isKindOfClass:[WFSSchema class]])
        {
            [stack addObject:[element typeName]];
        }
        else if ([element isKindOfClass:[WFSSchemaParameter class]])
        {
            [stack addObject:[element name]];
        }
        else
        {
            [stack addObject:[element description]];
        }
    }
    
    [[NSException exceptionWithName:WFSXMLParserException reason:reason userInfo:@{ WFSXMLParserStackKey : stack }] raise];
}

@end
