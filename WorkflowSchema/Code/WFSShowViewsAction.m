//
//  WFSShowInputsAction.m
//  WorkflowSchema
//
//  Created by Simon Booth on 01/11/2012.
//  Copyright (c) 2012 CRedit360. All rights reserved.
//

#import "WFSShowViewsAction.h"
#import "UIView+WorkflowSchema.h"

@implementation WFSShowViewsAction

- (WFSResult *)performActionForController:(UIViewController *)controller context:(WFSContext *)context
{
    NSArray *views = [controller.view subviewsWithWorkflowNames:self.viewNames];
    
    NSMutableArray *hiddenViews = [NSMutableArray array];
    for (UIView *view in views)
    {
        if (view.hidden) [hiddenViews addObject:view];
    }
    
    BOOL animated = YES;
    if ([WFSAction actionAnimationsAreDisabled]) animated = NO;
    
    if (animated)
    {
        for (UIView *view in hiddenViews)
        {
            view.hidden = NO;
            view.alpha = 0;
        }
        
        [UIView animateWithDuration:0.25 animations:^{
            
            [self notifyDidChangeHierarchyOfView:controller.view];
            
        } completion:^(BOOL finished) {
            
            [UIView animateWithDuration:0.25 animations:^{
                
                for (UIView *view in hiddenViews)
                {
                    view.alpha = 1;
                }
                
            }];
            
        }];
    }
    else
    {
        for (UIView *view in hiddenViews)
        {
            view.hidden = NO;
            view.alpha = 1;
        }
    }
    
    return [WFSResult successResultWithContext:context];
}

@end
