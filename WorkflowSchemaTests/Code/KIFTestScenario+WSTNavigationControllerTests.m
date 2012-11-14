//
//  KIFTestScenario+WSTNavigationControllerTests.m
//  WorkflowSchemaTests
//
//  Created by Simon Booth on 29/10/2012.
//  Copyright (c) 2012 CRedit360. All rights reserved.
//

#import "KIFTestScenario+WSTNavigationControllerTests.h"
#import "KIFTestStep+WSTShared.h"
#import "WSTAssert.h"
#import "WSTTestAction.h"
#import "WSTTestContext.h"

@implementation KIFTestScenario (WSTNavigationControllerTests)

+ (id)scenarioUnitTestNavigationsHandleMessages
{
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Test navigation controller handles 'navigation' messages and passes on others"];
    
    [scenario addStep:[KIFTestStep stepWithDescription:scenario.description executionBlock:^KIFTestStepResult(KIFTestStep *step, NSError **outError) {
        
        NSError *error = nil;
        
        WFSSchema *navigationSchema = [[WFSSchema alloc] initWithTypeName:@"navigation" attributes:nil parameters:@[
                                           [[WFSSchema alloc] initWithTypeName:@"screen" attributes:nil parameters:nil],
                                           [[WFSSchemaParameter alloc] initWithName:@"actions" value:@[
                                                [[WFSSchema alloc] initWithTypeName:@"testAction" attributes:@{@"name":@"test"} parameters:nil],
                                                [[WFSSchema alloc] initWithTypeName:@"testAction" attributes:nil parameters:nil]
                                           ]]
                                      ]];
        
        WSTTestContext *context = [[WSTTestContext alloc] init];
        
        WFSNavigationController *navigationController = (WFSNavigationController *)[navigationSchema createObjectWithContext:context error:&error];
        WSTFailOnError(error);
        WSTAssert([navigationController isKindOfClass:[WFSNavigationController class]]);
        WSTAssert(navigationController.actions.count == 2);
        
        WSTTestAction *firstAction = navigationController.actions[0];
        WSTTestAction *secondAction = navigationController.actions[1];
        
        WFSContext *messageContext = [WFSContext contextWithDelegate:navigationController];
        
        WFSMessage *firstMessage = [WFSMessage messageWithType:@"navigation" name:@"test" context:messageContext responseHandler:nil];
        [messageContext sendWorkflowMessage:firstMessage];
        WSTAssert([WSTTestAction lastTestAction] == firstAction);
        
        WFSMessage *secondMessage = [WFSMessage messageWithType:@"navigation" name:@"different name" context:messageContext responseHandler:nil];
        [messageContext sendWorkflowMessage:secondMessage];
        WSTAssert([WSTTestAction lastTestAction] == secondAction);
        
        WSTAssert([context.messages isEqualToArray:@[]]);
        
        WFSMessage *thirdMessage = [WFSMessage messageWithType:@"different type" name:@"test" context:messageContext responseHandler:nil];
        [messageContext sendWorkflowMessage:thirdMessage];
        
        WSTAssert([context.messages isEqualToArray:@[ thirdMessage ]]);
        
        return KIFTestStepResultSuccess;
        
    }]];
    
    return scenario;
}

+ (id)scenarioUnitTestSendNavigationMessageFromNavigation
{
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Test that 'navigation' messages sent by a navigation go up a level"];
    
    [scenario addStep:[KIFTestStep stepWithDescription:scenario.description executionBlock:^KIFTestStepResult(KIFTestStep *step, NSError **outError) {
        
        NSError *error = nil;
        
        WFSSchema *navigationSchema = [[WFSSchema alloc] initWithTypeName:@"navigation" attributes:nil parameters:@[
                                           [[WFSSchema alloc] initWithTypeName:@"screen" attributes:nil parameters:nil],
                                           [[WFSSchemaParameter alloc] initWithName:@"actions" value:@[
                                                [[WFSSchema alloc] initWithTypeName:@"sendMessage" attributes:@{@"name":@"test1"} parameters:@[
                                                     [[WFSSchemaParameter alloc] initWithName:@"messageType" value:@"navigation"],
                                                     [[WFSSchemaParameter alloc] initWithName:@"messageName" value:@"test2"]
                                                ]]
                                           ]]
                                      ]];
        
        WSTTestContext *context = [[WSTTestContext alloc] init];
        
        WFSNavigationController *navigationController = (WFSNavigationController *)[navigationSchema createObjectWithContext:context error:&error];
        WSTFailOnError(error);
        WSTAssert([navigationController isKindOfClass:[WFSNavigationController class]]);
        
        WFSContext *messageContext = [WFSContext contextWithDelegate:navigationController];
        WFSMessage *messageGoingIn = [WFSMessage messageWithType:@"navigation" name:@"test1" context:messageContext responseHandler:nil];
        [messageContext sendWorkflowMessage:messageGoingIn];
        WSTAssert(context.messages.count == 1);
        WFSMessage *messageComingOut = context.messages[0];
        WSTAssert([messageComingOut.type isEqual:@"navigation"]);
        WSTAssert([messageComingOut.name isEqual:@"test2"]);
        
        return KIFTestStepResultSuccess;
        
    }]];
    
    return scenario;
}

@end
