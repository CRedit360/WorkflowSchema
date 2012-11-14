//
//  WFSPopControllerAction.m
//  WorkflowSchema
//
//  Created by Simon Booth on 20/10/2012.
//  Copyright (c) 2012 CRedit360. All rights reserved.
//

#import "WFSPopControllerAction.h"

@implementation WFSPopControllerAction

- (WFSResult *)performActionForController:(UIViewController *)controller context:(WFSContext *)context
{
    UINavigationController *navigationController = controller.navigationController;
    
    BOOL animated = YES;
    if ([WFSAction actionAnimationsAreDisabled]) animated = NO;
    
    if (controller && navigationController)
    {
        [navigationController popToViewController:controller animated:animated];
        return [WFSResult successResultWithContext:context];
    }
    else
    {
        NSError *error = WFSError(@"Cannot find navigation controller");
        [context sendWorkflowError:error];
        return [WFSResult failureResultWithContext:context];
    }
}

@end
