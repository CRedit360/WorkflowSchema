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
    
    NSString *key   = groupedParameters[@"key"];
    NSString *value = groupedParameters[@"value"];
    NSString *table = groupedParameters[@"table"];

    if (!key & !value)
    {
        if (outError) *outError = WFSError(@"Strings must specify a key or a value");
        return nil;
    }
    
    if (table && !key)
    {
        if (outError) *outError = WFSError(@"Strings may only specify a table if they also specify a key");
        return nil;
    }
    
    if (key)
    {
        value = [[NSBundle mainBundle] localizedStringForKey:key value:value table:table];
    }
                 
    self = [self initWithString:value];
    
    if (self)
    {
        WFS_SCHEMATISING_PROPERTY_INITITIALISATION;
    }
    return self;
}

+ (NSArray *)defaultSchemaParameters
{
    return [[super defaultSchemaParameters] arrayByPrependingObject:@[ [NSString class], @"value" ] ];
}

+ (NSDictionary *)schemaParameterTypes
{
    return [[super schemaParameterTypes] dictionaryByAddingEntriesFromDictionary:@{
            
            @"key"   : [NSString class],
            @"value" : [NSString class],
            @"table" : [NSString class]
            
    }];
}

- (char)charValue
{
    return (char)[self boolValue];
}

@end
