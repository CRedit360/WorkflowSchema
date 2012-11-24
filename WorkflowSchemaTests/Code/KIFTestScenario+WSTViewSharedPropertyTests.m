//
//  KIFTestScenario+WSTViewSharedPropertyTests.m
//  WorkflowSchemaTests
//
//  Created by Simon Booth on 31/10/2012.
//  Copyright (c) 2012 CRedit360. All rights reserved.
//

#import "KIFTestScenario+WSTViewSharedPropertyTests.h"
#import "KIFTestStep+WSTShared.h"
#import "WSTAssert.h"
#import "WSTTestAction.h"
#import "WSTTestContext.h"

@implementation KIFTestScenario (WSTViewSharedPropertyTests)

+ (id)scenarioUnitTestCreateHiddenLabel
{
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Test hidden label creation"];
    
    [scenario addStep:[KIFTestStep stepWithDescription:scenario.description executionBlock:^KIFTestStepResult(KIFTestStep *step, NSError **outError) {
        
        NSError *error = nil;
        
        WFSSchema *labelSchema = [[WFSSchema alloc] initWithTypeName:@"label" attributes:nil parameters:@[
                                      [[WFSSchemaParameter alloc] initWithName:@"text" value:@"Text"],
                                      [[WFSSchemaParameter alloc] initWithName:@"hidden" value:@"YES"],
                                 ]];
        
        WSTTestContext *context = [[WSTTestContext alloc] init];
        
        WFSLabel *label = (WFSLabel *)[labelSchema createObjectWithContext:context error:&error];
        WSTFailOnError(error);
        WSTAssert(label.hidden);
                  
        return KIFTestStepResultSuccess;
        
    }]];
    
    return scenario;
}

+ (id)scenarioUnitTestCreateLabelWithAccessibilityProperties
{
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Test label creation with accessibility properties"];
    
    [scenario addStep:[KIFTestStep stepWithDescription:scenario.description executionBlock:^KIFTestStepResult(KIFTestStep *step, NSError **outError) {
        
        NSError *error = nil;
        
        WFSSchema *labelSchema = [[WFSSchema alloc] initWithTypeName:@"label" attributes:nil parameters:@[
                                      [[WFSSchemaParameter alloc] initWithName:@"text" value:@"Text"],
                                      [[WFSSchemaParameter alloc] initWithName:@"accessibilityLabel" value:@"Text label"],
                                      [[WFSSchemaParameter alloc] initWithName:@"accessibilityHint" value:@"This is a label"],
                                      [[WFSSchemaParameter alloc] initWithName:@"accessibilityValue" value:@(1234)],
                                      [[WFSSchemaParameter alloc] initWithName:@"accessibilityTraits" value:@"staticText,playsSound,summaryElement"],
                                 ]];
        
        WSTTestContext *context = [[WSTTestContext alloc] init];
        
        WFSLabel *label = (WFSLabel *)[labelSchema createObjectWithContext:context error:&error];
        WSTFailOnError(error);
        WSTAssert([label.accessibilityLabel isEqual:@"Text label"]);
        WSTAssert([label.accessibilityHint isEqual:@"This is a label"]);
        WSTAssert([label.accessibilityValue isEqual:@(1234)]);
        WSTAssert(label.accessibilityTraits == (UIAccessibilityTraitStaticText | UIAccessibilityTraitPlaysSound | UIAccessibilityTraitSummaryElement));
        
        return KIFTestStepResultSuccess;
        
    }]];
    
    return scenario;
}

@end
