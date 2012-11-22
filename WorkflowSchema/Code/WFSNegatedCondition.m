//
//  WFSNegatedCondition.m
//  WorkflowSchema
//
//  Created by Simon Booth on 22/11/2012.
//  Copyright (c) 2012 CRedit360. All rights reserved.
//

#import "WFSNegatedCondition.h"

@implementation WFSNegatedCondition

+ (NSArray *)defaultSchemaParameters
{
    return [[super defaultSchemaParameters] arrayByPrependingObject:@[ [WFSCondition class], @"condition" ]];
}

+ (NSDictionary *)schemaParameterTypes
{
    return [[super schemaParameterTypes] dictionaryByAddingEntriesFromDictionary:@{ @"condition" : [WFSCondition class] }];
}

- (BOOL)evaluateWithValue:(id)value context:(WFSContext *)context
{
    BOOL result = [self.condition evaluateWithValue:value context:context];
    return !result;
}

@end
