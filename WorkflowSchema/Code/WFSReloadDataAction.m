//
//  WFSReloadDataAction.m
//  WorkflowSchema
//
//  Created by Simon Booth on 12/11/2012.
//  Copyright (c) 2012 CRedit360. All rights reserved.
//

#import "WFSReloadDataAction.h"

@implementation WFSReloadDataAction

+ (NSArray *)defaultSchemaParameters
{
    return [[super defaultSchemaParameters] arrayByPrependingObject:@[ [WFSAction class], @"action" ]];
}

+ (NSDictionary *)schemaParameterTypes
{
    return [[super schemaParameterTypes] dictionaryByAddingEntriesFromDictionary:@{ @"action" : [WFSAction class] }];
}

- (WFSResult *)performActionForController:(UIViewController *)controller context:(WFSContext *)context
{
    if ([controller respondsToSelector:@selector(reloadData)])
    {
        [controller performSelector:@selector(reloadData)];
        return [WFSResult successResultWithContext:context];
    }
    else
    {
        NSError *error = WFSError(@"Cannot find table controller");
        [context sendWorkflowError:error];
        return [WFSResult failureResultWithContext:context];
    }
}

@end
