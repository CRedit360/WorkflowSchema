//
//  WFSMultipleCondition.m
//  WorkflowSchema
//
//  Created by Simon Booth on 01/11/2012.
//  Copyright (c) 2012 CRedit360. All rights reserved.
//

#import "WFSMultipleCondition.h"

@implementation WFSMultipleCondition

+ (NSArray *)arraySchemaParameters
{
    return [[super arraySchemaParameters] arrayByPrependingObject:@"conditions"];
}

+ (NSArray *)mandatorySchemaParameters
{
    return [[super mandatorySchemaParameters] arrayByPrependingObject:@"conditions"];
}

+ (NSArray *)defaultSchemaParameters
{
    return [[super defaultSchemaParameters] arrayByPrependingObject:@[ [WFSCondition class], @"conditions" ]];
}

+ (NSDictionary *)enumeratedSchemaParameters
{
    return [[super enumeratedSchemaParameters] dictionaryByAddingEntriesFromDictionary:@{
       
            @"requirement" : @{
            
                    @"any" : @(WFSMultipleConditionAny),
                    @"all" : @(WFSMultipleConditionAll)
            
            }
            
    }];
}

+ (NSDictionary *)schemaParameterTypes
{
    return [[super schemaParameterTypes] dictionaryByAddingEntriesFromDictionary:@{
            
            @"conditions"  : [WFSCondition class],
            @"requirement" : @[ [NSString class], [NSNumber class] ]
            
    }];
}

- (BOOL)evaluateWithValue:(id)value context:(WFSContext *)context
{
    for (WFSCondition *condition in self.conditions)
    {
        BOOL conditionIsTrue;
        
        if (condition.value)
        {
            conditionIsTrue = [condition evaluateWithContext:context];
        }
        else
        {
            conditionIsTrue = [condition evaluateWithValue:value context:context];
        }
        
        if (conditionIsTrue)
        {
            if (self.requirement == WFSMultipleConditionAny) return YES;
            else if (self.requirement == WFSMultipleConditionNone) return NO;
        }
        else
        {
            if (self.requirement == WFSMultipleConditionAll) return NO;
        }
    }
    
    if (self.requirement == WFSMultipleConditionAny) return NO;
    else return YES;
}

@end
