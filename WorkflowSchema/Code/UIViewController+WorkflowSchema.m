//
//  UIViewController+WorkflowSchema.m
//  WorkflowSchema
//
//  Created by Simon Booth on 20/11/2012.
//  Copyright (c) 2012 CRedit360. All rights reserved.
//

#import "UIViewController+WorkflowSchema.h"
#import "NSObject+WFSSchematising.h"

@implementation UIViewController (WorkflowSchema)

- (NSArray *)descendantControllersWithWorkflowNames:(NSArray *)names
{
    NSMutableArray *descendants = [NSMutableArray array];
    
    for (UIViewController *child in self.childViewControllers)
    {
        NSString *name = child.workflowName;
        if (name && [names containsObject:name])
        {
            [descendants addObject:child];
        }
        
        [descendants addObjectsFromArray:[child descendantControllersWithWorkflowNames:names]];
    }
    
    return descendants;
}

@end
