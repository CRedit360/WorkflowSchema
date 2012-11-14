//
//  KIFTestScenario+WSTUnitTests.m
//  WorkflowSchemaTests
//
//  Created by Simon Booth on 26/10/2012.
//  Copyright (c) 2012 CRedit360. All rights reserved.
//

#import "KIFTestScenario+WSTLabelUnitTests.h"
#import "KIFTestStep+WSTShared.h"
#import "WSTAssert.h"
#import "WSTTestAction.h"
#import "WSTTestContext.h"
#import <WorkflowSchema/WorkflowSchema.h>

@implementation KIFTestScenario (WSTUnitTests)

+ (id)scenarioUnitTestCreateLabelWithImplicitText
{
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Test label creation with implicit text"];
    
    [scenario addStep:[KIFTestStep stepWithDescription:scenario.description executionBlock:^KIFTestStepResult(KIFTestStep *step, NSError **outError) {
        
        NSError *error = nil;
        
        WFSSchema *labelSchema = [[WFSSchema alloc] initWithTypeName:@"label" attributes:nil parameters:@[
                                        @"Text"
                                  ]];
        
        WSTTestContext *context = [[WSTTestContext alloc] init];
        
        WFSLabel *label = (WFSLabel *)[labelSchema createObjectWithContext:context error:&error];
        WSTFailOnError(error);
        WSTAssert([label.text isEqual:@"Text"]);
        
        return KIFTestStepResultSuccess;
        
    }]];
    
    return scenario;
}

+ (id)scenarioUnitTestCreateLabelWithExplicitText
{
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Test label creation with explicit text"];

    [scenario addStep:[KIFTestStep stepWithDescription:scenario.description executionBlock:^KIFTestStepResult(KIFTestStep *step, NSError **outError) {
        
        NSError *error = nil;
        
        WFSSchema *labelSchema = [[WFSSchema alloc] initWithTypeName:@"label" attributes:nil parameters:@[
                                      [[WFSSchemaParameter alloc] initWithName:@"text" value:@"Text"]
                                  ]];
        
        WSTTestContext *context = [[WSTTestContext alloc] init];
        
        WFSLabel *label = (WFSLabel *)[labelSchema createObjectWithContext:context error:&error];
        WSTFailOnError(error);
        WSTAssert([label.text isEqual:@"Text"]);
        
        return KIFTestStepResultSuccess;
        
    }]];
    
    return scenario;
}

+ (id)scenarioUnitTestCreateLabelWithoutText
{
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Test label creation without text"];

    [scenario addStep:[KIFTestStep stepWithDescription:scenario.description executionBlock:^KIFTestStepResult(KIFTestStep *step, NSError **outError) {
        
        NSError *error = nil;
        
        WFSSchema *labelSchema = [[WFSSchema alloc] initWithTypeName:@"label" attributes:nil parameters:nil];
        
        WSTTestContext *context = [[WSTTestContext alloc] init];
        
        WFSLabel *label = (WFSLabel *)[labelSchema createObjectWithContext:context error:&error];
        WSTAssert(label == nil);
        WSTAssert(error != nil);
        
        return KIFTestStepResultSuccess;
        
    }]];
    
    return scenario;
}

@end
