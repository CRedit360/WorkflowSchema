//
//  WFSAction.m
//  WFSWorkflow
//
//  Created by Simon Booth on 16/10/2012.
//  Copyright (c) 2012 CRedit360. All rights reserved.
//

#import "WFSAction.h"

static NSUInteger WFSActionAnimationDisabledCount;

@interface WFSAction ()

@end

@implementation WFSAction

- (BOOL)shouldPerformActionForResultName:(NSString *)name
{
    return (self.workflowName.length == 0) || [self.workflowName isEqualToString:name];
}

- (WFSResult *)performActionForController:(UIViewController *)controller context:(WFSContext *)context
{
    return [WFSResult successResultWithContext:context];
}

#pragma mark - Global animation disabling

+ (BOOL)actionAnimationsAreDisabled
{
    return WFSActionAnimationDisabledCount > 0;
}

+ (void)performWithActionAnimationsDisabled:(void (^)(void))block
{
    @try
    {
        WFSActionAnimationDisabledCount++;
        if (block) block();
    }
    @finally
    {
        WFSActionAnimationDisabledCount--;
    }
}


@end
