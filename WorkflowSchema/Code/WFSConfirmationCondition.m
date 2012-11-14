//
//  WFSConfirmationCondition.m
//  WFSWorkflow
//
//  Created by Simon Booth on 16/10/2012.
//  Copyright (c) 2012 CRedit360. All rights reserved.
//

#import "WFSConfirmationCondition.h"

@implementation WFSConfirmationCondition

+ (NSArray *)mandatorySchemaParameters
{
    return [[super mandatorySchemaParameters] arrayByAddingObjectsFromArray:@[ @"otherInputName" ]];
}

+ (NSArray *)defaultSchemaParameters
{
    return [[super defaultSchemaParameters] arrayByPrependingObject:@[ [NSString class], @"otherInputName" ]];
}

+ (NSDictionary *)schemaParameterTypes
{
    return [[super schemaParameterTypes] dictionaryByAddingEntriesFromDictionary:@{ @"otherInputName" : [NSString class] }];
}

- (BOOL)evaluateWithValue:(id)value context:(WFSContext *)context
{
    id otherValue = context.parameters[self.otherInputName];
    return  ((!value && !otherValue) || [value isEqual:otherValue]);
}

@end
