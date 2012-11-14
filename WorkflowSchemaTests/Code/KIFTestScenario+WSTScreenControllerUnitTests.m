//
//  KIFTestScenario+WSTScreenControllerUnitTests.m
//  WorkflowSchemaTests
//
//  Created by Simon Booth on 26/10/2012.
//  Copyright (c) 2012 CRedit360. All rights reserved.
//

#import "KIFTestScenario+WSTScreenControllerUnitTests.h"
#import "KIFTestStep+WSTShared.h"
#import "WSTAssert.h"
#import "WSTTestAction.h"
#import "WSTTestContext.h"

@implementation KIFTestScenario (WSTScreenControllerUnitTests)

+ (id)scenarioUnitTestCreateScreenWithImplicitView
{
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Test screen controller with implicit view"];
    
    [scenario addStep:[KIFTestStep stepWithDescription:scenario.description executionBlock:^KIFTestStepResult(KIFTestStep *step, NSError **outError) {
        
        NSError *error = nil;
        
        WFSSchema *screenSchema = [[WFSSchema alloc] initWithTypeName:@"screen" attributes:nil parameters:@[
                                   [[WFSSchema alloc] initWithTypeName:@"label" attributes:nil parameters:@[ @"Text" ]]
                                   ]];
        
        WSTTestContext *context = [[WSTTestContext alloc] init];
        
        WFSScreenController *screenController = (WFSScreenController *)[screenSchema createObjectWithContext:context error:&error];
        WSTFailOnError(error);
        WSTAssert([screenController isKindOfClass:[WFSScreenController class]]);
        WSTAssert([screenController.screenView.hostedView isKindOfClass:[WFSLabel class]]);
        
        return KIFTestStepResultSuccess;
        
    }]];
    
    return scenario;
}

+ (id)scenarioUnitTestCreateScreenWithExplicitView
{
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Test screen controller with explicit view"];
    
    [scenario addStep:[KIFTestStep stepWithDescription:scenario.description executionBlock:^KIFTestStepResult(KIFTestStep *step, NSError **outError) {
        
        NSError *error = nil;
        
        WFSSchema *screenSchema = [[WFSSchema alloc] initWithTypeName:@"screen" attributes:nil parameters:@[
                                       [[WFSSchemaParameter alloc] initWithName:@"view" value:[[WFSSchema alloc] initWithTypeName:@"label" attributes:nil parameters:@[ @"Text" ]]]
                                   ]];
        
        WSTTestContext *context = [[WSTTestContext alloc] init];
        
        WFSScreenController *screenController = (WFSScreenController *)[screenSchema createObjectWithContext:context error:&error];
        WSTFailOnError(error);
        WSTAssert([screenController isKindOfClass:[WFSScreenController class]]);
        WSTAssert([screenController.screenView.hostedView isKindOfClass:[WFSLabel class]]);
        
        return KIFTestStepResultSuccess;
        
    }]];
    
    return scenario;
}

+ (id)scenarioUnitTestCreateScreenWithoutView
{
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Test screen controller without view"];
    
    [scenario addStep:[KIFTestStep stepWithDescription:scenario.description executionBlock:^KIFTestStepResult(KIFTestStep *step, NSError **outError) {
        
        NSError *error = nil;
        
        WFSSchema *screenSchema = [[WFSSchema alloc] initWithTypeName:@"screen" attributes:nil parameters:nil];
        
        WSTTestContext *context = [[WSTTestContext alloc] init];
        
        WFSScreenController *screenController = (WFSScreenController *)[screenSchema createObjectWithContext:context error:&error];
        WSTFailOnError(error);
        WSTAssert([screenController isKindOfClass:[WFSScreenController class]]);
        WSTAssert(screenController.screenView.hostedView == nil);
        
        return KIFTestStepResultSuccess;
        
        return KIFTestStepResultSuccess;
        
    }]];
    
    return scenario;
}

+ (id)scenarioUnitTestCreateScreenWithAnotherControllerAsItsView
{
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Test screen controller with another controller as its view"];
    
    [scenario addStep:[KIFTestStep stepWithDescription:scenario.description executionBlock:^KIFTestStepResult(KIFTestStep *step, NSError **outError) {
        
        NSError *error = nil;
        
        WFSSchema *screenSchema = [[WFSSchema alloc] initWithTypeName:@"screen" attributes:nil parameters:@[
                                       [[WFSSchema alloc] initWithTypeName:@"screen" attributes:nil parameters:nil]
                                   ]];
        
        WSTTestContext *context = [[WSTTestContext alloc] init];
        
        WFSScreenController *screenController = (WFSScreenController *)[screenSchema createObjectWithContext:context error:&error];
        WSTFailOnError(error);
        WSTAssert([screenController isKindOfClass:[WFSScreenController class]]);
        WSTAssert([screenController.screenView.hostedView isKindOfClass:[WFSScreenView class]]);
        
        return KIFTestStepResultSuccess;
        
        return KIFTestStepResultSuccess;
        
    }]];
    
    return scenario;
}

+ (id)scenarioUnitTestCreateScreenWithOtherOptions
{
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Test screen controller with other options"];
    
    [scenario addStep:[KIFTestStep stepWithDescription:scenario.description executionBlock:^KIFTestStepResult(KIFTestStep *step, NSError **outError) {
        
        NSError *error = nil;
        
        WFSSchema *screenSchema = [[WFSSchema alloc] initWithTypeName:@"screen" attributes:nil parameters:@[
                                       [[WFSSchemaParameter alloc] initWithName:@"title" value:@"Test title"],
                                       [[WFSSchemaParameter alloc] initWithName:@"hidesBottomBarWhenPushed" value:@"YES"],
                                       [[WFSSchema alloc] initWithTypeName:@"navigationItem" attributes:nil parameters:@[
                                            [[WFSSchemaParameter alloc] initWithName:@"title" value:@"Test navigationItem title"],
                                            [[WFSSchemaParameter alloc] initWithName:@"hidesBackButton" value:@"YES"],
                                            [[WFSSchemaParameter alloc] initWithName:@"backBarButtonItem" value:@"TBBI"],
                                            [[WFSSchemaParameter alloc] initWithName:@"leftBarButtonItems" value:@[
                                                 [[WFSSchema alloc] initWithTypeName:@"barButtonItem" attributes:nil parameters:@[
                                                      [[WFSSchemaParameter alloc] initWithName:@"title" value:@"Left"],
                                                      [[WFSSchemaParameter alloc] initWithName:@"actionName" value:@"didSelectLeftNavigationButton"]
                                                  ]]
                                             ]],
                                            [[WFSSchemaParameter alloc] initWithName:@"rightBarButtonItems" value:@[
                                                 [[WFSSchema alloc] initWithTypeName:@"barButtonItem" attributes:nil parameters:@[
                                                      [[WFSSchema alloc] initWithTypeName:@"image" attributes:nil parameters:@[@"first"]],
                                                      [[WFSSchemaParameter alloc] initWithName:@"actionName" value:@"didSelectRightNavigationButton1"],
                                                      [[WFSSchemaParameter alloc] initWithName:@"accessibilityLabel" value:@"Right 1"]
                                                  ]],
                                                 [[WFSSchema alloc] initWithTypeName:@"barButtonItem" attributes:nil parameters:@[
                                                      [[WFSSchema alloc] initWithTypeName:@"image" attributes:nil parameters:@[@"second"]],
                                                      [[WFSSchemaParameter alloc] initWithName:@"actionName" value:@"didSelectRightNavigationButton2"],
                                                      [[WFSSchemaParameter alloc] initWithName:@"accessibilityLabel" value:@"Right 2"]
                                                  ]]
                                             ]],
                                        ]],
                                       [[WFSSchema alloc] initWithTypeName:@"tabBarItem" attributes:nil parameters:@[
                                            [[WFSSchemaParameter alloc] initWithName:@"title" value:@"Test tabBarItem title"],
                                            [[WFSSchema alloc] initWithTypeName:@"image" attributes:nil parameters:@[@"first"]],
                                        ]],
                                       [[WFSSchemaParameter alloc] initWithName:@"toolbarItems" value:@[
                                            [[WFSSchema alloc] initWithTypeName:@"barButtonItem" attributes:nil parameters:@[
                                                 [[WFSSchemaParameter alloc] initWithName:@"title" value:@"TB Left"],
                                                 [[WFSSchemaParameter alloc] initWithName:@"actionName" value:@"didSelectLeftToolbarButton"]
                                             ]],
                                            [[WFSSchema alloc] initWithTypeName:@"barButtonItem" attributes:nil parameters:@[
                                                 [[WFSSchemaParameter alloc] initWithName:@"systemItem" value:@"flexibleSpace"]
                                             ]],
                                            [[WFSSchema alloc] initWithTypeName:@"barButtonItem" attributes:nil parameters:@[
                                                 [[WFSSchemaParameter alloc] initWithName:@"title" value:@"TB Right"],
                                                 [[WFSSchemaParameter alloc] initWithName:@"actionName" value:@"didSelectRightToolbarButton"]
                                             ]]
                                        ]]
                                   ]];
        
        WSTTestContext *context = [[WSTTestContext alloc] init];
        
        WFSScreenController *screenController = (WFSScreenController *)[screenSchema createObjectWithContext:context error:&error];
        WSTFailOnError(error);
        WSTAssert([screenController isKindOfClass:[WFSScreenController class]]);
        
        WSTAssert([screenController.title isEqual:@"Test title"]);
        WSTAssert(screenController.hidesBottomBarWhenPushed);
        
        WSTAssert([screenController.navigationItem.title isEqual:@"Test navigationItem title"]);
        WSTAssert(screenController.navigationItem.hidesBackButton);
        WSTAssert([screenController.navigationItem.backBarButtonItem.title isEqual:@"TBBI"]);
        WSTAssert(screenController.navigationItem.leftBarButtonItems.count == 1);
        WSTAssert([[(UIBarButtonItem *)screenController.navigationItem.leftBarButtonItems[0] title] isEqual:@"Left"]);
        WSTAssert(screenController.navigationItem.rightBarButtonItems.count == 2);
        WSTAssertEqualImages([(UIBarButtonItem *)screenController.navigationItem.rightBarButtonItems[0] image], [UIImage imageNamed:@"first"]);
        WSTAssertEqualImages([(UIBarButtonItem *)screenController.navigationItem.rightBarButtonItems[1] image], [UIImage imageNamed:@"second"]);
        
        WSTAssert([screenController.tabBarItem.title isEqual:@"Test tabBarItem title"]);
        WSTAssertEqualImages(screenController.tabBarItem.image, [UIImage imageNamed:@"first"]);
        
        WSTAssert(screenController.toolbarItems.count == 3);
        WSTAssert([[(UIBarButtonItem *)screenController.toolbarItems[0] title] isEqual:@"TB Left"]);
        WSTAssert([[(UIBarButtonItem *)screenController.toolbarItems[2] title] isEqual:@"TB Right"]);
        
        return KIFTestStepResultSuccess;
        
    }]];
    
    return scenario;
}

+ (id)scenarioUnitTestScreenViewDidLoad
{
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Test screen controller viewDidLoad action"];
    
    [scenario addStep:[KIFTestStep stepWithDescription:scenario.description executionBlock:^KIFTestStepResult(KIFTestStep *step, NSError **outError) {
        
        NSError *error = nil;
        
        WFSSchema *screenSchema = [[WFSSchema alloc] initWithTypeName:@"screen" attributes:nil parameters:@[
                                       [[WFSSchemaParameter alloc] initWithName:@"actions" value:
                                            [[WFSSchema alloc] initWithTypeName:@"testAction" attributes:@{@"pattern":@"viewDidLoad"} parameters:nil]
                                        ]
                                   ]];
        
        WSTTestContext *context = [[WSTTestContext alloc] init];
        
        WFSScreenController *screenController = (WFSScreenController *)[screenSchema createObjectWithContext:context error:&error];
        WSTFailOnError(error);
        WSTAssert([screenController isKindOfClass:[WFSScreenController class]]);
        WSTAssert(screenController.actions.count == 1);
        
        WSTTestAction *action = screenController.actions[0];
        WSTAssert([action isKindOfClass:[WSTTestAction class]])

        __unused id forceViewToLoad = screenController.view;
        WSTAssert([WSTTestAction lastTestAction] == action);
        
        return KIFTestStepResultSuccess;
        
    }]];
    
    return scenario;
}

+ (id)scenarioUnitTestScreensHandleMessages
{
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Test screen controller handles 'screen' messages and passes on others"];
    
    [scenario addStep:[KIFTestStep stepWithDescription:scenario.description executionBlock:^KIFTestStepResult(KIFTestStep *step, NSError **outError) {
        
        NSError *error = nil;
        
        WFSSchema *screenSchema = [[WFSSchema alloc] initWithTypeName:@"screen" attributes:nil parameters:@[
                                   [[WFSSchema alloc] initWithTypeName:@"label" attributes:nil parameters:@[ @"Text" ]],
                                   [[WFSSchemaParameter alloc] initWithName:@"actions" value:@[
                                    [[WFSSchema alloc] initWithTypeName:@"testAction" attributes:@{@"name":@"test"} parameters:nil],
                                    [[WFSSchema alloc] initWithTypeName:@"testAction" attributes:nil parameters:nil]
                                    ]]
                                   ]];
        
        WSTTestContext *context = [[WSTTestContext alloc] init];
        
        WFSScreenController *screenController = (WFSScreenController *)[screenSchema createObjectWithContext:context error:&error];
        WSTFailOnError(error);
        WSTAssert([screenController isKindOfClass:[WFSScreenController class]]);
        WSTAssert(screenController.actions.count == 2);
        
        WSTTestAction *firstAction = screenController.actions[0];
        WSTTestAction *secondAction = screenController.actions[1];
        
        WFSContext *messageContext = [WFSContext contextWithDelegate:screenController];
        
        WFSMessage *firstMessage = [WFSMessage messageWithType:@"screen" name:@"test" context:messageContext responseHandler:nil];
        [messageContext sendWorkflowMessage:firstMessage];
        WSTAssert([WSTTestAction lastTestAction] == firstAction);
        
        WFSMessage *secondMessage = [WFSMessage messageWithType:@"screen" name:@"different name" context:messageContext responseHandler:nil];
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

+ (id)scenarioUnitTestSendScreenMessageFromScreen
{
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Test that 'screen' messages sent by a screen go up a level"];
    
    [scenario addStep:[KIFTestStep stepWithDescription:scenario.description executionBlock:^KIFTestStepResult(KIFTestStep *step, NSError **outError) {
        
        NSError *error = nil;
        
        WFSSchema *screenSchema = [[WFSSchema alloc] initWithTypeName:@"screen" attributes:nil parameters:@[
                                       [[WFSSchema alloc] initWithTypeName:@"label" attributes:nil parameters:@[ @"Text" ]],
                                       [[WFSSchemaParameter alloc] initWithName:@"actions" value:@[
                                            [[WFSSchema alloc] initWithTypeName:@"sendMessage" attributes:@{@"name":@"test1"} parameters:@[
                                                 [[WFSSchemaParameter alloc] initWithName:@"messageType" value:@"screen"],
                                                 [[WFSSchemaParameter alloc] initWithName:@"messageName" value:@"test2"]
                                            ]]
                                       ]]
                                  ]];
        
        WSTTestContext *context = [[WSTTestContext alloc] init];
        
        WFSScreenController *screenController = (WFSScreenController *)[screenSchema createObjectWithContext:context error:&error];
        WSTFailOnError(error);
        WSTAssert([screenController isKindOfClass:[WFSScreenController class]]);
        
        WFSContext *messageContext = [WFSContext contextWithDelegate:screenController];
        WFSMessage *messageGoingIn = [WFSMessage messageWithType:@"screen" name:@"test1" context:messageContext responseHandler:nil];
        [messageContext sendWorkflowMessage:messageGoingIn];
        WSTAssert(context.messages.count == 1);
        WFSMessage *messageComingOut = context.messages[0];
        WSTAssert([messageComingOut.type isEqual:@"screen"]);
        WSTAssert([messageComingOut.name isEqual:@"test2"]);
        
        return KIFTestStepResultSuccess;
        
    }]];
    
    return scenario;
}


@end
