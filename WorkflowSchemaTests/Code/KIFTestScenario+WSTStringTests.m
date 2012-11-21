//
//  KIFTestScenario+WSTStringTests.m
//  WorkflowSchemaTests
//
//  Created by Simon Booth on 21/11/2012.
//  Copyright (c) 2012 CRedit360. All rights reserved.
//

#import "KIFTestScenario+WSTStringTests.h"
#import "KIFTestStep+WSTShared.h"
#import "WSTAssert.h"
#import "WSTTestAction.h"
#import "WSTTestContext.h"

@implementation KIFTestScenario (WSTStringTests)

+ (id)scenarioUnitTestStringWithImplicitValue
{
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Test string creation with implicit value"];
    
    [scenario addStep:[KIFTestStep stepWithDescription:scenario.description executionBlock:^KIFTestStepResult(KIFTestStep *step, NSError **outError) {
        
        NSError *error = nil;
        
        WFSSchema *stringSchema = [[WFSSchema alloc] initWithTypeName:@"string" attributes:nil parameters:@[ @"Test" ]];
        
        WSTTestContext *context = [[WSTTestContext alloc] init];
        
        NSString *string = (NSString *)[stringSchema createObjectWithContext:context error:&error];
        WSTFailOnError(error);
        WSTAssert([string isEqual:@"Test"]);
        
        return KIFTestStepResultSuccess;
        
    }]];
    
    return scenario;
}

+ (id)scenarioUnitTestStringWithExplicitValue
{
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Test string creation with explicit value"];
    
    [scenario addStep:[KIFTestStep stepWithDescription:scenario.description executionBlock:^KIFTestStepResult(KIFTestStep *step, NSError **outError) {
        
        NSError *error = nil;
        
        WFSSchema *stringSchema = [[WFSSchema alloc] initWithTypeName:@"string" attributes:nil parameters:@[
                                    [[WFSSchemaParameter alloc] initWithName:@"value" value:@"Test"]
                                  ]];
        
        WSTTestContext *context = [[WSTTestContext alloc] init];
        
        NSString *string = (NSString *)[stringSchema createObjectWithContext:context error:&error];
        WSTFailOnError(error);
        WSTAssert([string isEqual:@"Test"]);
        
        return KIFTestStepResultSuccess;
        
    }]];
    
    return scenario;
}

+ (id)scenarioUnitTestStringWithTranslations
{
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Test string creation with translations"];
    
    [scenario addStep:[KIFTestStep stepWithDescription:scenario.description executionBlock:^KIFTestStepResult(KIFTestStep *step, NSError **outError) {
        
        NSError *error = nil;
        
        WFSSchema *stringSchemaL1 = [[WFSSchema alloc] initWithTypeName:@"string" attributes:nil parameters:@[
                                         [[WFSSchemaParameter alloc] initWithName:@"key" value:@"key_1"]
                                    ]];
        
        WFSSchema *stringSchemaL2 = [[WFSSchema alloc] initWithTypeName:@"string" attributes:nil parameters:@[
                                         [[WFSSchemaParameter alloc] initWithName:@"key" value:@"key_2"],
                                         [[WFSSchemaParameter alloc] initWithName:@"value" value:@"default"]
                                    ]];
        
        WFSSchema *stringSchemaL3 = [[WFSSchema alloc] initWithTypeName:@"string" attributes:nil parameters:@[
                                         [[WFSSchemaParameter alloc] initWithName:@"key" value:@"key_3"],
                                         [[WFSSchemaParameter alloc] initWithName:@"value" value:@"default"]
                                    ]];
        
        WFSSchema *stringSchemaL4 = [[WFSSchema alloc] initWithTypeName:@"string" attributes:nil parameters:@[
                                         [[WFSSchemaParameter alloc] initWithName:@"key" value:@"key_4"]
                                    ]];
        
        WFSSchema *stringSchemaT1 = [[WFSSchema alloc] initWithTypeName:@"string" attributes:nil parameters:@[
                                         [[WFSSchemaParameter alloc] initWithName:@"key" value:@"key_1"],
                                         [[WFSSchemaParameter alloc] initWithName:@"table" value:@"Test"]
                                    ]];
        
        WFSSchema *stringSchemaT2 = [[WFSSchema alloc] initWithTypeName:@"string" attributes:nil parameters:@[
                                         [[WFSSchemaParameter alloc] initWithName:@"key" value:@"key_2"],
                                         [[WFSSchemaParameter alloc] initWithName:@"value" value:@"default"],
                                         [[WFSSchemaParameter alloc] initWithName:@"table" value:@"Test"]
                                    ]];
        
        WFSSchema *stringSchemaT3 = [[WFSSchema alloc] initWithTypeName:@"string" attributes:nil parameters:@[
                                         [[WFSSchemaParameter alloc] initWithName:@"key" value:@"key_3"],
                                         [[WFSSchemaParameter alloc] initWithName:@"table" value:@"Test"]
                                    ]];
        
        WSTTestContext *context = [[WSTTestContext alloc] init];
        
        NSString *stringL1 = (NSString *)[stringSchemaL1 createObjectWithContext:context error:&error];
        WSTFailOnError(error);
        WSTAssert([stringL1 isEqual:@"value_1"]);
        
        NSString *stringL2 = (NSString *)[stringSchemaL2 createObjectWithContext:context error:&error];
        WSTFailOnError(error);
        WSTAssert([stringL2 isEqual:@"value_2"]);
        
        NSString *stringL3 = (NSString *)[stringSchemaL3 createObjectWithContext:context error:&error];
        WSTFailOnError(error);
        WSTAssert([stringL3 isEqual:@"default"]);
        
        NSString *stringL4 = (NSString *)[stringSchemaL4 createObjectWithContext:context error:&error];
        WSTFailOnError(error);
        WSTAssert([stringL4 isEqual:@"key_4"]);
        
        NSString *stringT1 = (NSString *)[stringSchemaT1 createObjectWithContext:context error:&error];
        WSTFailOnError(error);
        WSTAssert([stringT1 isEqual:@"test"]);
        
        NSString *stringT2 = (NSString *)[stringSchemaT2 createObjectWithContext:context error:&error];
        WSTFailOnError(error);
        WSTAssert([stringT2 isEqual:@"default"]);
        
        NSString *stringT3 = (NSString *)[stringSchemaT3 createObjectWithContext:context error:&error];
        WSTFailOnError(error);
        WSTAssert([stringT3 isEqual:@"key_3"]);
        
        return KIFTestStepResultSuccess;
        
    }]];
    
    return scenario;
}

@end
