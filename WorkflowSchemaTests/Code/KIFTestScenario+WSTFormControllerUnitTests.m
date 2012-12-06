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
                                               [[WFSSchema alloc] initWithTypeName:@"message" attributes:nil parameters:@[ @"test" ]],
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
        WFSMessage *submitMessage = [WFSMessage messageWithName:@"submit" context:context responseHandler:nil];
        
        WFSContext *messageContext = [WFSContext contextWithDelegate:formController];
        [messageContext sendWorkflowMessage:submitMessage];
        WSTAssert([WSTTestAction lastTestAction] == testAction);
        
        WFSMessage *message = [context.messages lastObject];
        WSTAssert([message.context.userInfo[@"thing1"] isEqual:@"value1"]);
        WSTAssert([message.context.userInfo[@"thing2"] isEqual:@"value2"]);
        
        NSArray *expectedThirdValue = @[ @"value3a", @"value3b", @"value3c" ];
        WSTAssert([message.context.userInfo[@"thing3"] isEqual:expectedThirdValue]);
        
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
                                               [[WFSSchema alloc] initWithTypeName:@"isEqual" attributes:nil parameters:@[
                                                [[WFSParameterProxy alloc] initWithTypeName:@"string" attributes:@{ @"keyPath" : @"password" }]
                                               ]]
                                          ]]
                                     ]],
                                     [[WFSSchemaParameter alloc] initWithName:@"actions" value:@[
                                          [[WFSSchema alloc] initWithTypeName:@"sendMessage" attributes:@{@"name":@"didSubmit"} parameters:@[
                                               [[WFSSchema alloc] initWithTypeName:@"message" attributes:nil parameters:@[@"forwardedDidSubmit"]]
                                          ]],
                                          [[WFSSchema alloc] initWithTypeName:@"sendMessage" attributes:@{@"name":@"didNotSubmit"} parameters:@[
                                               [[WFSSchema alloc] initWithTypeName:@"message" attributes:nil parameters:@[@"forwardedDidNotSubmit"]]
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
        
        WFSMessage *submitMessage = [WFSMessage messageWithName:@"submit" context:context responseHandler:nil];
        WSTAssert(context.messages.count == 0);
        
        WFSContext *messageContext = [WFSContext contextWithDelegate:formController];
        
        [messageContext sendWorkflowMessage:submitMessage];
        WSTAssert(context.messages.count == 1);
        
        WFSMessage *firstMessage = [context.messages lastObject];
        WSTAssert([firstMessage.name isEqualToString:@"forwardedDidNotSubmit"]);
        WSTAssert([firstMessage.context.userInfo[@"failureMessage"] isEqualToString:@"Please enter a username"]);
        
        usernameField.text = @"myusername";
        
        [messageContext sendWorkflowMessage:submitMessage];
        WSTAssert(context.messages.count == 2);
        
        WFSMessage *secondMessage = [context.messages lastObject];
        WSTAssert([secondMessage.name isEqualToString:@"forwardedDidNotSubmit"]);
        WSTAssert([secondMessage.context.userInfo[@"failureMessage"] isEqualToString:@"Please enter a password"]);
        
        passwordField.text = @"mypassword";
        
        [messageContext sendWorkflowMessage:submitMessage];
        WSTAssert(context.messages.count == 3);
        
        WFSMessage *thirdMessage = [context.messages lastObject];
        WSTAssert([thirdMessage.name isEqualToString:@"forwardedDidNotSubmit"]);
        WSTAssert(thirdMessage.context.userInfo[@"failureMessage"] == nil);
        
        confirmField.text = @"mypassword";
        
        [messageContext sendWorkflowMessage:submitMessage];
        WSTAssert(context.messages.count == 4);
        
        WFSMessage *fourthMessage = [context.messages lastObject];
        WSTAssert([fourthMessage.name isEqualToString:@"forwardedDidSubmit"]);
        
        return KIFTestStepResultSuccess;
        
    }]];
    
    return scenario;
}

@end
