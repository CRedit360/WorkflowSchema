//
//  UIViewController+WorkflowSchema.h
//  WorkflowSchema
//
//  Created by Simon Booth on 20/11/2012.
//  Copyright (c) 2012 CRedit360. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (WorkflowSchema)

- (NSArray *)descendantControllersWithWorkflowNames:(NSArray *)names;

@end
