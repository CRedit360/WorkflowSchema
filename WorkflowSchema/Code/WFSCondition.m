//
//  WFSValidateAction.m
//  WFSWorkflow
//
//  Created by Simon Booth on 16/10/2012.
//  Copyright (c) 2012 CRedit360. All rights reserved.
//

#import "WFSCondition.h"

@implementation WFSCondition

+ (NSArray *)lazilyCreatedSchemaParameters
{
    return [[super lazilyCreatedSchemaParameters] arrayByPrependingObject:@"value"];
}

+ (NSDictionary *)schemaParameterTypes
{
    return [[super schemaParameterTypes] dictionaryByAddingEntriesFromDictionary:@{
            
            @"failureMessage" : [NSString class],
            @"value"          : [NSObject class]
            
    }];
}

- (BOOL)evaluateWithContext:(WFSContext *)context
{
    NSError *error = nil;
    id value = [self schemaParameterWithName:@"value" context:context error:&error];
    return [self evaluateWithValue:value context:context];
}

- (BOOL)evaluateWithValue:(id)value context:(WFSContext *)context
{
    return YES;
}

@end
