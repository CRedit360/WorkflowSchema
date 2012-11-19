//
//  UIViewController+WFSSchematising.h
//  WorkflowSchema
//
//  Created by Simon Booth on 29/10/2012.
//  Copyright (c) 2012 CRedit360. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "WFSResult.h"
#import "WFSMessage.h"
#import "WFSContext.h"

@interface UIViewController (WFSSchematising) <WFSContextDelegate>

/*
 *  Workflow messages with matching (or nil) type will be intercepted and their name and context
 *  passed to performActionName:context: whereas others will be passed to the controller's 
 *  context's message delegate.
 */
+ (NSString *)actionWorkflowMessageTarget;

@property (nonatomic, strong) NSArray *actions;
- (NSString *)actionNameForSelector:(SEL)selector;
- (WFSResult *)performActionName:(NSString *)name context:(WFSContext *)context;
- (WFSMutableContext *)contextForPerformingActions:(WFSContext *)context;

@property (nonatomic, strong) NSDictionary *storedValues;
- (void)storeValues:(NSDictionary *)valuesToStore;
- (void)clearCachedContextValues;

@end

#define WFS_UIVIEWCONTROLLER_LIFECYCLE \
- (void)viewDidLoad \
{ \
    [super viewDidLoad]; \
    [self performActionName:[self actionNameForSelector:_cmd] context:self.workflowContext]; \
} \
\
- (void)viewWillAppear:(BOOL)animated \
{ \
    [super viewWillAppear:animated]; \
    [self performActionName:[self actionNameForSelector:_cmd] context:self.workflowContext]; \
} \
\
- (void)viewDidAppear:(BOOL)animated \
{ \
    [super viewDidAppear:animated]; \
    [self performActionName:[self actionNameForSelector:_cmd] context:self.workflowContext]; \
} \
\
- (void)viewWillDisappear:(BOOL)animated \
{ \
    [super viewWillDisappear:animated]; \
    [self performActionName:[self actionNameForSelector:_cmd] context:self.workflowContext]; \
} \
\
- (void)viewDidDisappear:(BOOL)animated \
{ \
    [super viewDidDisappear:animated]; \
    [self performActionName:[self actionNameForSelector:_cmd] context:self.workflowContext]; \
}