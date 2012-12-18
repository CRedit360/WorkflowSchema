//
//  WFSTruthinessCondition.m
//  WorkflowSchema
//
//  Created by Simon Booth on 13/12/2012.
//  Copyright (c) 2012 CRedit360. All rights reserved.
//

#import "WFSTruthinessCondition.h"

@implementation WFSTruthinessCondition

+ (NSArray *)defaultSchemaParameters
{
    return [[super defaultSchemaParameters] arrayByPrependingObject:@[ [NSObject class], @"value" ]];
}

- (BOOL)evaluateWithValue:(id)value context:(WFSContext *)context
{
    if ([value respondsToSelector:@selector(boolValue)])
    {
        return [value boolValue];
    }
    else if ([value isKindOfClass:[NSNull class]])
    {
        return NO;
    }
    else
    {
        return (value != nil);
    }
}

@end
