//
//  KIFTestScenario+WSTUnitTests.m
//  WorkflowSchemaTests
//
//  Created by Simon Booth on 26/10/2012.
//  Copyright (c) 2012 CRedit360. All rights reserved.
//

#import "KIFTestScenario+WSTButtonUnitTests.h"
#import "KIFTestStep+WSTShared.h"
#import "WSTAssert.h"
#import "WSTTestAction.h"
#import "WSTTestContext.h"
#import <WorkflowSchema/WorkflowSchema.h>

@implementation KIFTestScenario (WSTUnitTests)

+ (id)scenarioUnitTestCreateButtonWithImplicitAction
{
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Test button creation with implicit action"];
    
    [scenario addStep:[KIFTestStep stepWithDescription:scenario.description executionBlock:^KIFTestStepResult(KIFTestStep *step, NSError **outError) {
      
        NSError *error = nil;
        
        WFSSchema *buttonSchema = [[WFSSchema alloc] initWithTypeName:@"button" attributes:nil parameters:@[
                                       [[WFSSchemaParameter alloc] initWithName:@"title" value:@"Test"],
                                       [[WFSSchemaParameter alloc] initWithName:@"actionName" value:@"didTap"]
                                   ]];
        
        WSTTestContext *context = [[WSTTestContext alloc] init];
        
        WFSButton *button = (WFSButton *)[buttonSchema createObjectWithContext:context error:&error];
        WSTFailOnError(error);
        WSTAssert([button.currentTitle isEqual:@"Test"]);
        WSTAssert([button.actionName isEqual:@"didTap"]);
        
        [button sendActionsForControlEvents:UIControlEventTouchUpInside];
        WSTAssert([[[context.messages lastObject] name] isEqual:@"didTap"]);
        
        return KIFTestStepResultSuccess;
        
    }]];
    
    return scenario;
}

+ (id)scenarioUnitTestCreateButtonWithExplicitAction
{
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Test button creation with explicit action"];
    
    [scenario addStep:[KIFTestStep stepWithDescription:scenario.description executionBlock:^KIFTestStepResult(KIFTestStep *step, NSError **outError) {
        
        NSError *error = nil;
    
        WFSSchema *buttonSchema = [[WFSSchema alloc] initWithTypeName:@"button" attributes:nil parameters:@[
                                       [[WFSSchemaParameter alloc] initWithName:@"title" value:@"Test"],
                                       [[WFSSchemaParameter alloc] initWithName:@"actionName" value:@"didTap"]
                                   ]];
        
        WSTTestContext *context = [[WSTTestContext alloc] init];
        
        WFSButton *button = (WFSButton *)[buttonSchema createObjectWithContext:context error:&error];
        WSTFailOnError(error);
        WSTAssert([button.currentTitle isEqual:@"Test"]);
        WSTAssert([button.actionName isEqual:@"didTap"]);
        
        [button sendActionsForControlEvents:UIControlEventTouchUpInside];
        WSTAssert([[[context.messages lastObject] name] isEqual:@"didTap"]);
        
        return KIFTestStepResultSuccess;
        
    }]];
    
    return scenario;
}


+ (id)scenarioUnitTestCreateButtonWithAccessibilityLabel
{
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Test button creation with implicit action"];
    
    [scenario addStep:[KIFTestStep stepWithDescription:scenario.description executionBlock:^KIFTestStepResult(KIFTestStep *step, NSError **outError) {
        
        NSError *error = nil;
        
        WFSSchema *buttonSchema = [[WFSSchema alloc] initWithTypeName:@"button" attributes:nil parameters:@[
                                       [[WFSSchemaParameter alloc] initWithName:@"accessibilityLabel" value:@"Test"],
                                       [[WFSSchemaParameter alloc] initWithName:@"actionName" value:@"didTap"]
                                  ]];
        
        WSTTestContext *context = [[WSTTestContext alloc] init];
        
        WFSButton *button = (WFSButton *)[buttonSchema createObjectWithContext:context error:&error];
        WSTFailOnError(error);
        WSTAssert([button.accessibilityLabel isEqual:@"Test"]);
        WSTAssert([button.actionName isEqual:@"didTap"]);
        
        [button sendActionsForControlEvents:UIControlEventTouchUpInside];
        WSTAssert([[[context.messages lastObject] name] isEqual:@"didTap"]);
        
        return KIFTestStepResultSuccess;
        
    }]];
    
    return scenario;
}

+ (id)scenarioUnitTestCreateButtonWithoutTitleOrAccessibilityLabel
{
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Test button creation requires a title or accessibility label"];
    
    [scenario addStep:[KIFTestStep stepWithDescription:scenario.description executionBlock:^KIFTestStepResult(KIFTestStep *step, NSError **outError) {
        
        NSError *error = nil;
        
        WFSSchema *buttonSchema = [[WFSSchema alloc] initWithTypeName:@"button" attributes:nil parameters:@[
                                   [[WFSSchema alloc] initWithTypeName:@"testAction" attributes:nil parameters:nil]
                                   ]];
        
        WSTTestContext *context = [[WSTTestContext alloc] init];
        
        WFSButton *button = (WFSButton *)[buttonSchema createObjectWithContext:context error:&error];
        WSTAssert(button == nil);
        WSTAssert(error != nil);
        
        return KIFTestStepResultSuccess;
        
    }]];
    
    return scenario;
}

@end
