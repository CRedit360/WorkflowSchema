//
//  KIFTestScenario+WSTComparisonConditionTests.m
//  WorkflowSchemaTests
//
//  Created by Simon Booth on 26/11/2012.
//  Copyright (c) 2012 CRedit360. All rights reserved.
//

#import "KIFTestScenario+WSTComparisonConditionTests.h"
#import "KIFTestStep+WSTShared.h"
#import "WSTAssert.h"
#import "WSTTestAction.h"
#import "WSTTestContext.h"
#import <WorkflowSchema/WorkflowSchema.h>


@implementation KIFTestScenario (WSTComparisonConditionTests)

+ (id)scenarioUnitTestComparisonConditionStrictlyLessThan
{
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Test comparison condition - strictly less than"];
    
    [scenario addStep:[KIFTestStep stepWithDescription:scenario.description executionBlock:^KIFTestStepResult(KIFTestStep *step, NSError **outError) {
        
        NSError *error = nil;
        
        WFSSchema *comparisonSchema = [[WFSSchema alloc] initWithTypeName:@"isLessThan" attributes:nil parameters:@[@"12.5"]];
        
        WSTTestContext *context = [[WSTTestContext alloc] init];
        
        WFSComparisonCondition *comparisonCondition = (WFSComparisonCondition *)[comparisonSchema createObjectWithContext:context error:&error];
        WSTFailOnError(error);
        WSTAssert(comparisonCondition.comparisonType == WFSStrictlyLessThan);
        
        WSTAssert([comparisonCondition evaluateWithValue:@(10) context:context]);
        WSTAssert(![comparisonCondition evaluateWithValue:@(12.5) context:context]);
        WSTAssert(![comparisonCondition evaluateWithValue:@(15) context:context]);
        
        return KIFTestStepResultSuccess;
        
    }]];
    
    return scenario;
}

+ (id)scenarioUnitTestComparisonConditionLessThanOrEqual
{
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Test comparison condition - less than or equal"];
    
    [scenario addStep:[KIFTestStep stepWithDescription:scenario.description executionBlock:^KIFTestStepResult(KIFTestStep *step, NSError **outError) {
        
        NSError *error = nil;
        
        WFSSchema *comparisonSchema = [[WFSSchema alloc] initWithTypeName:@"isLessThanOrEqualTo" attributes:nil parameters:@[@"12.5"]];
        
        WSTTestContext *context = [[WSTTestContext alloc] init];
        
        WFSComparisonCondition *comparisonCondition = (WFSComparisonCondition *)[comparisonSchema createObjectWithContext:context error:&error];
        WSTFailOnError(error);
        WSTAssert(comparisonCondition.comparisonType == WFSLessThanOrEqual);
        
        WSTAssert([comparisonCondition evaluateWithValue:@(10) context:context]);
        WSTAssert([comparisonCondition evaluateWithValue:@(12.5) context:context]);
        WSTAssert(![comparisonCondition evaluateWithValue:@(15) context:context]);
        
        return KIFTestStepResultSuccess;
        
    }]];
    
    return scenario;
}

+ (id)scenarioUnitTestComparisonConditionGreaterThanOrEqual
{
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Test comparison condition - greater than or equal"];
    
    [scenario addStep:[KIFTestStep stepWithDescription:scenario.description executionBlock:^KIFTestStepResult(KIFTestStep *step, NSError **outError) {
        
        NSError *error = nil;
        
        WFSSchema *comparisonSchema = [[WFSSchema alloc] initWithTypeName:@"isGreaterThanOrEqualTo" attributes:nil parameters:@[@"12.5"]];
        
        WSTTestContext *context = [[WSTTestContext alloc] init];
        
        WFSComparisonCondition *comparisonCondition = (WFSComparisonCondition *)[comparisonSchema createObjectWithContext:context error:&error];
        WSTFailOnError(error);
        WSTAssert(comparisonCondition.comparisonType == WFSGreaterThanOrEqual);
        
        WSTAssert(![comparisonCondition evaluateWithValue:@(10) context:context]);
        WSTAssert([comparisonCondition evaluateWithValue:@(12.5) context:context]);
        WSTAssert([comparisonCondition evaluateWithValue:@(15) context:context]);
        
        return KIFTestStepResultSuccess;
        
    }]];
    
    return scenario;
}

+ (id)scenarioUnitTestComparisonConditionStrictlyGreaterThan
{
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Test comparison condition - strictly greater than"];
    
    [scenario addStep:[KIFTestStep stepWithDescription:scenario.description executionBlock:^KIFTestStepResult(KIFTestStep *step, NSError **outError) {
        
        NSError *error = nil;
        
        WFSSchema *comparisonSchema = [[WFSSchema alloc] initWithTypeName:@"isGreaterThan" attributes:nil parameters:@[@"12.5"]];
        
        WSTTestContext *context = [[WSTTestContext alloc] init];
        
        WFSComparisonCondition *comparisonCondition = (WFSComparisonCondition *)[comparisonSchema createObjectWithContext:context error:&error];
        WSTFailOnError(error);
        WSTAssert(comparisonCondition.comparisonType == WFSStrictlyGreaterThan);
        
        WSTAssert(![comparisonCondition evaluateWithValue:@(10) context:context]);
        WSTAssert(![comparisonCondition evaluateWithValue:@(12.5) context:context]);
        WSTAssert([comparisonCondition evaluateWithValue:@(15) context:context]);
        
        return KIFTestStepResultSuccess;
        
    }]];
    
    return scenario;
}

@end
