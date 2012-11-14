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

+ (id)scenarioUnitTestSendMessageActionWithChildActions
{
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Test the send message action with child actions"];
    
    [scenario addStep:[KIFTestStep stepWithDescription:scenario.description executionBlock:^KIFTestStepResult(KIFTestStep *step, NSError **outError) {
        
        NSError *error = nil;
        
        WFSSchema *actionSchema = [[WFSSchema alloc] initWithTypeName:@"sendMessage" attributes:nil parameters:@[
                                       [[WFSSchemaParameter alloc] initWithName:@"messageType" value:@"test type"],
                                       [[WFSSchemaParameter alloc] initWithName:@"messageName" value:@"test name"],
                                       [[WFSSchemaParameter alloc] initWithName:@"actions" value:@[
                                            [[WFSSchema alloc] initWithTypeName:@"testAction" attributes:@{@"name":@"success"} parameters:nil],
                                            [[WFSSchema alloc] initWithTypeName:@"testAction" attributes:nil parameters:nil]
                                       ]],
                                  ]];
        
        WSTTestContext *context = [[WSTTestContext alloc] init];
        
        WFSSendMessageAction *sendMessageAction = (WFSSendMessageAction *)[actionSchema createObjectWithContext:context error:&error];
        WSTFailOnError(error);
        WSTAssert([sendMessageAction isKindOfClass:[WFSSendMessageAction class]]);
        WSTAssert([sendMessageAction.messageType isEqual:@"test type"]);
        WSTAssert([sendMessageAction.messageName isEqual:@"test name"]);
        WSTAssert(sendMessageAction.actions.count == 2);
        WSTTestAction *successAction = sendMessageAction.actions[0];
        WSTTestAction *wildcardAction = sendMessageAction.actions[1];
        
        WSTTestContext *performanceContext = [[WSTTestContext alloc] init];
        performanceContext.messageResult = [WFSResult successResultWithContext:performanceContext];
        
        WFSResult *resultWithSuccess = [sendMessageAction performActionForController:nil context:performanceContext];
        WSTAssert(resultWithSuccess.isSuccess);
        WSTAssert(performanceContext.messages.count == 1);
        WFSMessage *firstMessage = performanceContext.messages[0];
        WSTAssert([firstMessage.type isEqualToString:@"test type"]);
        WSTAssert([firstMessage.name isEqualToString:@"test name"]);
        WSTAssert([WSTTestAction lastTestAction] == successAction);
        
        performanceContext.messageResult = [WFSResult failureResultWithContext:performanceContext];
        
        WFSResult *resultWithFailure = [sendMessageAction performActionForController:nil context:performanceContext];
        WSTAssert(resultWithFailure.isSuccess); // the message was sent
        WSTAssert(performanceContext.messages.count == 2);
        WFSMessage *secondMessage = performanceContext.messages[1];
        WSTAssert([secondMessage.type isEqualToString:@"test type"]);
        WSTAssert([secondMessage.name isEqualToString:@"test name"]);
        WSTAssert([WSTTestAction lastTestAction] == wildcardAction);
        
        return KIFTestStepResultSuccess;
        
    }]];
    
    return scenario;
}

+ (id)scenarioUnitTestSendMessageActionWithoutChildActions
{
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Test the send message action without child actions"];
    
    [scenario addStep:[KIFTestStep stepWithDescription:scenario.description executionBlock:^KIFTestStepResult(KIFTestStep *step, NSError **outError) {
        
        NSError *error = nil;
        
        WFSSchema *actionSchema = [[WFSSchema alloc] initWithTypeName:@"sendMessage" attributes:nil parameters:@[
                                       [[WFSSchemaParameter alloc] initWithName:@"messageType" value:@"test type"],
                                       [[WFSSchemaParameter alloc] initWithName:@"messageName" value:@"test name"]
                                  ]];
        
        WSTTestContext *context = [[WSTTestContext alloc] init];
        
        WFSSendMessageAction *sendMessageAction = (WFSSendMessageAction *)[actionSchema createObjectWithContext:context error:&error];
        WSTFailOnError(error);
        WSTAssert([sendMessageAction isKindOfClass:[WFSSendMessageAction class]]);
        WSTAssert([sendMessageAction.messageType isEqual:@"test type"]);
        WSTAssert([sendMessageAction.messageName isEqual:@"test name"]);
        WSTAssert(sendMessageAction.actions.count == 0);
        
        WSTTestContext *performanceContext = [[WSTTestContext alloc] init];
        performanceContext.messageResult = [WFSResult successResultWithContext:performanceContext];
        
        WFSResult *resultWithSuccess = [sendMessageAction performActionForController:nil context:performanceContext];
        WSTAssert(resultWithSuccess.isSuccess);
        WSTAssert(performanceContext.messages.count == 1);
        WFSMessage *firstMessage = performanceContext.messages[0];
        WSTAssert([firstMessage.type isEqualToString:@"test type"]);
        WSTAssert([firstMessage.name isEqualToString:@"test name"]);
        
        return KIFTestStepResultSuccess;
        
    }]];
    
    return scenario;
}

+ (id)scenarioUnitTestSendMessageActionWithoutName
{
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Test the send message action without a message name"];
    
    [scenario addStep:[KIFTestStep stepWithDescription:scenario.description executionBlock:^KIFTestStepResult(KIFTestStep *step, NSError **outError) {
        
        NSError *error = nil;
        
        WFSSchema *actionSchema = [[WFSSchema alloc] initWithTypeName:@"sendMessage" attributes:nil parameters:@[
                                   [[WFSSchemaParameter alloc] initWithName:@"messageType" value:@"test type"],
                                   ]];
        
        WSTTestContext *context = [[WSTTestContext alloc] init];
        
        WFSSendMessageAction *sendMessageAction = (WFSSendMessageAction *)[actionSchema createObjectWithContext:context error:&error];
        WSTAssert(sendMessageAction == nil);
        WSTAssert(error != nil);
        
        return KIFTestStepResultSuccess;
        
    }]];
    
    return scenario;
}

+ (id)scenarioUnitTestSendMessageActionWithoutType
{
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Test the send message action without a message type"];
    
    [scenario addStep:[KIFTestStep stepWithDescription:scenario.description executionBlock:^KIFTestStepResult(KIFTestStep *step, NSError **outError) {
        
        NSError *error = nil;
        
        WFSSchema *actionSchema = [[WFSSchema alloc] initWithTypeName:@"sendMessage" attributes:nil parameters:@[
                                   [[WFSSchemaParameter alloc] initWithName:@"messageName" value:@"test name"],
                                   ]];
        
        WSTTestContext *context = [[WSTTestContext alloc] init];
        
        WFSSendMessageAction *sendMessageAction = (WFSSendMessageAction *)[actionSchema createObjectWithContext:context error:&error];
        WSTAssert(sendMessageAction == nil);
        WSTAssert(error != nil);
        
        return KIFTestStepResultSuccess;
        
    }]];
    
    return scenario;
}


@end
