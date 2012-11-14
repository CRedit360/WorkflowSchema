//
//  KIFTestScenario+WSTAlertViewTests.m
//  WorkflowSchemaTests
//
//  Created by Simon Booth on 29/10/2012.
//  Copyright (c) 2012 CRedit360. All rights reserved.
//

#import "KIFTestScenario+WSTAlertViewTests.h"
#import "KIFTestStep+WSTShared.h"
#import "WSTAssert.h"
#import "WSTTestAction.h"
#import "WSTTestContext.h"

@implementation KIFTestScenario (WSTAlertViewTests)

+ (id)scenarioUnitTestAlertViewWithImplicitMessage
{
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Test showing an alert view with implicit message"];
    
    [scenario addStep:[KIFTestStep stepWithDescription:scenario.description executionBlock:^KIFTestStepResult(KIFTestStep *step, NSError **outError) {
        
        NSError *error = nil;
        
        WFSSchema *actionSchema = [[WFSSchema alloc] initWithTypeName:@"showAlert" attributes:nil parameters:@[
                                    @"Test message"
                                   ]];
        
        WSTTestContext *context = [[WSTTestContext alloc] init];
        
        WFSShowAlertAction *showAlertAction = (WFSShowAlertAction *)[actionSchema createObjectWithContext:context error:&error];
        WSTFailOnError(error);
        WSTAssert([showAlertAction isKindOfClass:[WFSShowAlertAction class]]);
        
        UIAlertView *alertView = [showAlertAction alertViewWithContext:context error:&error];
        WSTFailOnError(error);
        
        WSTAssert([alertView isKindOfClass:[UIAlertView class]]);
        WSTAssert(!alertView.title);
        WSTAssert([alertView.message isEqual:@"Test message"]);
        WSTAssert(alertView.numberOfButtons == 1);
        WSTAssert([[alertView buttonTitleAtIndex:0] isEqual:@"OK"]);
        
        return KIFTestStepResultSuccess;
        
    }]];
            
    return scenario;
}

+ (id)scenarioUnitTestAlertViewWithExplicitProperties
{
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Test showing an alert view with explicit properties"];
    
    [scenario addStep:[KIFTestStep stepWithDescription:scenario.description executionBlock:^KIFTestStepResult(KIFTestStep *step, NSError **outError) {
        
        NSError *error = nil;
        
        WFSSchema *actionSchema = [[WFSSchema alloc] initWithTypeName:@"showAlert" attributes:nil parameters:@[
                                       [[WFSSchemaParameter alloc] initWithName:@"title" value:@"Test title"],
                                       [[WFSSchemaParameter alloc] initWithName:@"message" value:@"Test message"],
                                       [[WFSSchema alloc] initWithTypeName:@"cancelButtonItem" attributes:nil parameters:@[
                                            [[WFSSchemaParameter alloc] initWithName:@"title" value:@"Cancel"],
                                            [[WFSSchemaParameter alloc] initWithName:@"actionName" value:@"didCancel"]
                                       ]],
                                       [[WFSSchema alloc] initWithTypeName:@"actionButtonItem" attributes:nil parameters:@[
                                            [[WFSSchemaParameter alloc] initWithName:@"title" value:@"Yes"],
                                            [[WFSSchemaParameter alloc] initWithName:@"actionName" value:@"didSelectYes"]
                                       ]],
                                       [[WFSSchema alloc] initWithTypeName:@"actionButtonItem" attributes:nil parameters:@[
                                            [[WFSSchemaParameter alloc] initWithName:@"title" value:@"No"],
                                            [[WFSSchemaParameter alloc] initWithName:@"actionName" value:@"didSelectNo"]
                                       ]],
                                  ]];
        
        WSTTestContext *context = [[WSTTestContext alloc] init];
        
        WFSShowAlertAction *showAlertAction = (WFSShowAlertAction *)[actionSchema createObjectWithContext:context error:&error];
        WSTFailOnError(error);
        WSTAssert([showAlertAction isKindOfClass:[WFSShowAlertAction class]]);
        
        UIAlertView *alertView = [showAlertAction alertViewWithContext:context error:&error];
        WSTFailOnError(error);
        
        WSTAssert([alertView isKindOfClass:[UIAlertView class]]);
        WSTAssert([alertView.title isEqual:@"Test title"]);
        WSTAssert([alertView.message isEqual:@"Test message"]);
        
        // The cancel button comes last; order of others is preserved.
        WSTAssert(alertView.numberOfButtons == 3);
        WSTAssert([[alertView buttonTitleAtIndex:0] isEqual:@"Yes"]);
        WSTAssert([[alertView buttonTitleAtIndex:1] isEqual:@"No"]);
        WSTAssert([[alertView buttonTitleAtIndex:2] isEqual:@"Cancel"]);
        WSTAssert(alertView.cancelButtonIndex == 2);
        
        // Clicking the button should perform the action
        WSTAssert(alertView.delegate == showAlertAction);
        [showAlertAction alertView:alertView clickedButtonAtIndex:0];
        WSTAssert([[[context.messages lastObject] name] isEqual:@"didSelectYes"]);
        [showAlertAction alertView:alertView clickedButtonAtIndex:1];
        WSTAssert([[[context.messages lastObject] name] isEqual:@"didSelectNo"]);
        [showAlertAction alertView:alertView clickedButtonAtIndex:2];
        WSTAssert([[[context.messages lastObject] name] isEqual:@"didCancel"]);
        
        return KIFTestStepResultSuccess;
        
    }]];
    
    return scenario;
}

+ (id)scenarioUnitTestAlertViewWithoutMessage
{
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Test showing an alert view without a message"];
    
    [scenario addStep:[KIFTestStep stepWithDescription:scenario.description executionBlock:^KIFTestStepResult(KIFTestStep *step, NSError **outError) {
        
        NSError *error = nil;
        
        WFSSchema *actionSchema = [[WFSSchema alloc] initWithTypeName:@"showAlert" attributes:nil parameters:nil];
        
        WSTTestContext *context = [[WSTTestContext alloc] init];
        
        WFSShowAlertAction *showAlertAction = (WFSShowAlertAction *)[actionSchema createObjectWithContext:context error:&error];
        WSTAssert(showAlertAction == nil);
        WSTAssert(error != nil);
        
        return KIFTestStepResultSuccess;
        
    }]];
    
    return scenario;
}

@end
