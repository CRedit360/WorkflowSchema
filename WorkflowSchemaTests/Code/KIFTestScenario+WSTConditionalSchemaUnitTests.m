//
//  KIFTestScenario+WSTConditionalSchemaUnitTests.m
//  WorkflowSchemaTests
//
//  Created by Simon Booth on 03/12/2012.
//  Copyright (c) 2012 CRedit360. All rights reserved.
//

#import "KIFTestScenario+WSTConditionalSchemaUnitTests.h"
#import "KIFTestStep+WSTShared.h"
#import "WSTAssert.h"
#import "WSTTestAction.h"
#import "WSTTestContext.h"

@implementation KIFTestScenario (WSTConditionalSchemaUnitTests)

+ (id)scenarioUnitTestConditionalSchemaSuccess
{
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Test that successful conditional schemata are replaced by the success value"];
    
    [scenario addStep:[KIFTestStep stepWithDescription:scenario.description executionBlock:^KIFTestStepResult(KIFTestStep *step, NSError **outError) {
        
        NSError *error = nil;
        
        WFSSchema *labelSchema = [[WFSConditionalSchema alloc] initWithTypeName:@"label" attributes:@{ @"conditional" : @"YES" } parameters:@[
                                      [[WFSSchema alloc] initWithTypeName:@"isEqual" attributes:nil parameters:@[
                                          [[WFSSchemaParameter alloc] initWithName:@"value" value:@"A"],
                                          [[WFSSchemaParameter alloc] initWithName:@"otherValue" value:@"A"]
                                      ]],
                                      [[WFSSchemaParameter alloc] initWithName:@"successValue" value:
                                           [[WFSSchema alloc] initWithTypeName:@"label" attributes:nil parameters:@[ @"Success!" ]]
                                      ],
                                      [[WFSSchemaParameter alloc] initWithName:@"failureValue" value:
                                           [[WFSSchema alloc] initWithTypeName:@"label" attributes:nil parameters:@[ @"Failure!" ]]
                                      ]
                                 ]];
        
        WSTTestContext *context = [[WSTTestContext alloc] init];
        
        WFSLabel *label = (WFSLabel *)[labelSchema createObjectWithContext:context error:&error];
        WSTFailOnError(error);
        WSTAssert([label isKindOfClass:[WFSLabel class]]);
        
        WSTAssert([label.text isEqual:@"Success!"]);
        
        return KIFTestStepResultSuccess;
        
    }]];
    
    return scenario;
}

+ (id)scenarioUnitTestConditionalSchemaFailure
{
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Test that failing conditional schemata are replaced by the failure value"];
    
    [scenario addStep:[KIFTestStep stepWithDescription:scenario.description executionBlock:^KIFTestStepResult(KIFTestStep *step, NSError **outError) {
        
        NSError *error = nil;
        
        WFSSchema *labelSchema = [[WFSConditionalSchema alloc] initWithTypeName:@"label" attributes:@{ @"conditional" : @"YES" } parameters:@[
                                      [[WFSSchema alloc] initWithTypeName:@"isEqual" attributes:nil parameters:@[
                                           [[WFSSchemaParameter alloc] initWithName:@"value" value:@"A"],
                                           [[WFSSchemaParameter alloc] initWithName:@"otherValue" value:@"Z"]
                                      ]],
                                      [[WFSSchemaParameter alloc] initWithName:@"successValue" value:
                                           [[WFSSchema alloc] initWithTypeName:@"label" attributes:nil parameters:@[ @"Success!" ]]
                                      ],
                                      [[WFSSchemaParameter alloc] initWithName:@"failureValue" value:
                                           [[WFSSchema alloc] initWithTypeName:@"label" attributes:nil parameters:@[ @"Failure!" ]]
                                      ]
                                 ]];
        
        WSTTestContext *context = [[WSTTestContext alloc] init];
        
        WFSLabel *label = (WFSLabel *)[labelSchema createObjectWithContext:context error:&error];
        WSTFailOnError(error);
        WSTAssert([label isKindOfClass:[WFSLabel class]]);
        
        WSTAssert([label.text isEqual:@"Failure!"]);
        
        return KIFTestStepResultSuccess;
        
    }]];
    
    return scenario;
}

+ (id)scenarioUnitTestConditionalSchemaNoFailure
{
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Test that failing conditional schemata are replaced by nil if there is no failure value"];
    
    [scenario addStep:[KIFTestStep stepWithDescription:scenario.description executionBlock:^KIFTestStepResult(KIFTestStep *step, NSError **outError) {
        
        NSError *error = nil;
        
        WFSSchema *labelSchema = [[WFSConditionalSchema alloc] initWithTypeName:@"label" attributes:@{ @"conditional" : @"YES" } parameters:@[
                                      [[WFSSchema alloc] initWithTypeName:@"isEqual" attributes:nil parameters:@[
                                           [[WFSSchemaParameter alloc] initWithName:@"value" value:@"A"],
                                           [[WFSSchemaParameter alloc] initWithName:@"otherValue" value:@"Z"]
                                      ]],
                                      [[WFSSchemaParameter alloc] initWithName:@"successValue" value:
                                           [[WFSSchema alloc] initWithTypeName:@"label" attributes:nil parameters:@[ @"Success!" ]]
                                      ]
                                 ]];
        
        WSTTestContext *context = [[WSTTestContext alloc] init];
        
        WFSLabel *label = (WFSLabel *)[labelSchema createObjectWithContext:context error:&error];
        WSTFailOnError(error);
        WSTAssert(!label);
        
        return KIFTestStepResultSuccess;
        
    }]];
    
    return scenario;
}

@end
