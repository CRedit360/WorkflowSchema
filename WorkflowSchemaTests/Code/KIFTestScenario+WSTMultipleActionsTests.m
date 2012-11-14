//
//  KIFTestScenario+WSTMultipleActionsTests.m
//  WorkflowSchemaTests
//
//  Created by Simon Booth on 29/10/2012.
//  Copyright (c) 2012 CRedit360. All rights reserved.
//

#import "KIFTestScenario+WSTMultipleActionsTests.h"
#import "KIFTestStep+WSTShared.h"
#import "WSTAssert.h"
#import "WSTTestAction.h"
#import "WSTTestContext.h"

@implementation KIFTestScenario (WSTMultipleActionsTests)

+ (id)scenarioUnitTestMultipleActionsAllSucceeding
{
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Test multiple actions, all succeeding"];
    
    [scenario addStep:[KIFTestStep stepWithDescription:scenario.description executionBlock:^KIFTestStepResult(KIFTestStep *step, NSError **outError) {
        
        NSError *error = nil;
        
        WFSSchema *actionSchema = [[WFSSchema alloc] initWithTypeName:@"multipleActions" attributes:nil parameters:@[
                                       [[WFSSchema alloc] initWithTypeName:@"testAction" attributes:nil parameters:nil],
                                       [[WFSSchema alloc] initWithTypeName:@"testAction" attributes:nil parameters:nil],
                                       [[WFSSchema alloc] initWithTypeName:@"testAction" attributes:nil parameters:nil],
                                       [[WFSSchema alloc] initWithTypeName:@"testAction" attributes:nil parameters:nil],
                                       [[WFSSchema alloc] initWithTypeName:@"testAction" attributes:nil parameters:nil]
                                  ]];
        
        WSTTestContext *context = [[WSTTestContext alloc] init];
        
        WFSMultipleAction *multipleActions = (WFSMultipleAction *)[actionSchema createObjectWithContext:context error:&error];
        WSTFailOnError(error);
        WSTAssert([multipleActions isKindOfClass:[WFSMultipleAction class]]);
        WSTAssert(multipleActions.actions.count == 5);
        
        [WSTTestAction clearRecentTestActions];
        WFSResult *result = [multipleActions performActionForController:nil context:context];
        WSTAssert(result.isSuccess);
        WSTAssert([[WSTTestAction recentTestActions] isEqual:multipleActions.actions]);
        
        return KIFTestStepResultSuccess;
        
    }]];
    
    return scenario;
}

+ (id)scenarioUnitTestMultipleActionsWithFailure
{
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Test multiple actions with failure"];
    
    [scenario addStep:[KIFTestStep stepWithDescription:scenario.description executionBlock:^KIFTestStepResult(KIFTestStep *step, NSError **outError) {
        
        NSError *error = nil;
        
        WFSSchema *actionSchema = [[WFSSchema alloc] initWithTypeName:@"multipleActions" attributes:nil parameters:@[
                                       [[WFSSchema alloc] initWithTypeName:@"testAction" attributes:nil parameters:nil],
                                       [[WFSSchema alloc] initWithTypeName:@"testAction" attributes:nil parameters:@[ @"YES" ]],
                                       [[WFSSchema alloc] initWithTypeName:@"testAction" attributes:nil parameters:nil],
                                       [[WFSSchema alloc] initWithTypeName:@"testAction" attributes:nil parameters:@[ @"YES" ]],
                                       [[WFSSchema alloc] initWithTypeName:@"testAction" attributes:nil parameters:nil]
                                  ]];
        
        WSTTestContext *context = [[WSTTestContext alloc] init];
        
        WFSMultipleAction *multipleActions = (WFSMultipleAction *)[actionSchema createObjectWithContext:context error:&error];
        WSTFailOnError(error);
        WSTAssert([multipleActions isKindOfClass:[WFSMultipleAction class]]);
        WSTAssert(multipleActions.actions.count == 5);
        
        [WSTTestAction clearRecentTestActions];
        WFSResult *result = [multipleActions performActionForController:nil context:context];
        WSTAssert(!result.isSuccess);
        WSTAssert([[WSTTestAction recentTestActions] isEqual:[multipleActions.actions subarrayWithRange:NSMakeRange(0, 2)]]);
        
        return KIFTestStepResultSuccess;
        
    }]];
    
    return scenario;
}

@end
