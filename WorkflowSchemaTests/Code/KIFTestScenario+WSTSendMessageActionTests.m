//
//  KIFTestScenario+WSTSendMessageActionTests.m
//  WorkflowSchemaTests
//
//  Created by Simon Booth on 29/10/2012.
//  Copyright (c) 2012 CRedit360. All rights reserved.
//

#import "KIFTestScenario+WSTSendMessageActionTests.h"
#import "KIFTestStep+WSTShared.h"
#import "WSTAssert.h"
#import "WSTTestAction.h"
#import "WSTTestContext.h"

@implementation KIFTestScenario (WSTSendMessageActionTests)

+ (id)scenarioUnitTestSendMessageActionWithImplicitMessage
{
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Test the send message action with an implicit message"];
    
    [scenario addStep:[KIFTestStep stepWithDescription:scenario.description executionBlock:^KIFTestStepResult(KIFTestStep *step, NSError **outError) {
        
        NSError *error = nil;
        
        WFSSchema *actionSchema = [[WFSSchema alloc] initWithTypeName:@"sendMessage" attributes:nil parameters:@[@"test name"]];
        
        WSTTestContext *context = [[WSTTestContext alloc] init];
        
        WFSSendMessageAction *sendMessageAction = (WFSSendMessageAction *)[actionSchema createObjectWithContext:context error:&error];
        WSTFailOnError(error);
        WSTAssert([sendMessageAction isKindOfClass:[WFSSendMessageAction class]]);
        WSTAssert([sendMessageAction.message isKindOfClass:[NSString class]]);
        WSTAssert([sendMessageAction.message isEqual:@"test name"]);
        WSTAssert(sendMessageAction.actions.count == 0);
        
        WSTTestContext *controllerContext = [[WSTTestContext alloc] init];
        controllerContext.messageResult = [WFSResult successResultWithContext:controllerContext];
        
        UIViewController *controller = [[UIViewController alloc] init];
        controller.workflowContext = controllerContext;
        
        WSTTestContext *performanceContext = [[WSTTestContext alloc] init];
        performanceContext.messageResult = [WFSResult successResultWithContext:performanceContext];
        
        WFSResult *resultWithSuccess = [sendMessageAction performActionForController:controller context:performanceContext];
        WSTAssert(resultWithSuccess.isSuccess);
        
        WSTAssert(performanceContext.messages.count == 0);
        WSTAssert(controllerContext.messages.count == 1);
        
        WFSMessage *firstMessage = controllerContext.messages[0];
        WSTAssert([firstMessage.name isEqualToString:@"test name"]);
        WSTAssert(firstMessage.destinationType == WFSMessageDestinationDelegate);
        WSTAssert(firstMessage.destinationName == nil);
        
        return KIFTestStepResultSuccess;
        
    }]];
    
    return scenario;
}

+ (id)scenarioUnitTestSendMessageActionWithDelegateMessage
{
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Test the send message action with a delegate message"];
    
    [scenario addStep:[KIFTestStep stepWithDescription:scenario.description executionBlock:^KIFTestStepResult(KIFTestStep *step, NSError **outError) {
        
        NSError *error = nil;
        
        WFSSchema *actionSchema = [[WFSSchema alloc] initWithTypeName:@"sendMessage" attributes:nil parameters:@[
                                       [[WFSSchema alloc] initWithTypeName:@"message" attributes:nil parameters:@[@"test name"]]
                                  ]];
        
        WSTTestContext *context = [[WSTTestContext alloc] init];
        
        WFSSendMessageAction *sendMessageAction = (WFSSendMessageAction *)[actionSchema createObjectWithContext:context error:&error];
        WSTFailOnError(error);
        WSTAssert([sendMessageAction isKindOfClass:[WFSSendMessageAction class]]);
        WSTAssert(sendMessageAction.actions.count == 0);
        
        WSTAssert([sendMessageAction.message isKindOfClass:[WFSSchema class]]);
        WFSMessage *messageToSend = [sendMessageAction messageFromParameterWithName:@"message" context:context];
        WSTAssert([messageToSend isKindOfClass:[WFSMessage class]]);
        WSTAssert([messageToSend.name isEqual:@"test name"]);
        WSTAssert(messageToSend.destinationType == WFSMessageDestinationDelegate);
        WSTAssert(messageToSend.destinationName == nil);
        
        WSTTestContext *controllerContext = [[WSTTestContext alloc] init];
        controllerContext.messageResult = [WFSResult successResultWithContext:controllerContext];
        
        UIViewController *controller = [[UIViewController alloc] init];
        controller.workflowContext = controllerContext;
        
        WSTTestContext *performanceContext = [[WSTTestContext alloc] init];
        performanceContext.messageResult = [WFSResult successResultWithContext:performanceContext];
        
        WFSResult *resultWithSuccess = [sendMessageAction performActionForController:controller context:performanceContext];
        WSTAssert(resultWithSuccess.isSuccess);
        
        WSTAssert(performanceContext.messages.count == 0);
        WSTAssert(controllerContext.messages.count == 1);
        
        WFSMessage *firstMessage = controllerContext.messages[0];
        WSTAssert([firstMessage.name isEqualToString:@"test name"]);
        WSTAssert(firstMessage.destinationType == WFSMessageDestinationDelegate);
        WSTAssert(firstMessage.destinationName == nil);
        
        return KIFTestStepResultSuccess;
        
    }]];
    
    return scenario;
}

+ (id)scenarioUnitTestSendMessageActionWithRootDelegateMessage
{
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Test the send message action with a rootDelegate message"];
    
    [scenario addStep:[KIFTestStep stepWithDescription:scenario.description executionBlock:^KIFTestStepResult(KIFTestStep *step, NSError **outError) {
        
        NSError *error = nil;
        
        WFSSchema *actionSchema = [[WFSSchema alloc] initWithTypeName:@"sendMessage" attributes:nil parameters:@[
                                   [[WFSSchema alloc] initWithTypeName:@"message" attributes:nil parameters:@[
                                    [[WFSSchemaParameter alloc] initWithName:@"name" value:@"test name"],
                                    [[WFSSchemaParameter alloc] initWithName:@"destinationType" value:@"rootDelegate"],
                                    [[WFSSchemaParameter alloc] initWithName:@"destinationName" value:@"test destination"],
                                    ]]
                                   ]];
        
        WSTTestContext *context = [[WSTTestContext alloc] init];
        
        WFSSendMessageAction *sendMessageAction = (WFSSendMessageAction *)[actionSchema createObjectWithContext:context error:&error];
        WSTFailOnError(error);
        WSTAssert([sendMessageAction isKindOfClass:[WFSSendMessageAction class]]);
        WSTAssert(sendMessageAction.actions.count == 0);
        
        WSTAssert([sendMessageAction.message isKindOfClass:[WFSSchema class]]);
        WFSMessage *messageToSend = [sendMessageAction messageFromParameterWithName:@"message" context:context];
        WSTAssert([messageToSend isKindOfClass:[WFSMessage class]]);
        WSTAssert([messageToSend.name isEqual:@"test name"]);
        WSTAssert(messageToSend.destinationType == WFSMessageDestinationRootDelegate);
        WSTAssert([messageToSend.destinationName isEqual:@"test destination"]);
        
        WSTTestContext *controllerContext = [[WSTTestContext alloc] init];
        controllerContext.messageResult = [WFSResult successResultWithContext:controllerContext];
        
        UIViewController *controller = [[UIViewController alloc] init];
        controller.workflowContext = controllerContext;
        
        WSTTestContext *performanceContext = [[WSTTestContext alloc] init];
        performanceContext.messageResult = [WFSResult successResultWithContext:performanceContext];
        
        WFSResult *resultWithSuccess = [sendMessageAction performActionForController:controller context:performanceContext];
        WSTAssert(resultWithSuccess.isSuccess);
        
        WSTAssert(performanceContext.messages.count == 1);
        WSTAssert(controllerContext.messages.count == 0);
        
        WFSMessage *firstMessage = performanceContext.messages[0];
        WSTAssert([firstMessage.name isEqualToString:@"test name"]);
        WSTAssert(firstMessage.destinationType == WFSMessageDestinationRootDelegate);
        WSTAssert([firstMessage.destinationName isEqual:@"test destination"]);
        
        return KIFTestStepResultSuccess;
        
    }]];
    
    return scenario;
}

+ (id)scenarioUnitTestSendMessageActionWithSelfMessage
{
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Test the send message action with a rootDelegate message"];
    
    [scenario addStep:[KIFTestStep stepWithDescription:scenario.description executionBlock:^KIFTestStepResult(KIFTestStep *step, NSError **outError) {
        
        NSError *error = nil;
        
        WFSSchema *actionSchema = [[WFSSchema alloc] initWithTypeName:@"sendMessage" attributes:nil parameters:@[
                                       [[WFSSchema alloc] initWithTypeName:@"message" attributes:nil parameters:@[
                                            [[WFSSchemaParameter alloc] initWithName:@"name" value:@"test name"],
                                            [[WFSSchemaParameter alloc] initWithName:@"destinationType" value:@"self"],
                                            [[WFSSchemaParameter alloc] initWithName:@"destinationName" value:@"test destination"],
                                       ]]
                                  ]];
        
        WSTTestContext *context = [[WSTTestContext alloc] init];
        
        WFSSendMessageAction *sendMessageAction = (WFSSendMessageAction *)[actionSchema createObjectWithContext:context error:&error];
        WSTFailOnError(error);
        WSTAssert([sendMessageAction isKindOfClass:[WFSSendMessageAction class]]);
        WSTAssert(sendMessageAction.actions.count == 0);
        
        WSTAssert([sendMessageAction.message isKindOfClass:[WFSSchema class]]);
        WFSMessage *messageToSend = [sendMessageAction messageFromParameterWithName:@"message" context:context];
        WSTAssert([messageToSend isKindOfClass:[WFSMessage class]]);
        WSTAssert([messageToSend.name isEqual:@"test name"]);
        WSTAssert(messageToSend.destinationType == WFSMessageDestinationSelf);
        WSTAssert([messageToSend.destinationName isEqual:@"test destination"]);
        
        WSTTestContext *controllerContext = [[WSTTestContext alloc] init];
        controllerContext.messageResult = [WFSResult successResultWithContext:controllerContext];
        
        WFSScreenController *controller = [[WFSScreenController alloc] init];
        controller.workflowContext = controllerContext;
        
        WSTTestAction *controllerAction = [[WSTTestAction alloc] init];
        controller.actions = @[controllerAction];
        
        WSTTestContext *performanceContext = [[WSTTestContext alloc] init];
        performanceContext.messageResult = [WFSResult successResultWithContext:performanceContext];
        
        WFSResult *resultWithSuccess = [sendMessageAction performActionForController:controller context:performanceContext];
        WSTAssert(resultWithSuccess.isSuccess);
        
        WSTAssert(performanceContext.messages.count == 0);
        WSTAssert(controllerContext.messages.count == 0);
        WSTAssert([WSTTestAction lastTestAction] == controllerAction);
        
        return KIFTestStepResultSuccess;
        
    }]];
    
    return scenario;
}

+ (id)scenarioUnitTestSendMessageActionWithDescendantAction
{
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Test the send message action with a rootDelegate message"];
    
    [scenario addStep:[KIFTestStep stepWithDescription:scenario.description executionBlock:^KIFTestStepResult(KIFTestStep *step, NSError **outError) {
        
        NSError *error = nil;
        
        WFSSchema *actionSchema = [[WFSSchema alloc] initWithTypeName:@"sendMessage" attributes:nil parameters:@[
                                   [[WFSSchema alloc] initWithTypeName:@"message" attributes:nil parameters:@[
                                    [[WFSSchemaParameter alloc] initWithName:@"name" value:@"test name"],
                                    [[WFSSchemaParameter alloc] initWithName:@"destinationType" value:@"descendant"],
                                    [[WFSSchemaParameter alloc] initWithName:@"destinationName" value:@"test_2_3"],
                                    ]]
                                   ]];
        
        WSTTestContext *context = [[WSTTestContext alloc] init];
        
        WFSSendMessageAction *sendMessageAction = (WFSSendMessageAction *)[actionSchema createObjectWithContext:context error:&error];
        WSTFailOnError(error);
        WSTAssert([sendMessageAction isKindOfClass:[WFSSendMessageAction class]]);
        WSTAssert(sendMessageAction.actions.count == 0);
        
        WSTAssert([sendMessageAction.message isKindOfClass:[WFSSchema class]]);
        WFSMessage *messageToSend = [sendMessageAction messageFromParameterWithName:@"message" context:context];
        WSTAssert([messageToSend isKindOfClass:[WFSMessage class]]);
        WSTAssert([messageToSend.name isEqual:@"test name"]);
        WSTAssert(messageToSend.destinationType == WFSMessageDestinationDescendant);
        WSTAssert([messageToSend.destinationName isEqual:@"test_2_3"]);
        
        WSTTestContext *controllerContext = [[WSTTestContext alloc] init];
        controllerContext.messageResult = [WFSResult successResultWithContext:controllerContext];
        
        UIViewController *controller = [[UIViewController alloc] init];
        controller.workflowContext = controllerContext;

        NSMutableArray *actions = [NSMutableArray array];
        
        for (int i = 0; i < 5; i++)
        {
            UIViewController *childController = [[UIViewController alloc] init];
            [controller addChildViewController:childController];
            
            NSMutableArray *childActions = [NSMutableArray array];
            [actions addObject:childActions];
            
            for (int j = 0; j < 5; j++)
            {
                WFSScreenController *grandChildController = [[WFSScreenController alloc] init];
                grandChildController.workflowName = [NSString stringWithFormat:@"test_%d_%d", i, j];
                [childController addChildViewController:grandChildController];
                
                WSTTestAction *controllerAction = [[WSTTestAction alloc] init];
                grandChildController.actions = @[controllerAction];
                
                [childActions addObject:controllerAction];
            }
        }
        
        WSTTestContext *performanceContext = [[WSTTestContext alloc] init];
        performanceContext.messageResult = [WFSResult successResultWithContext:performanceContext];
        
        WFSResult *resultWithSuccess = [sendMessageAction performActionForController:controller context:performanceContext];
        WSTAssert(resultWithSuccess.isSuccess);
        
        WSTAssert(performanceContext.messages.count == 0);
        WSTAssert(controllerContext.messages.count == 0);
        WSTAssert([WSTTestAction lastTestAction] == actions[2][3]);
        
        return KIFTestStepResultSuccess;
        
    }]];
    
    return scenario;
}

+ (id)scenarioUnitTestSendMessageActionWithChildActions
{
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Test the send message action with a delegate message and child actions"];
    
    [scenario addStep:[KIFTestStep stepWithDescription:scenario.description executionBlock:^KIFTestStepResult(KIFTestStep *step, NSError **outError) {
        
        NSError *error = nil;
        
        WFSSchema *actionSchema = [[WFSSchema alloc] initWithTypeName:@"sendMessage" attributes:nil parameters:@[
                                       [[WFSSchema alloc] initWithTypeName:@"message" attributes:nil parameters:@[@"test name"]],
                                       [[WFSSchemaParameter alloc] initWithName:@"actions" value:@[
                                            [[WFSSchema alloc] initWithTypeName:@"testAction" attributes:@{@"name":@"success"} parameters:nil],
                                            [[WFSSchema alloc] initWithTypeName:@"testAction" attributes:nil parameters:nil]
                                       ]],
                                  ]];
        
        WSTTestContext *context = [[WSTTestContext alloc] init];
        
        WFSSendMessageAction *sendMessageAction = (WFSSendMessageAction *)[actionSchema createObjectWithContext:context error:&error];
        WSTFailOnError(error);
        WSTAssert([sendMessageAction isKindOfClass:[WFSSendMessageAction class]]);
        WSTAssert(sendMessageAction.actions.count == 2);
        WSTTestAction *successAction = sendMessageAction.actions[0];
        WSTTestAction *wildcardAction = sendMessageAction.actions[1];
        
        WSTTestContext *controllerContext = [[WSTTestContext alloc] init];
        controllerContext.messageResult = [WFSResult successResultWithContext:controllerContext];
        
        UIViewController *controller = [[UIViewController alloc] init];
        controller.workflowContext = controllerContext;
        
        WSTTestContext *performanceContext = [[WSTTestContext alloc] init];
        performanceContext.messageResult = [WFSResult successResultWithContext:performanceContext];
        
        WFSResult *resultWithSuccess = [sendMessageAction performActionForController:controller context:performanceContext];
        WSTAssert(resultWithSuccess.isSuccess);
        
        WSTAssert(performanceContext.messages.count == 0);
        WSTAssert(controllerContext.messages.count == 1);
        
        WFSMessage *firstMessage = controllerContext.messages[0];
        WSTAssert([firstMessage.name isEqualToString:@"test name"]);
        WSTAssert(firstMessage.destinationType == WFSMessageDestinationDelegate);
        WSTAssert(firstMessage.destinationName == nil);
        WSTAssert([WSTTestAction lastTestAction] == successAction);
        
        controllerContext.messageResult = [WFSResult failureResultWithContext:performanceContext];
        
        WFSResult *resultWithFailure = [sendMessageAction performActionForController:controller context:performanceContext];
        WSTAssert(resultWithFailure.isSuccess); // the message was sent
        
        WSTAssert(performanceContext.messages.count == 0);
        WSTAssert(controllerContext.messages.count == 2);
        
        WFSMessage *secondMessage = controllerContext.messages[1];
        WSTAssert([secondMessage.name isEqualToString:@"test name"]);
        WSTAssert(secondMessage.destinationType == WFSMessageDestinationDelegate);
        WSTAssert(secondMessage.destinationName == nil);
        WSTAssert([WSTTestAction lastTestAction] == wildcardAction);
        
        return KIFTestStepResultSuccess;
        
    }]];
    
    return scenario;
}

+ (id)scenarioUnitTestSendMessageActionWithoutMessage
{
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Test the send message action without a message"];
    
    [scenario addStep:[KIFTestStep stepWithDescription:scenario.description executionBlock:^KIFTestStepResult(KIFTestStep *step, NSError **outError) {
        
        NSError *error = nil;
        
        WFSSchema *actionSchema = [[WFSSchema alloc] initWithTypeName:@"sendMessage" attributes:nil parameters:@[]];
        
        WSTTestContext *context = [[WSTTestContext alloc] init];
        
        WFSSendMessageAction *sendMessageAction = (WFSSendMessageAction *)[actionSchema createObjectWithContext:context error:&error];
        WSTAssert(sendMessageAction == nil);
        WSTAssert(error != nil);
        
        return KIFTestStepResultSuccess;
        
    }]];
    
    return scenario;
}

@end
