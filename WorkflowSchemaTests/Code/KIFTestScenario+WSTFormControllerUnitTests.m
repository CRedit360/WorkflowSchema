//
//  KIFTestScenario+WSTFormControllerUnitTests.m
//  WorkflowSchemaTests
//
//  Created by Simon Booth on 29/10/2012.
//  Copyright (c) 2012 CRedit360. All rights reserved.
//

#import "KIFTestScenario+WSTFormControllerUnitTests.h"
#import "KIFTestStep+WSTShared.h"
#import "WSTAssert.h"
#import "WSTTestAction.h"
#import "WSTTestContext.h"

@implementation KIFTestScenario (WSTFormControllerUnitTests)

+ (id)scenarioUnitTestCreateFormWithImplicitView
{
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Test form controller with implicit view"];
    
    [scenario addStep:[KIFTestStep stepWithDescription:scenario.description executionBlock:^KIFTestStepResult(KIFTestStep *step, NSError **outError) {
        
        NSError *error = nil;
        
        WFSSchema *formSchema = [[WFSSchema alloc] initWithTypeName:@"form" attributes:nil parameters:@[
                                     [[WFSSchema alloc] initWithTypeName:@"container" attributes:nil parameters:@[
                                          [[WFSSchema alloc] initWithTypeName:@"label" attributes:nil parameters:@[ @"Username" ]],
                                          [[WFSSchema alloc] initWithTypeName:@"textField" attributes:@{@"name":@"username"} parameters:@[
                                               [[WFSSchemaParameter alloc] initWithName:@"placeholder" value:@"Please enter your username"]
                                          ]],
                                          [[WFSSchema alloc] initWithTypeName:@"label" attributes:nil parameters:@[ @"Password" ]],
                                          [[WFSSchema alloc] initWithTypeName:@"textField" attributes:@{@"name":@"password"} parameters:@[
                                               [[WFSSchemaParameter alloc] initWithName:@"placeholder" value:@"Please enter your password"]
                                          ]],
                                          [[WFSSchema alloc] initWithTypeName:@"textField" attributes:nil parameters:@[
                                               [[WFSSchemaParameter alloc] initWithName:@"placeholder" value:@"Please confirm your password"]
                                          ]]
                                     ]]
                                ]];
        
        WSTTestContext *context = [[WSTTestContext alloc] init];
        
        WFSFormController *formController = (WFSFormController *)[formSchema createObjectWithContext:context error:&error];
        WSTFailOnError(error);
        WSTAssert([formController isKindOfClass:[WFSFormController class]]);
        
        WFSContainerView *containerView = (WFSContainerView *)formController.formView.hostedView;
        WSTAssert([containerView isKindOfClass:[WFSContainerView class]]);
        
        WSTAssert(containerView.contentViews.count == 5);
        
        NSArray *textFields = @[ containerView.contentViews[1], containerView.contentViews[3], containerView.contentViews[4] ];
        NSDictionary *namedTextFields = @{ @"username":containerView.contentViews[1], @"password":containerView.contentViews[3] };
        
        WSTAssert([formController.allInputs isEqualToArray:textFields]);
        WSTAssert([formController.responsiveInputs isEqualToArray:textFields]);
        WSTAssert([formController.namedInputs isEqualToDictionary:namedTextFields]);
        
        return KIFTestStepResultSuccess;
        
    }]];
    
    return scenario;
}

+ (id)scenarioUnitTestCreateFormWithExplicitView
{
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Test form controller with explicit view"];
    
    [scenario addStep:[KIFTestStep stepWithDescription:scenario.description executionBlock:^KIFTestStepResult(KIFTestStep *step, NSError **outError) {
        
        NSError *error = nil;
        
        WFSSchema *formSchema = [[WFSSchema alloc] initWithTypeName:@"form" attributes:nil parameters:@[
                                     [[WFSSchemaParameter alloc] initWithName:@"view" value:
                                          [[WFSSchema alloc] initWithTypeName:@"container" attributes:nil parameters:@[
                                               [[WFSSchemaParameter alloc] initWithName:@"views" value:@[
                                                    [[WFSSchema alloc] initWithTypeName:@"label" attributes:nil parameters:@[ @"Username" ]],
                                                    [[WFSSchema alloc] initWithTypeName:@"textField" attributes:@{@"name":@"username"} parameters:@[
                                                         [[WFSSchemaParameter alloc] initWithName:@"placeholder" value:@"Please enter your username"]
                                                    ]],
                                                    [[WFSSchema alloc] initWithTypeName:@"label" attributes:nil parameters:@[ @"Password" ]],
                                                    [[WFSSchema alloc] initWithTypeName:@"textField" attributes:@{@"name":@"password"} parameters:@[
                                                         [[WFSSchemaParameter alloc] initWithName:@"placeholder" value:@"Please enter your password"]
                                                    ]],
                                                    [[WFSSchema alloc] initWithTypeName:@"textField" attributes:nil parameters:@[
                                                         [[WFSSchemaParameter alloc] initWithName:@"placeholder" value:@"Please confirm your password"]
                                                    ]]
                                               ]]
                                          ]]
                                     ]
                                ]];
        
        WSTTestContext *context = [[WSTTestContext alloc] init];
        
        WFSFormController *formController = (WFSFormController *)[formSchema createObjectWithContext:context error:&error];
        WSTFailOnError(error);
        WSTAssert([formController isKindOfClass:[WFSFormController class]]);
        
        WFSContainerView *containerView = (WFSContainerView *)formController.formView.hostedView;
        WSTAssert([containerView isKindOfClass:[WFSContainerView class]]);
        
        WSTAssert(containerView.contentViews.count == 5);
        
        NSArray *textFields = @[ containerView.contentViews[1], containerView.contentViews[3], containerView.contentViews[4] ];
        NSDictionary *namedTextFields = @{ @"username":containerView.contentViews[1], @"password":containerView.contentViews[3] };
        
        WSTAssert([formController.allInputs isEqualToArray:textFields]);
        WSTAssert([formController.responsiveInputs isEqualToArray:textFields]);
        WSTAssert([formController.namedInputs isEqualToDictionary:namedTextFields]);
        
        return KIFTestStepResultSuccess;
        
    }]];
    
    return scenario;
}

+ (id)scenarioUnitTestCreateFormWithoutView
{
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Test form controller with explicit view"];
    
    [scenario addStep:[KIFTestStep stepWithDescription:scenario.description executionBlock:^KIFTestStepResult(KIFTestStep *step, NSError **outError) {
        
        NSError *error = nil;
        
        WFSSchema *formSchema = [[WFSSchema alloc] initWithTypeName:@"form" attributes:nil parameters:nil];
        
        WSTTestContext *context = [[WSTTestContext alloc] init];
        
        WFSFormController *formController = (WFSFormController *)[formSchema createObjectWithContext:context error:&error];
        WSTAssert(formController == nil);
        WSTAssert(error != nil);
        
        return KIFTestStepResultSuccess;
        
    }]];
    
    return scenario;
}

+ (id)scenarioUnitTestSubmitFormParameters
{
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Test form controller submission fires action with input values as context parameters"];
    
    [scenario addStep:[KIFTestStep stepWithDescription:scenario.description executionBlock:^KIFTestStepResult(KIFTestStep *step, NSError **outError) {
        
        NSError *error = nil;
        
        WFSSchema *formSchema = [[WFSSchema alloc] initWithTypeName:@"form" attributes:nil parameters:@[
                                     [[WFSSchema alloc] initWithTypeName:@"container" attributes:nil parameters:@[
                                          [[WFSSchema alloc] initWithTypeName:@"textField" attributes:@{@"name":@"thing1"} parameters:@[
                                               [[WFSSchemaParameter alloc] initWithName:@"placeholder" value:@"thing1"],
                                               [[WFSSchemaParameter alloc] initWithName:@"text" value:@"value1"]
                                          ]],
                                          [[WFSSchema alloc] initWithTypeName:@"textField" attributes:@{@"name":@"thing2"} parameters:@[
                                               [[WFSSchemaParameter alloc] initWithName:@"placeholder" value:@"thing2"],
                                               [[WFSSchemaParameter alloc] initWithName:@"text" value:@"value2"]
                                          ]],
                                          [[WFSSchema alloc] initWithTypeName:@"textField" attributes:@{@"name":@"thing3"} parameters:@[
                                               [[WFSSchemaParameter alloc] initWithName:@"placeholder" value:@"thing3a"],
                                               [[WFSSchemaParameter alloc] initWithName:@"text" value:@"value3a"]
                                          ]],
                                          [[WFSSchema alloc] initWithTypeName:@"textField" attributes:@{@"name":@"thing3"} parameters:@[
                                               [[WFSSchemaParameter alloc] initWithName:@"placeholder" value:@"thing3b"],
                                               [[WFSSchemaParameter alloc] initWithName:@"text" value:@"value3b"]
                                          ]],
                                          [[WFSSchema alloc] initWithTypeName:@"textField" attributes:@{@"name":@"thing3"} parameters:@[
                                               [[WFSSchemaParameter alloc] initWithName:@"placeholder" value:@"thing3c"],
                                               [[WFSSchemaParameter alloc] initWithName:@"text" value:@"value3c"]
                                          ]]
                                     ]],
                                     [[WFSSchemaParameter alloc] initWithName:@"actions" value:
                                          [[WFSSchema alloc] initWithTypeName:@"sendMessage" attributes:@{@"name":@"didSubmit"} parameters:@[
                                               [[WFSSchemaParameter alloc] initWithName:@"messageType" value:@"test"],
                                               [[WFSSchemaParameter alloc] initWithName:@"messageName" value:@"test"],
                                               [[WFSSchema alloc] initWithTypeName:@"testAction" attributes:nil parameters:nil]
                                          ]]
                                     ]
                                ]];
        
        WSTTestContext *context = [[WSTTestContext alloc] init];
        
        WFSFormController *formController = (WFSFormController *)[formSchema createObjectWithContext:context error:&error];
        WSTFailOnError(error);
        WSTAssert([formController isKindOfClass:[WFSFormController class]]);
        
        WSTAssert([formController.actions[0] isKindOfClass:[WFSSendMessageAction class]]);
        WSTTestAction *testAction = [(WFSSendMessageAction *)formController.actions[0] actions][0];
        
        [formController loadView];
        WFSMessage *submitMessage = [WFSMessage messageWithType:@"form" name:@"submit" context:context responseHandler:nil];
        
        WFSContext *messageContext = [WFSContext contextWithDelegate:formController];
        [messageContext sendWorkflowMessage:submitMessage];
        WSTAssert([WSTTestAction lastTestAction] == testAction);
        
        WFSMessage *message = [context.messages lastObject];
        WSTAssert([message.context.parameters[@"thing1"] isEqual:@"value1"]);
        WSTAssert([message.context.parameters[@"thing2"] isEqual:@"value2"]);
        
        NSArray *expectedThirdValue = @[ @"value3a", @"value3b", @"value3c" ];
        WSTAssert([message.context.parameters[@"thing3"] isEqual:expectedThirdValue]);
        
        return KIFTestStepResultSuccess;
        
    }]];
    
    return scenario;
}

+ (id)scenarioUnitTestSubmitFormFailure
{
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Test form controller submission failure"];
    
    [scenario addStep:[KIFTestStep stepWithDescription:scenario.description executionBlock:^KIFTestStepResult(KIFTestStep *step, NSError **outError) {
        
        NSError *error = nil;
        
        WFSSchema *formSchema = [[WFSSchema alloc] initWithTypeName:@"form" attributes:nil parameters:@[
                                     [[WFSSchema alloc] initWithTypeName:@"container" attributes:nil parameters:@[
                                          [[WFSSchema alloc] initWithTypeName:@"label" attributes:nil parameters:@[ @"Username" ]],
                                          [[WFSSchema alloc] initWithTypeName:@"textField" attributes:@{@"name":@"username"} parameters:@[
                                               [[WFSSchemaParameter alloc] initWithName:@"placeholder" value:@"Please enter your username"],
                                               [[WFSSchema alloc] initWithTypeName:@"doesMatchRegularExpression" attributes:nil parameters:@[
                                                    [[WFSSchemaParameter alloc] initWithName:@"pattern" value:@"."],
                                                    [[WFSSchemaParameter alloc] initWithName:@"failureMessage" value:@"Please enter a username"]
                                               ]]
                                          ]],
                                          [[WFSSchema alloc] initWithTypeName:@"label" attributes:nil parameters:@[ @"Password" ]],
                                          [[WFSSchema alloc] initWithTypeName:@"textField" attributes:@{@"name":@"password"} parameters:@[
                                               [[WFSSchemaParameter alloc] initWithName:@"placeholder" value:@"Please enter your password"],
                                               [[WFSSchema alloc] initWithTypeName:@"doesMatchRegularExpression" attributes:nil parameters:@[
                                                    [[WFSSchemaParameter alloc] initWithName:@"pattern" value:@"."],
                                                    [[WFSSchemaParameter alloc] initWithName:@"failureMessage" value:@"Please enter a password"]
                                               ]]
                                          ]],
                                          [[WFSSchema alloc] initWithTypeName:@"textField" attributes:nil parameters:@[
                                               [[WFSSchemaParameter alloc] initWithName:@"placeholder" value:@"Please confirm your password"],
                                               [[WFSSchema alloc] initWithTypeName:@"isEqualToInput" attributes:nil parameters:@[@"password"]]
                                          ]]
                                     ]],
                                     [[WFSSchemaParameter alloc] initWithName:@"actions" value:@[
                                      [[WFSSchema alloc] initWithTypeName:@"sendMessage" attributes:@{@"name":@"didSubmit"} parameters:@[
                                               [[WFSSchemaParameter alloc] initWithName:@"messageType" value:@"test"],
                                               [[WFSSchemaParameter alloc] initWithName:@"messageName" value:@"forwardedDidSubmit"]
                                          ]],
                                          [[WFSSchema alloc] initWithTypeName:@"sendMessage" attributes:@{@"name":@"didNotSubmit"} parameters:@[
                                               [[WFSSchemaParameter alloc] initWithName:@"messageType" value:@"test"],
                                               [[WFSSchemaParameter alloc] initWithName:@"messageName" value:@"forwardedDidNotSubmit"]
                                          ]]
                                     ]]
                                ]];
        
        WSTTestContext *context = [[WSTTestContext alloc] init];
        
        WFSFormController *formController = (WFSFormController *)[formSchema createObjectWithContext:context error:&error];
        WSTFailOnError(error);
        WSTAssert([formController isKindOfClass:[WFSFormController class]]);
        
        WSTAssert(formController.actions.count == 2);
        
        WSTTestAction *submitAction = formController.actions[0];
        WSTAssert([submitAction isKindOfClass:[WFSSendMessageAction class]]);
        WSTAssert([submitAction.workflowName isEqual:@"didSubmit"]);
        
        WSTTestAction *failureAction = formController.actions[1];
        WSTAssert([failureAction isKindOfClass:[WFSSendMessageAction class]]);
        WSTAssert([failureAction.workflowName isEqual:@"didNotSubmit"]);
        
        [formController loadView];
        WFSTextField *usernameField = (WFSTextField *)formController.allInputs[0];
        WFSTextField *passwordField = (WFSTextField *)formController.allInputs[1];
        WFSTextField *confirmField = (WFSTextField *)formController.allInputs[2];
        
        WFSMessage *submitMessage = [WFSMessage messageWithType:@"form" name:@"submit" context:context responseHandler:nil];
        WSTAssert(context.messages.count == 0);
        
        WFSContext *messageContext = [WFSContext contextWithDelegate:formController];
        
        [messageContext sendWorkflowMessage:submitMessage];
        WSTAssert(context.messages.count == 1);
        
        WFSMessage *firstMessage = [context.messages lastObject];
        WSTAssert([firstMessage.name isEqualToString:@"forwardedDidNotSubmit"]);
        WSTAssert([firstMessage.context.parameters[@"failureMessage"] isEqualToString:@"Please enter a username"]);
        
        usernameField.text = @"myusername";
        
        [messageContext sendWorkflowMessage:submitMessage];
        WSTAssert(context.messages.count == 2);
        
        WFSMessage *secondMessage = [context.messages lastObject];
        WSTAssert([secondMessage.name isEqualToString:@"forwardedDidNotSubmit"]);
        WSTAssert([secondMessage.context.parameters[@"failureMessage"] isEqualToString:@"Please enter a password"]);
        
        passwordField.text = @"mypassword";
        
        [messageContext sendWorkflowMessage:submitMessage];
        WSTAssert(context.messages.count == 3);
        
        WFSMessage *thirdMessage = [context.messages lastObject];
        WSTAssert([thirdMessage.name isEqualToString:@"forwardedDidNotSubmit"]);
        WSTAssert(thirdMessage.context.parameters[@"failureMessage"] == nil);
        
        confirmField.text = @"mypassword";
        
        [messageContext sendWorkflowMessage:submitMessage];
        WSTAssert(context.messages.count == 4);
        
        WFSMessage *fourthMessage = [context.messages lastObject];
        WSTAssert([fourthMessage.name isEqualToString:@"forwardedDidSubmit"]);
        
        return KIFTestStepResultSuccess;
        
    }]];
    
    return scenario;
}

+ (id)scenarioUnitTestFormsHandleMessages
{
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Test form controller handles 'form' messages and passes on others"];
    
    [scenario addStep:[KIFTestStep stepWithDescription:scenario.description executionBlock:^KIFTestStepResult(KIFTestStep *step, NSError **outError) {
        
        NSError *error = nil;
        
        WFSSchema *formSchema = [[WFSSchema alloc] initWithTypeName:@"form" attributes:nil parameters:@[
                                     [[WFSSchema alloc] initWithTypeName:@"label" attributes:nil parameters:@[ @"Text" ]],
                                     [[WFSSchemaParameter alloc] initWithName:@"actions" value:@[
                                          [[WFSSchema alloc] initWithTypeName:@"testAction" attributes:@{@"name":@"test"} parameters:nil],
                                          [[WFSSchema alloc] initWithTypeName:@"testAction" attributes:nil parameters:nil]
                                     ]]
                                ]];
        
        WSTTestContext *context = [[WSTTestContext alloc] init];
        
        WFSFormController *formController = (WFSFormController *)[formSchema createObjectWithContext:context error:&error];
        WSTFailOnError(error);
        WSTAssert([formController isKindOfClass:[WFSFormController class]]);
        WSTAssert(formController.actions.count == 2);
        
        WSTTestAction *firstAction = formController.actions[0];
        WSTTestAction *secondAction = formController.actions[1];
        
        WFSContext *messageContext = [WFSContext contextWithDelegate:formController];
        
        WFSMessage *firstMessage = [WFSMessage messageWithType:@"form" name:@"test" context:messageContext responseHandler:nil];
        [messageContext sendWorkflowMessage:firstMessage];
        WSTAssert([WSTTestAction lastTestAction] == firstAction);
        
        WFSMessage *secondMessage = [WFSMessage messageWithType:@"form" name:@"different name" context:messageContext responseHandler:nil];
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


+ (id)scenarioUnitTestSendFormMessageFromForm
{
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Test that 'form' messages sent by a form go up a level"];
    
    [scenario addStep:[KIFTestStep stepWithDescription:scenario.description executionBlock:^KIFTestStepResult(KIFTestStep *step, NSError **outError) {
        
        NSError *error = nil;
        
        WFSSchema *formSchema = [[WFSSchema alloc] initWithTypeName:@"form" attributes:nil parameters:@[
                                     [[WFSSchema alloc] initWithTypeName:@"label" attributes:nil parameters:@[ @"Text" ]],
                                     [[WFSSchemaParameter alloc] initWithName:@"actions" value:@[
                                          [[WFSSchema alloc] initWithTypeName:@"sendMessage" attributes:@{@"name":@"test1"} parameters:@[
                                               [[WFSSchemaParameter alloc] initWithName:@"messageType" value:@"form"],
                                               [[WFSSchemaParameter alloc] initWithName:@"messageName" value:@"test2"]
                                          ]]
                                     ]]
                                ]];
        
        WSTTestContext *context = [[WSTTestContext alloc] init];
        
        WFSFormController *formController = (WFSFormController *)[formSchema createObjectWithContext:context error:&error];
        WSTFailOnError(error);
        WSTAssert([formController isKindOfClass:[WFSFormController class]]);
        
        WFSContext *messageContext = [WFSContext contextWithDelegate:formController];
        WFSMessage *messageGoingIn = [WFSMessage messageWithType:@"form" name:@"test1" context:messageContext responseHandler:nil];
        [messageContext sendWorkflowMessage:messageGoingIn];
        WSTAssert(context.messages.count == 1);
        WFSMessage *messageComingOut = context.messages[0];
        WSTAssert([messageComingOut.type isEqual:@"form"]);
        WSTAssert([messageComingOut.name isEqual:@"test2"]);
        
        return KIFTestStepResultSuccess;
        
    }]];
    
    return scenario;
}


@end
