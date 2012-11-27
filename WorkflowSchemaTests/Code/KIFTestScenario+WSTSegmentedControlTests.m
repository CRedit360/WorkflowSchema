//
//  KIFTestScenario+WSTSegmentedControlTests.m
//  WorkflowSchemaTests
//
//  Created by Simon Booth on 27/11/2012.
//  Copyright (c) 2012 CRedit360. All rights reserved.
//

#import "KIFTestScenario+WSTSegmentedControlTests.h"
#import "KIFTestStep+WSTShared.h"
#import "WSTAssert.h"
#import "WSTTestAction.h"
#import "WSTTestContext.h"
#import <WorkflowSchema/WorkflowSchema.h>

@implementation KIFTestScenario (WSTSegmentedControlTests)

+ (id)scenarioUnitTestSegmentedControlWithImplicitSegments
{
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Test segmented control with implicit segments"];
    
    [scenario addStep:[KIFTestStep stepWithDescription:scenario.description executionBlock:^KIFTestStepResult(KIFTestStep *step, NSError **outError) {
        
        NSError *error = nil;
        
        WFSSchema *segmentedControlSchema = [[WFSSchema alloc] initWithTypeName:@"segmentedControl" attributes:@{@"name":@"foo"} parameters:@[
                                                 [[WFSSchemaParameter alloc] initWithName:@"momentary" value:@"YES"],
                                                 [[WFSSchemaParameter alloc] initWithName:@"segmentedControlStyle" value:@"bar"],
                                                 [[WFSSchema alloc] initWithTypeName:@"segment" attributes:nil parameters:@[
                                                      [[WFSSchema alloc] initWithTypeName:@"string" attributes:nil parameters:@[ @"test" ]],
                                                      [[WFSSchema alloc] initWithTypeName:@"message" attributes:nil parameters:@[ @"didTapFirstSegment" ]],
                                                 ]],
                                                 [[WFSSchema alloc] initWithTypeName:@"segment" attributes:nil parameters:@[
                                                      [[WFSSchema alloc] initWithTypeName:@"image" attributes:nil parameters:@[ @"first" ]],
                                                      [[WFSSchema alloc] initWithTypeName:@"message" attributes:nil parameters:@[ @"didTapSecondSegment" ]],
                                                 ]]
                                            ]];
        
        WSTTestContext *context = [[WSTTestContext alloc] init];
        
        WFSSegmentedControl *segmentedControl = (WFSSegmentedControl *)[segmentedControlSchema createObjectWithContext:context error:&error];
        WSTFailOnError(error);
        WSTAssert([segmentedControl isKindOfClass:[WFSSegmentedControl class]]);
        
        WSTAssert([segmentedControl.workflowName isEqual:@"foo"]);
        WSTAssert(segmentedControl.momentary == YES);
        WSTAssert(segmentedControl.segmentedControlStyle == UISegmentedControlStyleBar);
        WSTAssert(segmentedControl.numberOfSegments == 2);
        
        segmentedControl.selectedSegmentIndex = 0;
        [segmentedControl sendActionsForControlEvents:UIControlEventValueChanged];
        WSTAssert([[[context.messages lastObject] name] isEqualToString:@"didTapFirstSegment"]);
        
        segmentedControl.selectedSegmentIndex = 1;
        [segmentedControl sendActionsForControlEvents:UIControlEventValueChanged];
        WSTAssert([[[context.messages lastObject] name] isEqualToString:@"didTapSecondSegment"]);
        
        return KIFTestStepResultSuccess;
        
    }]];
    
    return scenario;
}

+ (id)scenarioUnitTestSegmentedControlWithExplicitSegments
{
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Test segmented control with explicit segments"];
    
    [scenario addStep:[KIFTestStep stepWithDescription:scenario.description executionBlock:^KIFTestStepResult(KIFTestStep *step, NSError **outError) {
        
        NSError *error = nil;
        
        WFSSchema *segmentedControlSchema = [[WFSSchema alloc] initWithTypeName:@"segmentedControl" attributes:@{@"name":@"foo"} parameters:@[
                                                 [[WFSSchemaParameter alloc] initWithName:@"momentary" value:@"YES"],
                                                 [[WFSSchemaParameter alloc] initWithName:@"segmentedControlStyle" value:@"bar"],
                                                 [[WFSSchemaParameter alloc] initWithName:@"segments" value:@[
                                                      [[WFSSchema alloc] initWithTypeName:@"segment" attributes:nil parameters:@[
                                                           [[WFSSchemaParameter alloc] initWithName:@"title" value:@"first"],
                                                           [[WFSSchemaParameter alloc] initWithName:@"message" value:
                                                                [[WFSSchema alloc] initWithTypeName:@"message" attributes:nil parameters:@[ @"didTapFirstSegment" ]]
                                                           ]
                                                      ]],
                                                      [[WFSSchema alloc] initWithTypeName:@"segment" attributes:nil parameters:@[
                                                           [[WFSSchemaParameter alloc] initWithName:@"image" value:
                                                                [[WFSSchema alloc] initWithTypeName:@"image" attributes:nil parameters:@[ @"first" ]]
                                                           ],
                                                           [[WFSSchemaParameter alloc] initWithName:@"message" value:
                                                                [[WFSSchema alloc] initWithTypeName:@"message" attributes:nil parameters:@[ @"didTapSecondSegment" ]]
                                                           ],
                                                      ]]
                                                 ]]
                                            ]];
        
        WSTTestContext *context = [[WSTTestContext alloc] init];
        
        WFSSegmentedControl *segmentedControl = (WFSSegmentedControl *)[segmentedControlSchema createObjectWithContext:context error:&error];
        WSTFailOnError(error);
        WSTAssert([segmentedControl isKindOfClass:[WFSSegmentedControl class]]);
        
        WSTAssert([segmentedControl.workflowName isEqual:@"foo"]);
        WSTAssert(segmentedControl.momentary == YES);
        WSTAssert(segmentedControl.segmentedControlStyle == UISegmentedControlStyleBar);
        WSTAssert(segmentedControl.numberOfSegments == 2);
        
        segmentedControl.selectedSegmentIndex = 0;
        [segmentedControl sendActionsForControlEvents:UIControlEventValueChanged];
        WSTAssert([[[context.messages lastObject] name] isEqualToString:@"didTapFirstSegment"]);
        
        segmentedControl.selectedSegmentIndex = 1;
        [segmentedControl sendActionsForControlEvents:UIControlEventValueChanged];
        WSTAssert([[[context.messages lastObject] name] isEqualToString:@"didTapSecondSegment"]);
        
        return KIFTestStepResultSuccess;
        
    }]];
    
    return scenario;
}

@end
