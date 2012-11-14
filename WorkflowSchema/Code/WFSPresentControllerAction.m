//
//  WFSPresentControllerAction.m
//  WorkflowSchema
//
//  Created by Simon Booth on 20/10/2012.
//  Copyright (c) 2012 CRedit360. All rights reserved.
//

#import "WFSPresentControllerAction.h"
#import "WFSLoadSchemaAction.h"

@implementation WFSPresentControllerAction

- (WFSResult *)showController:(UIViewController *)controllerToPresent forController:(UIViewController *)presentingController context:(WFSContext *)context
{
    BOOL animated = YES;
    if ([WFSAction actionAnimationsAreDisabled]) animated = NO;
    
    if (controllerToPresent && presentingController)
    {
        [presentingController presentViewController:controllerToPresent animated:animated completion:nil];
        return [WFSResult successResultWithContext:context];
    }
    else
    {
        NSError *error = WFSError(@"Cannot find presenting controller");
        [context sendWorkflowError:error];
        return [WFSResult failureResultWithContext:context];
    }
}

@end
