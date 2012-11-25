//
//  KIFTestScenario+WSTNumberTests.m
//  WorkflowSchemaTests
//
//  Created by Simon Booth on 25/11/2012.
//  Copyright (c) 2012 CRedit360. All rights reserved.
//

#import "KIFTestScenario+WSTNumberTests.h"
#import "KIFTestStep+WSTShared.h"
#import "WSTAssert.h"
#import "WSTTestAction.h"
#import "WSTTestContext.h"

@implementation KIFTestScenario (WSTNumberTests)

+ (id)schenarioUnitTestNumberWithIntegerValue
{
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Test creating a number with an integer value"];
    
    [scenario addStep:[KIFTestStep stepWithDescription:scenario.description executionBlock:^KIFTestStepResult(KIFTestStep *step, NSError **outError) {
       
        NSError *error = nil;
        
        WFSSchema *numberSchema = [[WFSSchema alloc] initWithTypeName:@"number" attributes:nil parameters:@[ @"12345" ]];
        
        WSTTestContext *context = [[WSTTestContext alloc] init];
        
        NSNumber *number = (NSNumber *)[numberSchema createObjectWithContext:context error:&error];
        WSTFailOnError(error);
        WSTAssert([number integerValue] == 12345);
        
        return KIFTestStepResultSuccess;
        
    }]];
     
    return scenario;
}

+ (id)schenarioUnitTestNumberWithDoubleValue
{
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Test creating a number with a double value"];
    
    [scenario addStep:[KIFTestStep stepWithDescription:scenario.description executionBlock:^KIFTestStepResult(KIFTestStep *step, NSError **outError) {
        
        NSError *error = nil;
        
        WFSSchema *numberSchema = [[WFSSchema alloc] initWithTypeName:@"number" attributes:nil parameters:@[ @"-2.25" ]];
        
        WSTTestContext *context = [[WSTTestContext alloc] init];
        
        NSNumber *number = (NSNumber *)[numberSchema createObjectWithContext:context error:&error];
        WSTFailOnError(error);
        WSTAssert([number doubleValue] == -2.25);
        
        return KIFTestStepResultSuccess;
        
    }]];
    
    return scenario;
}

+ (id)schenarioUnitTestNumberWithLocale
{
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Test creating a number with a localised double value"];
    
    [scenario addStep:[KIFTestStep stepWithDescription:scenario.description executionBlock:^KIFTestStepResult(KIFTestStep *step, NSError **outError) {
        
        NSError *error = nil;
        
        WFSSchema *numberSchema = [[WFSSchema alloc] initWithTypeName:@"number" attributes:@{@"locale":@"fr"} parameters:@[ @"-2,25" ]];
        
        WSTTestContext *context = [[WSTTestContext alloc] init];
        
        NSNumber *number = (NSNumber *)[numberSchema createObjectWithContext:context error:&error];
        WSTFailOnError(error);
        WSTAssert([number doubleValue] == -2.25);
        
        return KIFTestStepResultSuccess;
        
    }]];
    
    return scenario;
}

+ (id)schenarioUnitTestNumberWithBooleanValue
{
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Test creating a number with a boolean value"];
    
    [scenario addStep:[KIFTestStep stepWithDescription:scenario.description executionBlock:^KIFTestStepResult(KIFTestStep *step, NSError **outError) {
        
        NSError *error = nil;
        
        WFSSchema *numberSchema = [[WFSSchema alloc] initWithTypeName:@"bool" attributes:nil parameters:@[ @"YES" ]];
        
        WSTTestContext *context = [[WSTTestContext alloc] init];
        
        NSNumber *number = (NSNumber *)[numberSchema createObjectWithContext:context error:&error];
        WSTFailOnError(error);
        WSTAssert([number boolValue] == YES);
        
        return KIFTestStepResultSuccess;
        
    }]];
    
    return scenario;
}

@end
