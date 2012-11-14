//
//  WFSMultipleAction.m
//  WorkflowSchema
//
//  Created by Simon Booth on 21/10/2012.
//  Copyright (c) 2012 CRedit360. All rights reserved.
//

#import "WFSMultipleAction.h"

@implementation WFSMultipleAction

+ (NSArray *)mandatorySchemaParameters
{
    return [[super mandatorySchemaParameters] arrayByAddingObject:@"actions"];
}

+ (NSArray *)arraySchemaParameters
{
    return [[super arraySchemaParameters] arrayByAddingObject:@"actions"];
}

+ (NSArray *)defaultSchemaParameters
{
    return [[super arraySchemaParameters] arrayByAddingObject:@[ [WFSAction class], @"actions" ]];
}

+ (NSDictionary *)schemaParameterTypes
{
    return [[super schemaParameterTypes] dictionaryByAddingEntriesFromDictionary:@{ @"actions" : [WFSAction class] }];
}

- (WFSResult *)performActionForController:(UIViewController *)controller context:(WFSContext *)context
{
    for (WFSAction *action in self.actions)
    {
        WFSResult *result = [action performActionForController:controller context:context];
        if (!result.isSuccess) return result;
    }
    
    return [WFSResult successResultWithContext:context];
}

@end
