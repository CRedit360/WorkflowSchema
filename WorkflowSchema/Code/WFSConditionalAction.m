//
//  WFSConditionalAction.m
//  WorkflowSchema
//
//  Created by Simon Booth on 19/11/2012.
//  Copyright (c) 2012 CRedit360. All rights reserved.
//

#import "WFSConditionalAction.h"

@implementation WFSConditionalAction

+ (NSArray *)mandatorySchemaParameters
{
    return [[super mandatorySchemaParameters] arrayByAddingObject:@"condition"];
}

+ (NSArray *)defaultSchemaParameters
{
    return [[super defaultSchemaParameters] arrayByPrependingObjectsFromArray:@[
            
            @[ [WFSCondition class], @"condition" ],
            @[ [WFSAction class], @"successAction" ],
            
    ]];
}

+ (NSDictionary *)schemaParameterTypes
{
    return [[super schemaParameterTypes] dictionaryByAddingEntriesFromDictionary:@{
            
            @"condition" : [WFSCondition class],
            @"successAction" : [WFSAction class],
            @"failureAction" : [WFSAction class]
            
    }];
}

- (WFSResult *)performActionForController:(UIViewController *)controller context:(WFSContext *)context
{
    if ([self.condition evaluateWithContext:context])
    {
        return [self.successAction performActionForController:controller context:context];
    }
    else
    {
        return [self.failureAction performActionForController:controller context:context];
    }
}

@end
