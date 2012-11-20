//
//  WFSPresenceCondition.m
//  WorkflowSchema
//
//  Created by Simon Booth on 19/11/2012.
//  Copyright (c) 2012 CRedit360. All rights reserved.
//

#import "WFSPresenceCondition.h"

@implementation WFSPresenceCondition

+ (NSArray *)defaultSchemaParameters
{
    return [[super defaultSchemaParameters] arrayByPrependingObject:@[ [NSObject class], @"value" ]];
}

- (BOOL)evaluateWithValue:(id)value context:(WFSContext *)context
{
    if ([value isKindOfClass:[NSString class]])
    {
        NSString *stringValue = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        return (stringValue.length > 0);
    }
    else if ([value isKindOfClass:[NSNull class]])
    {
        return NO;
    }
    
    return (value != nil);
}

@end
