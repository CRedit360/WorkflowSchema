//
//  KIFTestScenario+WSTTabControllerTests.m
//  WorkflowSchemaTests
//
//  Created by Simon Booth on 29/10/2012.
//  Copyright (c) 2012 CRedit360. All rights reserved.
//

#import "KIFTestScenario+WSTTabControllerTests.h"
#import "KIFTestStep+WSTShared.h"
#import "WSTAssert.h"
#import "WSTTestAction.h"
#import "WSTTestContext.h"

@implementation KIFTestScenario (WSTTabControllerTests)


+ (id)scenarioUnitTestTabsHandleMessages
{
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Test tab controller handles 'tabs' messages and passes on others"];
    
    [scenario addStep:[KIFTestStep stepWithDescription:scenario.description executionBlock:^KIFTestStepResult(KIFTestStep *step, NSError **outError) {
        
        NSError *error = nil;
        
        WFSSchema *tabSchema = [[WFSSchema alloc] initWithTypeName:@"tabs" attributes:nil parameters:@[
                                    [[WFSSchema alloc] initWithTypeName:@"screen" attributes:nil parameters:nil],
                                    [[WFSSchemaParameter alloc] initWithName:@"actions" value:@[
                                         [[WFSSchema alloc] initWithTypeName:@"testAction" attributes:@{@"name":@"test"} parameters:nil],
                                         [[WFSSchema alloc] initWithTypeName:@"testAction" attributes:nil parameters:nil]
                                    ]]
                               ]];
        
        WSTTestContext *context = [[WSTTestContext alloc] init];
        
        WFSTabBarController *tabController = (WFSTabBarController *)[tabSchema createObjectWithContext:context error:&error];
        WSTFailOnError(error);
        WSTAssert([tabController isKindOfClass:[WFSTabBarController class]]);
        WSTAssert(tabController.actions.count == 2);
        
        WSTTestAction *firstAction = tabController.actions[0];
        WSTTestAction *secondAction = tabController.actions[1];

        WFSContext *messageContext = [WFSContext contextWithDelegate:tabController];
        
        WFSMessage *firstMessage = [WFSMessage messageWithTarget:@"tabs" name:@"test" context:messageContext responseHandler:nil];
        [messageContext sendWorkflowMessage:firstMessage];
        WSTAssert([WSTTestAction lastTestAction] == firstAction);
        
        WFSMessage *secondMessage = [WFSMessage messageWithTarget:@"tabs" name:@"different name" context:messageContext responseHandler:nil];
        [messageContext sendWorkflowMessage:secondMessage];
        WSTAssert([WSTTestAction lastTestAction] == secondAction);
        
        WSTAssert([context.messages isEqualToArray:@[]]);
        
        WFSMessage *thirdMessage = [WFSMessage messageWithTarget:@"different type" name:@"test" context:messageContext responseHandler:nil];
        [messageContext sendWorkflowMessage:thirdMessage];
        
        WSTAssert([context.messages isEqualToArray:@[ thirdMessage ]]);
        
        return KIFTestStepResultSuccess;
        
    }]];
    
    return scenario;
}

+ (id)scenarioUnitTestSendTabMessageFromTab
{
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Test that 'tabs' messages sent by a tab go up a level"];
    
    [scenario addStep:[KIFTestStep stepWithDescription:scenario.description executionBlock:^KIFTestStepResult(KIFTestStep *step, NSError **outError) {
        
        NSError *error = nil;
        
        WFSSchema *tabSchema = [[WFSSchema alloc] initWithTypeName:@"tabs" attributes:nil parameters:@[
                                    [[WFSSchema alloc] initWithTypeName:@"screen" attributes:nil parameters:nil],
                                    [[WFSSchemaParameter alloc] initWithName:@"actions" value:@[
                                         [[WFSSchema alloc] initWithTypeName:@"sendMessage" attributes:@{@"name":@"test1"} parameters:@[
                                              [[WFSSchemaParameter alloc] initWithName:@"messageTarget" value:@"tabs"],
                                              [[WFSSchemaParameter alloc] initWithName:@"messageName" value:@"test2"]
                                         ]]
                                    ]]
                               ]];
        
        WSTTestContext *context = [[WSTTestContext alloc] init];
        
        WFSTabBarController *tabController = (WFSTabBarController *)[tabSchema createObjectWithContext:context error:&error];
        WSTFailOnError(error);
        WSTAssert([tabController isKindOfClass:[WFSTabBarController class]]);
        
        WFSContext *messageContext = [WFSContext contextWithDelegate:tabController];
        WFSMessage *messageGoingIn = [WFSMessage messageWithTarget:@"tabs" name:@"test1" context:messageContext responseHandler:nil];
        [messageContext sendWorkflowMessage:messageGoingIn];
        WSTAssert(context.messages.count == 1);
        WFSMessage *messageComingOut = context.messages[0];
        WSTAssert([messageComingOut.target isEqual:@"tabs"]);
        WSTAssert([messageComingOut.name isEqual:@"test2"]);
        
        return KIFTestStepResultSuccess;
        
    }]];
    
    return scenario;
}

@end
