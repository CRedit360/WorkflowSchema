//
//  WFSHideInputsAction.m
//  WorkflowSchema
//
//  Created by Simon Booth on 01/11/2012.
//  Copyright (c) 2012 CRedit360. All rights reserved.
//

#import "WFSHideViewsAction.h"
#import "UIView+WorkflowSchema.h"

@implementation WFSHideViewsAction

+ (NSArray *)defaultSchemaParameters
{
    return [[super defaultSchemaParameters] arrayByAddingObject:@[ [NSString class], @"viewNames" ]];
}

- (WFSResult *)performActionForController:(UIViewController *)controller context:(WFSContext *)context
{
    NSArray *views = [controller.view subviewsWithWorkflowNames:self.viewNames];
    
    NSMutableArray *visibleViews = [NSMutableArray array];
    for (UIView *view in views)
    {
        if (!view.hidden) [visibleViews addObject:view];
    }
    
    BOOL animated = YES;
    if ([WFSAction actionAnimationsAreDisabled]) animated = NO;
    
    if (animated)
    {
        [UIView animateWithDuration:0.25 animations:^{
            
            for (UIView *view in visibleViews)
            {
                view.alpha = 0;
            }
            
        } completion:^(BOOL finished) {
            
            for (UIView *view in visibleViews)
            {
                view.hidden = YES;
            }
            
            [UIView animateWithDuration:0.25 animations:^{
                
                [self notifyDidChangeHierarchyOfView:controller.view];
                
            }];
        }];
    }
    else
    {
        for (UIView *view in visibleViews)
        {
            view.hidden = YES;
        }
    }
    
    return [WFSResult successResultWithContext:context];
}

@end
