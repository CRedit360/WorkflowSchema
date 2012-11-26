//
//  KIFTestScenario+WSTSliderTests.m
//  WorkflowSchemaTests
//
//  Created by Simon Booth on 26/11/2012.
//  Copyright (c) 2012 CRedit360. All rights reserved.
//

#import "KIFTestScenario+WSTSliderTests.h"
#import "KIFTestStep+WSTShared.h"
#import "WSTAssert.h"
#import "WSTTestAction.h"
#import "WSTTestContext.h"

@implementation KIFTestScenario (WSTSliderTests)

+ (id)scenarioUnitTestCreateSlider
{
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Test slider creation"];
    
    [scenario addStep:[KIFTestStep stepWithDescription:scenario.description executionBlock:^KIFTestStepResult(KIFTestStep *step, NSError **outError) {
        
        NSError *error = nil;
        
        WFSSchema *sliderSchema = [[WFSSchema alloc] initWithTypeName:@"slider" attributes:nil parameters:@[
                                       [[WFSSchemaParameter alloc] initWithName:@"accessibilityLabel" value:@"test"],
                                       [[WFSSchemaParameter alloc] initWithName:@"continuous" value:@"YES"],
                                       [[WFSSchemaParameter alloc] initWithName:@"minimumValue" value:@"123"],
                                       [[WFSSchemaParameter alloc] initWithName:@"value" value:@"234"],
                                       [[WFSSchemaParameter alloc] initWithName:@"maximumValue" value:@"345"],
                                       [[WFSSchema alloc] initWithTypeName:@"message" attributes:nil parameters:@[ @"didSlide" ]]
                                  ]];
        
        WSTTestContext *context = [[WSTTestContext alloc] init];
        
        WFSSlider *slider = (WFSSlider *)[sliderSchema createObjectWithContext:context error:&error];
        WSTFailOnError(error);
        WSTAssert([slider.accessibilityLabel isEqualToString:@"test"]);
        WSTAssert(slider.continuous);
        WSTAssert(slider.minimumValue = 123);
        WSTAssert(slider.value = 234);
        WSTAssert([slider.formValue isEqual:@(234)]);
        WSTAssert(slider.maximumValue = 345);
        
        [slider sendActionsForControlEvents:UIControlEventValueChanged];
        WSTAssert([[[context.messages lastObject] name] isEqual:@"didSlide"]);
        
        return KIFTestStepResultSuccess;
        
    }]];
    
    return scenario;
}


+ (id)scenarioUnitTestCreateSliderWithoutAccessibilityLabel
{
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Test slider creation without accessibility label"];
    
    [scenario addStep:[KIFTestStep stepWithDescription:scenario.description executionBlock:^KIFTestStepResult(KIFTestStep *step, NSError **outError) {
        
        NSError *error = nil;
        
        WFSSchema *sliderSchema = [[WFSSchema alloc] initWithTypeName:@"slider" attributes:nil parameters:@[
                                       [[WFSSchemaParameter alloc] initWithName:@"continuous" value:@"YES"],
                                       [[WFSSchemaParameter alloc] initWithName:@"minimumValue" value:@"123"],
                                       [[WFSSchemaParameter alloc] initWithName:@"value" value:@"234"],
                                       [[WFSSchemaParameter alloc] initWithName:@"maximumValue" value:@"345"],
                                       [[WFSSchema alloc] initWithTypeName:@"message" attributes:nil parameters:@[ @"didSlide" ]]
                                  ]];
        
        WSTTestContext *context = [[WSTTestContext alloc] init];
        
        WFSSlider *slider = (WFSSlider *)[sliderSchema createObjectWithContext:context error:&error];
        WSTAssert(error);
        WSTAssert(!slider);
        
        return KIFTestStepResultSuccess;
        
    }]];
    
    return scenario;
}

@end
