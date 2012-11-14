//
//  WFSSetVariableAction.m
//  WorkflowSchema
//
//  Created by Simon Booth on 12/11/2012.
//  Copyright (c) 2012 CRedit360. All rights reserved.
//

#import "WFSStoreValuesAction.h"

@implementation WFSStoreValuesAction

- (WFSResult *)performActionForController:(UIViewController *)controller context:(WFSContext *)context
{
    NSError *error = nil;
    
    if (!error)
    {   
        [controller storeValues:context.parameters];
        return [WFSResult successResultWithContext:context];
    }
    else
    {
        [context sendWorkflowError:error];
        return [WFSResult failureResultWithContext:context];
    }
}

@end
