//
//  WFSMultipleAction.m
//  WorkflowSchema
//
//  Created by Simon Booth on 21/10/2012.
//  Copyright (c) 2012 CRedit360. All rights reserved.
//

#import "WFSMultipleAction.h"
#import "UIViewController+WFSSchematising.h"

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
        // Refresh the context each time, in case the user has stored some parameters
        WFSContext *actionContext = [controller contextForPerformingActions:context];
        WFSResult *result = [action performActionForController:controller context:actionContext];
        if (!result.isSuccess) return result;
    }
    
    return [WFSResult successResultWithContext:context];
}

@end
