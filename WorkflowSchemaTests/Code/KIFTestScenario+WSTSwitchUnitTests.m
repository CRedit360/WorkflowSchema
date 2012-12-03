//
//  KIFTestScenario+WSTSwitchUnitTests.m
//  WorkflowSchemaTests
//
//  Created by Simon Booth on 26/11/2012.
//  Copyright (c) 2012 CRedit360. All rights reserved.
//

#import "KIFTestScenario+WSTSwitchUnitTests.h"
#import "KIFTestStep+WSTShared.h"
#import "WSTAssert.h"
#import "WSTTestAction.h"
#import "WSTTestContext.h"
#import <WorkflowSchema/WorkflowSchema.h>

@implementation KIFTestScenario (WSTSwitchTests)

+ (id)scenarioUnitTestCreateSwitchWithoutValues
{
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Test switch creation without values"];
    
    [scenario addStep:[KIFTestStep stepWithDescription:scenario.description executionBlock:^KIFTestStepResult(KIFTestStep *step, NSError **outError) {
        
        NSError *error = nil;
        
        WFSSchema *switchSchema = [[WFSSchema alloc] initWithTypeName:@"switch" attributes:nil parameters:@[
                                       [[WFSSchemaParameter alloc] initWithName:@"accessibilityLabel" value:@"test"],
                                       [[WFSSchemaParameter alloc] initWithName:@"on" value:@"YES"],
                                       [[WFSSchema alloc] initWithTypeName:@"message" attributes:nil parameters:@[ @"didSwitch" ]]
                                  ]];
        
        WSTTestContext *context = [[WSTTestContext alloc] init];
        
        WFSSwitch *theSwitch = (WFSSwitch *)[switchSchema createObjectWithContext:context error:&error];
        WSTFailOnError(error);
        WSTAssert([theSwitch.accessibilityLabel isEqualToString:@"test"]);
        WSTAssert(theSwitch.on);
        WSTAssert(theSwitch.onValue == nil);
        WSTAssert(theSwitch.offValue == nil);
        WSTAssert([theSwitch.formValue isEqual:@(YES)]);
        
        theSwitch.on = NO;
        WSTAssert([theSwitch.formValue isEqual:@(NO)]);
        
        [theSwitch sendActionsForControlEvents:UIControlEventValueChanged];
        WSTAssert([[[context.messages lastObject] name] isEqual:@"didSwitch"]);
        
        return KIFTestStepResultSuccess;
        
    }]];
    
    return scenario;
}

+ (id)scenarioUnitTestCreateSwitchWithOnAndOffValues
{
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Test switch creation with on and off values"];
    
    [scenario addStep:[KIFTestStep stepWithDescription:scenario.description executionBlock:^KIFTestStepResult(KIFTestStep *step, NSError **outError) {
        
        NSError *error = nil;
        
        WFSSchema *switchSchema = [[WFSSchema alloc] initWithTypeName:@"switch" attributes:nil parameters:@[
                                       [[WFSSchemaParameter alloc] initWithName:@"accessibilityLabel" value:@"test"],
                                       [[WFSSchemaParameter alloc] initWithName:@"on" value:@"YES"],
                                       [[WFSSchemaParameter alloc] initWithName:@"onValue" value:@"123"],
                                       [[WFSSchemaParameter alloc] initWithName:@"offValue" value:@"345"],
                                       [[WFSSchema alloc] initWithTypeName:@"message" attributes:nil parameters:@[ @"didSwitch" ]]
                                  ]];
        
        WSTTestContext *context = [[WSTTestContext alloc] init];
        
        WFSSwitch *theSwitch = (WFSSwitch *)[switchSchema createObjectWithContext:context error:&error];
        WSTFailOnError(error);
        WSTAssert([theSwitch.accessibilityLabel isEqualToString:@"test"]);
        WSTAssert(theSwitch.on);
        WSTAssert([theSwitch.onValue isEqual:@"123"]);
        WSTAssert([theSwitch.offValue isEqual:@"345"]);
        WSTAssert([theSwitch.formValue isEqual:@"123"]);
        
        theSwitch.on = NO;
        WSTAssert([theSwitch.formValue isEqual:@"345"]);
        
        [theSwitch sendActionsForControlEvents:UIControlEventValueChanged];
        WSTAssert([[[context.messages lastObject] name] isEqual:@"didSwitch"]);
        
        return KIFTestStepResultSuccess;
        
    }]];
    
    return scenario;
}

+ (id)scenarioUnitTestCreateSwitchWithOnValueButNoOffValue
{
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Test switch creation with on value but no off value"];
    
    [scenario addStep:[KIFTestStep stepWithDescription:scenario.description executionBlock:^KIFTestStepResult(KIFTestStep *step, NSError **outError) {
        
        NSError *error = nil;
        
        WFSSchema *switchSchema = [[WFSSchema alloc] initWithTypeName:@"switch" attributes:nil parameters:@[
                                       [[WFSSchemaParameter alloc] initWithName:@"accessibilityLabel" value:@"test"],
                                       [[WFSSchemaParameter alloc] initWithName:@"on" value:@"YES"],
                                       [[WFSSchemaParameter alloc] initWithName:@"onValue" value:@"123"],
                                       [[WFSSchema alloc] initWithTypeName:@"message" attributes:nil parameters:@[ @"didSwitch" ]]
                                  ]];
        
        WSTTestContext *context = [[WSTTestContext alloc] init];
        
        WFSSwitch *theSwitch = (WFSSwitch *)[switchSchema createObjectWithContext:context error:&error];
        WSTAssert(error);
        WSTAssert(!theSwitch);
        
        return KIFTestStepResultSuccess;
        
    }]];
    
    return scenario;
}

+ (id)scenarioUnitTestCreateSwitchWithoutAccessibilityLabel
{
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Test switch creation without accessibility label"];
    
    [scenario addStep:[KIFTestStep stepWithDescription:scenario.description executionBlock:^KIFTestStepResult(KIFTestStep *step, NSError **outError) {
        
        NSError *error = nil;
        
        WFSSchema *switchSchema = [[WFSSchema alloc] initWithTypeName:@"switch" attributes:nil parameters:@[
                                       [[WFSSchemaParameter alloc] initWithName:@"on" value:@"YES"],
                                       [[WFSSchemaParameter alloc] initWithName:@"onValue" value:@"123"],
                                       [[WFSSchemaParameter alloc] initWithName:@"offValue" value:@"345"],
                                       [[WFSSchema alloc] initWithTypeName:@"message" attributes:nil parameters:@[ @"didSwitch" ]]
                                  ]];
        
        WSTTestContext *context = [[WSTTestContext alloc] init];
        
        WFSSwitch *theSwitch = (WFSSwitch *)[switchSchema createObjectWithContext:context error:&error];
        WSTAssert(error);
        WSTAssert(!theSwitch);
        
        return KIFTestStepResultSuccess;
        
    }]];
    
    return scenario;
}

@end
