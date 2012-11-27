//
//  KIFTestScenario+WSTDateTests.m
//  WorkflowSchemaTests
//
//  Created by Simon Booth on 27/11/2012.
//  Copyright (c) 2012 CRedit360. All rights reserved.
//

#import "KIFTestScenario+WSTDateTests.h"
#import "KIFTestStep+WSTShared.h"
#import "WSTAssert.h"
#import "WSTTestAction.h"
#import "WSTTestContext.h"
#import <WorkflowSchema/WorkflowSchema.h>

@implementation KIFTestScenario (WSTDateTests)

+ (id)scenarioUnitTestDateWithFormat
{
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Test date creation with format"];
    
    [scenario addStep:[KIFTestStep stepWithDescription:scenario.description executionBlock:^KIFTestStepResult(KIFTestStep *step, NSError **outError) {
        
        NSError *error = nil;
        
        WFSSchema *dateSchema = [[WFSSchema alloc] initWithTypeName:@"date" attributes:nil parameters:@[
                                     [[WFSSchemaParameter alloc] initWithName:@"format" value:@"yyyy-MM-dd'T'HH:mm:ss.SSSSS'Z'"],
                                     [[WFSSchemaParameter alloc] initWithName:@"value" value:@"2012-11-27T14:55:12.34567Z"]
                                ]];
        
        WSTTestContext *context = [[WSTTestContext alloc] init];
        
        NSDate *date = (NSDate *)[dateSchema createObjectWithContext:context error:&error];
        WSTFailOnError(error);
        WSTAssert([date isKindOfClass:[NSDate class]]);
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss.SSSSS ZZZ";
        WSTAssert([[formatter stringFromDate:date] isEqualToString:@"2012-11-27 14:55:12.34600 +0000"]);
        
        return KIFTestStepResultSuccess;
        
    }]];
    
    return scenario;
}

+ (id)scenarioUnitTestDateWithFormatBadValue
{
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Test date creation with format and bad value"];
    
    [scenario addStep:[KIFTestStep stepWithDescription:scenario.description executionBlock:^KIFTestStepResult(KIFTestStep *step, NSError **outError) {
        
        NSError *error = nil;
        
        WFSSchema *dateSchema = [[WFSSchema alloc] initWithTypeName:@"date" attributes:nil parameters:@[
                                     [[WFSSchemaParameter alloc] initWithName:@"format" value:@"yyyy-MM-dd'T'HH:mm:ss.SSSSS'Z'"],
                                     [[WFSSchemaParameter alloc] initWithName:@"value" value:@"I am a fish"]
                                ]];
        
        WSTTestContext *context = [[WSTTestContext alloc] init];
        
        NSDate *date = (NSDate *)[dateSchema createObjectWithContext:context error:&error];
        WSTAssert(error);
        WSTAssert(!date);
        
        return KIFTestStepResultSuccess;
        
    }]];
    
    return scenario;
}

+ (id)scenarioUnitTestDateWithoutFormat
{
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Test date creation without format"];
    
    [scenario addStep:[KIFTestStep stepWithDescription:scenario.description executionBlock:^KIFTestStepResult(KIFTestStep *step, NSError **outError) {
        
        NSError *error = nil;
        
        WFSSchema *dateSchema = [[WFSSchema alloc] initWithTypeName:@"date" attributes:nil parameters:@[
                                     [[WFSSchemaParameter alloc] initWithName:@"value" value:@"2012/11/27 14:55:12 UTC"]
                                ]];
        
        WSTTestContext *context = [[WSTTestContext alloc] init];
        
        NSDate *date = (NSDate *)[dateSchema createObjectWithContext:context error:&error];
        WSTFailOnError(error);
        WSTAssert([date isKindOfClass:[NSDate class]]);
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss ZZZ";
        WSTAssert([[formatter stringFromDate:date] isEqualToString:@"2012-11-27 14:55:12 +0000"]);
        
        return KIFTestStepResultSuccess;
        
    }]];
    
    return scenario;
}

+ (id)scenarioUnitTestDateWithoutFormatBadValue
{
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Test date creation without format and bad value"];
    
    [scenario addStep:[KIFTestStep stepWithDescription:scenario.description executionBlock:^KIFTestStepResult(KIFTestStep *step, NSError **outError) {
        
        NSError *error = nil;
        
        WFSSchema *dateSchema = [[WFSSchema alloc] initWithTypeName:@"date" attributes:nil parameters:@[
                                    [[WFSSchemaParameter alloc] initWithName:@"value" value:@"I am a fish"]
                                ]];
        
        WSTTestContext *context = [[WSTTestContext alloc] init];
        
        NSDate *date = (NSDate *)[dateSchema createObjectWithContext:context error:&error];
        WSTAssert(error);
        WSTAssert(!date);
        
        return KIFTestStepResultSuccess;
        
    }]];
    
    return scenario;
}

@end
