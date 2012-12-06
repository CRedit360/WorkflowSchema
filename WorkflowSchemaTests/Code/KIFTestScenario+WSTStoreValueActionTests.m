//
//  KIFTestScenario+WSTStoreValueActionTests.m
//  WorkflowSchemaTests
//
//  Created by Simon Booth on 26/11/2012.
//  Copyright (c) 2012 CRedit360. All rights reserved.
//

#import "KIFTestScenario+WSTStoreValueActionTests.h"
#import "KIFTestStep+WSTShared.h"
#import "WSTAssert.h"
#import "WSTTestAction.h"
#import "WSTTestContext.h"

@implementation KIFTestScenario (WSTStoreValueActionTests)

+ (id)scenarioUnitTestStoreValueNoValue
{
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Test the store value action with no value set"];
    
    [scenario addStep:[KIFTestStep stepWithDescription:scenario.description executionBlock:^KIFTestStepResult(KIFTestStep *step, NSError **outError) {
        
        NSError *error = nil;
        
        WFSSchema *actionSchema = [[WFSSchema alloc] initWithTypeName:@"storeValue" attributes:nil parameters:@[
                                   
                                       [[WFSSchemaParameter alloc] initWithName:@"name" value:@"test"]
                                   
                                  ]];
        
        WSTTestContext *context = [[WSTTestContext alloc] init];
        
        WFSStoreValueAction *storeValueAction = (WFSStoreValueAction *)[actionSchema createObjectWithContext:context error:&error];
        WSTFailOnError(error);
        WSTAssert([storeValueAction isKindOfClass:[WFSStoreValueAction class]]);
        WSTAssert([storeValueAction.name isEqualToString:@"test"]);
        WSTAssert(!storeValueAction.value);
        WSTAssert(!storeValueAction.transient);
        
        WSTTestContext *controllerContext = [[WSTTestContext alloc] init];
        controllerContext.messageResult = [WFSResult successResultWithContext:controllerContext];
        
        UIViewController *controller = [[UIViewController alloc] init];
        controller.workflowContext = controllerContext;
        
        NSDictionary *inputParameters = @{ @"key1" : @"value1", @"key2" : @"value2" };
        
        WSTTestContext *performanceContext = [[WSTTestContext alloc] init];
        performanceContext.userInfo = inputParameters;
        performanceContext.messageResult = [WFSResult successResultWithContext:performanceContext];
        
        WFSResult *result = [storeValueAction performActionForController:controller context:performanceContext];
        WSTAssert(result.isSuccess);
        
        WSTAssert([result.context.userInfo[@"test"] isEqual:inputParameters]);
        WSTAssert([controller.storedValues[@"test"] isEqual:inputParameters]);
        
        return KIFTestStepResultSuccess;
        
    }]];
    
    return scenario;
}

+ (id)scenarioUnitTestStoreValueWithValue
{
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Test the store value action with a value set"];
    
    [scenario addStep:[KIFTestStep stepWithDescription:scenario.description executionBlock:^KIFTestStepResult(KIFTestStep *step, NSError **outError) {
        
        NSError *error = nil;
        
        WFSSchema *actionSchema = [[WFSSchema alloc] initWithTypeName:@"storeValue" attributes:nil parameters:@[
                                   
                                       [[WFSSchemaParameter alloc] initWithName:@"name" value:@"test"],
                                       [[WFSSchemaParameter alloc] initWithName:@"value" value:@"test value"]
                                   
                                  ]];
        
        WSTTestContext *context = [[WSTTestContext alloc] init];
        
        WFSStoreValueAction *storeValueAction = (WFSStoreValueAction *)[actionSchema createObjectWithContext:context error:&error];
        WSTFailOnError(error);
        WSTAssert([storeValueAction isKindOfClass:[WFSStoreValueAction class]]);
        WSTAssert([storeValueAction.name isEqualToString:@"test"]);
        WSTAssert([storeValueAction.value isEqualToString:@"test value"]);
        WSTAssert(!storeValueAction.transient);
        
        WSTTestContext *controllerContext = [[WSTTestContext alloc] init];
        controllerContext.messageResult = [WFSResult successResultWithContext:controllerContext];
        
        UIViewController *controller = [[UIViewController alloc] init];
        controller.workflowContext = controllerContext;
        
        WSTTestContext *performanceContext = [[WSTTestContext alloc] init];
        performanceContext.messageResult = [WFSResult successResultWithContext:performanceContext];
        
        WFSResult *result = [storeValueAction performActionForController:controller context:performanceContext];
        WSTAssert(result.isSuccess);
        
        WSTAssert([result.context.userInfo[@"test"] isEqual:@"test value"]);
        WSTAssert([controller.storedValues[@"test"] isEqual:@"test value"]);
        
        return KIFTestStepResultSuccess;
        
    }]];
    
    return scenario;
}

+ (id)scenarioUnitTestStoreValueTransient
{
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Test the store value action with the transient flag set"];
    
    [scenario addStep:[KIFTestStep stepWithDescription:scenario.description executionBlock:^KIFTestStepResult(KIFTestStep *step, NSError **outError) {
        
        NSError *error = nil;
        
        WFSSchema *actionSchema = [[WFSSchema alloc] initWithTypeName:@"storeValue" attributes:nil parameters:@[
                                   
                                   [[WFSSchemaParameter alloc] initWithName:@"name" value:@"test"],
                                   [[WFSSchemaParameter alloc] initWithName:@"value" value:@"test value"],
                                   [[WFSSchemaParameter alloc] initWithName:@"transient" value:@"YES"], 
                                   
                                  ]];
        
        WSTTestContext *context = [[WSTTestContext alloc] init];
        
        WFSStoreValueAction *storeValueAction = (WFSStoreValueAction *)[actionSchema createObjectWithContext:context error:&error];
        WSTFailOnError(error);
        WSTAssert([storeValueAction isKindOfClass:[WFSStoreValueAction class]]);
        WSTAssert([storeValueAction.name isEqualToString:@"test"]);
        WSTAssert([storeValueAction.value isEqualToString:@"test value"]);
        WSTAssert(storeValueAction.transient);
        
        WSTTestContext *controllerContext = [[WSTTestContext alloc] init];
        controllerContext.messageResult = [WFSResult successResultWithContext:controllerContext];
        
        UIViewController *controller = [[UIViewController alloc] init];
        controller.workflowContext = controllerContext;
        
        WSTTestContext *performanceContext = [[WSTTestContext alloc] init];
        performanceContext.messageResult = [WFSResult successResultWithContext:performanceContext];
        
        WFSResult *result = [storeValueAction performActionForController:controller context:performanceContext];
        WSTAssert(result.isSuccess);
        
        WSTAssert([result.context.userInfo[@"test"] isEqual:@"test value"]);
        WSTAssert(!controller.storedValues[@"test"]);
        
        return KIFTestStepResultSuccess;
        
    }]];
    
    return scenario;
}

@end
