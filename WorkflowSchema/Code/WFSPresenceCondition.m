//
//  WFSPresenceCondition.m
//  WorkflowSchema
//
//  Created by Simon Booth on 19/11/2012.
//  Copyright (c) 2012 CRedit360. All rights reserved.
//

#import "WFSPresenceCondition.h"

@implementation WFSPresenceCondition

- (BOOL)evaluateWithValue:(id)value context:(WFSContext *)context
{
    return (value != nil);
}

@end
