//
//  UIView+WorkflowSchema.m
//  WorkflowSchema
//
//  Created by Simon Booth on 02/11/2012.
//  Copyright (c) 2012 CRedit360. All rights reserved.
//

#import "UIView+WorkflowSchema.h"
#import "NSObject+WFSSchematising.h"

@implementation UIView (WorkflowSchema)

- (UIResponder *)findFirstResponder
{
    if (self.isFirstResponder) return self;
    
    for (UIView *view in self.subviews)
    {
        UIResponder *responder = [view findFirstResponder];
        if (responder) return responder;
    }
    
    return nil;
}

- (NSArray *)subviewsWithWorkflowNames:(NSArray *)names
{
    NSMutableArray *subviews = [NSMutableArray array];
    
    for (UIView *view in self.subviews)
    {
        NSString *name = view.workflowName;
        if (name && [names containsObject:name])
        {
            [subviews addObject:view];
        }
        
        [subviews addObjectsFromArray:[view subviewsWithWorkflowNames:names]];
    }
    
    return subviews;
}

@end
