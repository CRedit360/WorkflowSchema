//
//  WFSConfirmationCondition.m
//  WFSWorkflow
//
//  Created by Simon Booth on 16/10/2012.
//  Copyright (c) 2012 CRedit360. All rights reserved.
//

#import "WFSEqualityCondition.h"

@implementation WFSEqualityCondition

+ (NSArray *)mandatorySchemaParameters
{
    return [[super mandatorySchemaParameters] arrayByAddingObjectsFromArray:@[ @"otherValue" ]];
}

+ (NSArray *)lazilyCreatedSchemaParameters
{
    return [[super lazilyCreatedSchemaParameters] arrayByAddingObjectsFromArray:@[ @"otherValue" ]];
}

+ (NSArray *)defaultSchemaParameters
{
    return [[super defaultSchemaParameters] arrayByPrependingObject:@[ [NSObject class], @"otherValue" ]];
}

+ (NSDictionary *)schemaParameterTypes
{
    return [[super schemaParameterTypes] dictionaryByAddingEntriesFromDictionary:@{ @"otherValue" : [NSObject class] }];
}

- (BOOL)evaluateWithValue:(id)value context:(WFSContext *)context
{
    NSError *error = nil;
    
    id otherValue = [self schemaParameterWithName:@"otherValue" context:context error:&error];
    if (error) [context sendWorkflowError:error];
    
    return  ((!value && !otherValue) || [value isEqual:otherValue]);
}

@end
