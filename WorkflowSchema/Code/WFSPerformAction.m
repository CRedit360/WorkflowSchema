//
//  WFSPerformAction.m
//  WorkflowSchema
//
//  Created by Simon Booth on 19/11/2012.
//  Copyright (c) 2012 CRedit360. All rights reserved.
//

#import "WFSPerformAction.h"
#import "UIViewController+WFSSchematising.h"

@implementation WFSPerformAction

+ (NSArray *)mandatorySchemaParameters
{
    return [[super mandatorySchemaParameters] arrayByAddingObject:@"actionName"];
}

+ (NSArray *)defaultSchemaParameters
{
    return [[super defaultSchemaParameters] arrayByAddingObject:@[ [NSString class], @"actionName" ]];
}

+ (NSDictionary *)schemaParameterTypes
{
    return [[super schemaParameterTypes] dictionaryByAddingEntriesFromDictionary:@{ @"actionName" : [NSString class] }];
}

- (WFSResult *)performActionForController:(UIViewController *)controller context:(WFSContext *)context
{
    return [controller performActionName:self.actionName context:context];
}

@end
