//
//  UIImage+WFSSchematising.m
//  WorkflowSchema
//
//  Created by Simon Booth on 21/10/2012.
//  Copyright (c) 2012 CRedit360. All rights reserved.
//

#import "UIImage+WFSSchematising.h"
#import "WFSSchema+WFSGroupedParameters.h"
#import <objc/runtime.h>

@implementation UIImage (WFSSchematising)

- (id)initWithSchema:(WFSSchema *)schema context:(WFSContext *)context error:(NSError **)outError
{
    NSDictionary *groupedParameters = [schema groupedParametersWithContext:context error:outError];
    if (!groupedParameters) return nil;
    
    NSString *imageName = groupedParameters[@"name"];
    if (!imageName)
    {
        if (outError) *outError = WFSError(@"Images require a name");
        return nil;
    }
    
    self = [[self class] imageNamed:imageName];
    if (self)
    {
        // The default is the image name, which isn't good enough.
        self.accessibilityLabel = nil;
        
        WFS_SCHEMATISING_INITIALISATION;
    }
    else
    {
        if (outError) *outError = WFSError(@"Could not find image named '%@'", imageName);
        return nil;
    }
    return self;
}

+ (BOOL)includeAccessibilitySchemaParameters
{
    return YES;
}

+ (NSArray *)mandatorySchemaParameters
{
    return [[super mandatorySchemaParameters] arrayByPrependingObject:@"name" ];
}

+ (NSArray *)defaultSchemaParameters
{
    return [[super defaultSchemaParameters] arrayByPrependingObject:@[ [NSString class], @"name"] ];
}

+ (NSDictionary *)schemaParameterTypes
{
    return [[super schemaParameterTypes] dictionaryByAddingEntriesFromDictionary:@{ @"name" : [NSString class] }];
}

- (BOOL)setSchemaParameterWithName:(NSString *)name value:(id)value context:(WFSContext *)context error:(NSError **)outError
{
    if ([name isEqualToString:@"name"]) return YES;
    return [super setSchemaParameterWithName:name value:value context:context error:outError];
}

@end
