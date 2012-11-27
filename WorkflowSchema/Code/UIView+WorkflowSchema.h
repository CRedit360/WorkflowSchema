//
//  UIView+WorkflowSchema.h
//  WorkflowSchema
//
//  Created by Simon Booth on 02/11/2012.
//  Copyright (c) 2012 CRedit360. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (WorkflowSchema)

- (UIResponder *)findFirstResponder;
- (NSArray *)subviewsWithWorkflowNames:(NSArray *)names;

@end
