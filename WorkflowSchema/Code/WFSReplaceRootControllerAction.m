//
//  WFSReplaceRootControllerAction.m
//  WorkflowSchema
//
//  Created by Simon Booth on 23/10/2012.
//  Copyright (c) 2012 CRedit360. All rights reserved.
//

#import "WFSReplaceRootControllerAction.h"

@implementation WFSReplaceRootControllerAction

- (WFSResult *)showController:(UIViewController *)controllerToShow forController:(UIViewController *)controller context:(WFSContext *)context
{
    UINavigationController *navigationController = (UINavigationController *)controller;
    
    if ([navigationController isKindOfClass:[UINavigationController class]] && controllerToShow)
    {
        [navigationController setViewControllers:@[ controllerToShow ]];
        return [WFSResult successResultWithContext:context];
    }
    else
    {
        NSError *error = WFSError(@"WFSReplaceRootControllerAction can only be performed by a navigation controller");
        [context sendWorkflowError:error];
        return [WFSResult failureResultWithContext:context];
    }
}

@end
