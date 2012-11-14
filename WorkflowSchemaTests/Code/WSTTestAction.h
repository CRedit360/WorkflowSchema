//
//  WSTTestAction.h
//  WorkflowSchemaTests
//
//  Created by Simon Booth on 26/10/2012.
//  Copyright (c) 2012 CRedit360. All rights reserved.
//

#import <WorkflowSchema/WorkflowSchema.h>

@interface WSTTestAction : WFSAction

+ (void)clearRecentTestActions;
+ (NSArray *)recentTestActions;
+ (WSTTestAction *)lastTestAction;

@property (nonatomic, assign) BOOL shouldFail;

@end
