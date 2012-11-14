//
//  NSString+WFSSchematising.m
//  WorkflowSchema
//
//  Created by Simon Booth on 20/10/2012.
//  Copyright (c) 2012 CRedit360. All rights reserved.
//

#import "NSString+WFSSchematising.h"
#import "WFSSchema+WFSGroupedParameters.h"
#import <objc/runtime.h>

@implementation NSString (WFSSchematising)

- (id)initWithSchema:(WFSSchema *)schema context:(WFSContext *)context error:(NSError **)outError
{
    NSDictionary *groupedParameters = [schema groupedParametersWithContext:context error:outError];
    if (!groupedParameters) return nil;
    
    NSString *value = groupedParameters[@"value"];

    if (![value isKindOfClass:[NSString class]])
    {
        if (outError) *outError = WFSError(@"Value of class %@ is not a string", [value class]);
        return nil;
    }
    
    self = [self initWithString:value];
    if (self)
    {
        WFS_SCHEMATISING_PROPERTY_INITITIALISATION;
    }
    return self;
}

+ (NSArray *)mandatorySchemaParameters
{
    return [[super mandatorySchemaParameters] arrayByPrependingObject:@"value"];
}

+ (NSArray *)defaultSchemaParameters
{
    return [[super defaultSchemaParameters] arrayByPrependingObject:@[ [NSString class], @"value" ] ];
}

+ (NSDictionary *)schemaParameterTypes
{
    return [[super schemaParameterTypes] dictionaryByAddingEntriesFromDictionary:@{ @"value" : [NSString class] }];
}

- (char)charValue
{
    return (char)[self boolValue];
}

@end
