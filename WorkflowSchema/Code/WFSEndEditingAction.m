//
//  WFSEndEditingAction.m
//  WorkflowSchema
//
//  Created by Simon Booth on 27/11/2012.
//  Copyright (c) 2012 CRedit360. All rights reserved.
//

#import "WFSEndEditingAction.h"

@implementation WFSEndEditingAction

- (WFSResult *)performActionForController:(UIViewController *)controller context:(WFSContext *)context
{
    [controller.view endEditing:YES];
    return [WFSResult successResultWithContext:context];
}

@end
