//
//  WFSViewsAction.h
//  WorkflowSchema
//
//  Created by Simon Booth on 02/11/2012.
//  Copyright (c) 2012 CRedit360. All rights reserved.
//

#import "WFSAction.h"

extern NSString * const WFSViewsActionDidChangeHierarchyNotification;
extern NSString * const WFSViewsActionNotificationViewKey;

@interface WFSViewsAction : WFSAction

@property (nonatomic, strong) NSArray *viewNames;
- (void)notifyDidChangeHierarchyOfView:(UIView *)view;

@end
