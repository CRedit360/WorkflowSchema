//
//  WSTTestContext.m
//  WorkflowSchemaTests
//
//  Created by Simon Booth on 29/10/2012.
//  Copyright (c) 2012 CRedit360. All rights reserved.
//

#import "WSTTestContext.h"

@interface WSTTestContextDelegate : NSObject <WFSContextDelegate>

@property (nonatomic, weak) WSTTestContext *testContext;

@end;

@implementation WSTTestContextDelegate

- (void)context:(WFSContext *)contect didReceiveWorkflowError:(NSError *)error
{
    self.testContext.errors = [self.testContext.errors arrayByAddingObject:error];
}

- (BOOL)context:(WFSContext *)contect didReceiveWorkflowMessage:(WFSMessage *)message
{
    self.testContext.messages = [self.testContext.messages arrayByAddingObject:message];
    [message respondWithResult:self.testContext.messageResult];
    return YES;
}

@end

@interface WSTTestContext ()

@property (nonatomic, strong) WSTTestContextDelegate *testContextDelegate;

@end

@implementation WSTTestContext

- (id)init
{
    WSTTestContextDelegate *testContextDelegate = [[WSTTestContextDelegate alloc] init];
    
    self = [super initWithDelegate:testContextDelegate];
    if (self)
    {
        _messages = [NSArray array];
        _errors = [NSArray array];
        
        _testContextDelegate = testContextDelegate;
        _testContextDelegate.testContext = self;
        
        _messageResult = [WFSResult successResultWithContext:self];
    }
    return self;
}

@end
