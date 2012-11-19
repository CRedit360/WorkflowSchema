//
//  KIFTestScenario+WSTConditionalActionTests.m
//  WorkflowSchemaTests
//
//  Created by Simon Booth on 19/11/2012.
//  Copyright (c) 2012 CRedit360. All rights reserved.
//

#import "KIFTestScenario+WSTConditionalActionTests.h"
#import "KIFTestStep+WSTShared.h"
#import "WSTAssert.h"
#import "WSTTestAction.h"
#import "WSTTestContext.h"

@implementation KIFTestScenario (WSTConditionalActionTests)

+ (id)scenarioUnitTestConditionalActionSuccess
{
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Test conditional action success"];
    
    [scenario addStep:[KIFTestStep stepWithDescription:scenario.description executionBlock:^KIFTestStepResult(KIFTestStep *step, NSError **outError) {
        
        NSError *error = nil;
        
        WFSSchema *actionSchema = [[WFSSchema alloc] initWithTypeName:@"conditionalAction" attributes:nil parameters:@[
                                       [[WFSSchemaParameter alloc] initWithName:@"condition" value:
                                            [[WFSSchema alloc] initWithTypeName:@"isEqual" attributes:nil parameters:@[
                                                 [[WFSSchemaParameter alloc] initWithName:@"value" value:@"A"],
                                                 [[WFSSchemaParameter alloc] initWithName:@"otherValue" value:@"A"],
                                            ]]
                                       ],
                                       [[WFSSchemaParameter alloc] initWithName:@"successAction" value:
                                            [[WFSSchema alloc] initWithTypeName:@"testAction" attributes:nil parameters:nil]
                                       ],
                                       [[WFSSchemaParameter alloc] initWithName:@"failureAction" value:
                                           [[WFSSchema alloc] initWithTypeName:@"testAction" attributes:nil parameters:nil]
                                       ]
                                   ]];
        
        WSTTestContext *context = [[WSTTestContext alloc] init];
        
        WFSConditionalAction *conditionalAction = (WFSConditionalAction *)[actionSchema createObjectWithContext:context error:&error];
        WSTFailOnError(error);
        WSTAssert([conditionalAction isKindOfClass:[WFSConditionalAction class]]);
        WSTAssert([conditionalAction.condition isKindOfClass:[WFSEqualityCondition class]]);
        WSTAssert([conditionalAction.successAction isKindOfClass:[WFSAction class]]);
        WSTAssert([conditionalAction.failureAction isKindOfClass:[WFSAction class]]);
        
        [WSTTestAction clearRecentTestActions];
        WFSResult *result = [conditionalAction performActionForController:nil context:context];
        WSTAssert(result.isSuccess);
        WSTAssert([[WSTTestAction recentTestActions] isEqual:@[conditionalAction.successAction]]);
        
        return KIFTestStepResultSuccess;
        
    }]];
    
    return scenario;
}

+ (id)scenarioUnitTestConditionalActionFailure
{
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Test conditional action failure"];
    
    [scenario addStep:[KIFTestStep stepWithDescription:scenario.description executionBlock:^KIFTestStepResult(KIFTestStep *step, NSError **outError) {
        
        NSError *error = nil;
        
        WFSSchema *actionSchema = [[WFSSchema alloc] initWithTypeName:@"conditionalAction" attributes:nil parameters:@[
                                       [[WFSSchemaParameter alloc] initWithName:@"condition" value:
                                            [[WFSSchema alloc] initWithTypeName:@"isEqual" attributes:nil parameters:@[
                                                 [[WFSSchemaParameter alloc] initWithName:@"value" value:@"A"],
                                                 [[WFSSchemaParameter alloc] initWithName:@"otherValue" value:@"Z"],
                                            ]]
                                       ],
                                       [[WFSSchemaParameter alloc] initWithName:@"successAction" value:
                                            [[WFSSchema alloc] initWithTypeName:@"testAction" attributes:nil parameters:nil]
                                       ],
                                       [[WFSSchemaParameter alloc] initWithName:@"failureAction" value:
                                            [[WFSSchema alloc] initWithTypeName:@"testAction" attributes:nil parameters:nil]
                                       ]
                                  ]];
        
        WSTTestContext *context = [[WSTTestContext alloc] init];
        
        WFSConditionalAction *conditionalAction = (WFSConditionalAction *)[actionSchema createObjectWithContext:context error:&error];
        WSTFailOnError(error);
        WSTAssert([conditionalAction isKindOfClass:[WFSConditionalAction class]]);
        WSTAssert([conditionalAction.condition isKindOfClass:[WFSEqualityCondition class]]);
        WSTAssert([conditionalAction.successAction isKindOfClass:[WFSAction class]]);
        WSTAssert([conditionalAction.failureAction isKindOfClass:[WFSAction class]]);
        
        [WSTTestAction clearRecentTestActions];
        WFSResult *result = [conditionalAction performActionForController:nil context:context];
        WSTAssert(result.isSuccess);
        WSTAssert([[WSTTestAction recentTestActions] isEqual:@[conditionalAction.failureAction]]);
        
        return KIFTestStepResultSuccess;
        
    }]];
    
    return scenario;
}

@end
