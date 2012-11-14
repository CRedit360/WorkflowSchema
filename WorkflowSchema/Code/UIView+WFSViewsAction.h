//
//  UIView+WFSViewsAction.h
//  WorkflowSchema
//
//  Created by Simon Booth on 02/11/2012.
//  Copyright (c) 2012 CRedit360. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    
    WFSViewsActionStateStable = 0,
    WFSViewsActionStateShowing,
    WFSViewsActionStateHiding
    
} WFSViewsActionState;

@interface UIView (WFSViewsAction)

- (NSArray *)subviewsWithWorkflowNames:(NSArray *)names;

@end
