//
//  WSTTestAction.m
//  WorkflowSchemaTests
//
//  Created by Simon Booth on 26/10/2012.
//  Copyright (c) 2012 CRedit360. All rights reserved.
//

#import "WSTTestAction.h"

static NSMutableArray *WSTTestActions = nil;

@implementation WSTTestAction

+ (void)initialize
{
    WSTTestActions = [NSMutableArray array];
}

+ (NSArray *)recentTestActions
{
    return WSTTestActions;
}

+ (void)clearRecentTestActions
{
    [WSTTestActions removeAllObjects];
}

+ (WSTTestAction *)lastTestAction
{
    return [WSTTestActions lastObject];
}

+ (NSDictionary *)schemaParameterTypes
{
    return [[super schemaParameterTypes] dictionaryByAddingEntriesFromDictionary:@{ @"shouldFail" : @[ [NSString class], [NSNumber class] ] }];
}

+ (NSArray *)defaultSchemaParameters
{
    return [[super defaultSchemaParameters] arrayByPrependingObjectsFromArray:@[
            
            @[ [NSString class], @"shouldFail" ],
            @[ [NSNumber class], @"shouldFail" ],
            
            ]];
}

- (WFSResult *)performActionForController:(UIViewController *)controller context:(WFSContext *)context
{
    [WSTTestActions addObject:self];
    
    if (self.shouldFail) return [WFSResult failureResultWithContext:context];
    else return [WFSResult successResultWithContext:context];
}

@end
