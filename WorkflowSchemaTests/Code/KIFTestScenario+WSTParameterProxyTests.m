//
//  KIFTestScenario+WSTParameterProxyTests.m
//  WorkflowSchemaTests
//
//  Created by Simon Booth on 05/11/2012.
//  Copyright (c) 2012 CRedit360. All rights reserved.
//

#import "KIFTestScenario+WSTParameterProxyTests.h"
#import "KIFTestStep+WSTShared.h"
#import "WSTAssert.h"
#import "WSTTestAction.h"
#import "WSTTestContext.h"

@implementation KIFTestScenario (WSTParameterProxyTests)

+ (id)scenarioUnitTestParameterProxyReplacement
{
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Test parameter proxies are replaced by the appropriate keypath in the context"];
    
    [scenario addStep:[KIFTestStep stepWithDescription:scenario.description executionBlock:^KIFTestStepResult(KIFTestStep *step, NSError **outError) {
        
        NSError *error = nil;
        
        WFSSchema *labelSchema = [[WFSSchema alloc] initWithTypeName:@"label" attributes:nil parameters:@[
                                    [[WFSSchemaParameter alloc] initWithName:@"text" value:
                                         [[WFSParameterProxy alloc] initWithTypeName:@"string" attributes:@{ @"keyPath" : @"testKey" } parameters:nil]
                                    ]
                                 ]];
        
        WSTTestContext *context = [[WSTTestContext alloc] init];
        context.parameters = @{ @"testKey" : @"Test text" };
        
        WFSLabel *label = (WFSLabel *)[labelSchema createObjectWithContext:context error:&error];
        WSTFailOnError(error);
        WSTAssert([label.text isEqual:@"Test text"]);
        
        return KIFTestStepResultSuccess;
        
    }]];
    
    return scenario;
}

+ (id)scenarioUnitTestParameterProxyUnusedDefault
{
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Test parameter proxies defaults are ignored if the keypath is found in the context"];
    
    [scenario addStep:[KIFTestStep stepWithDescription:scenario.description executionBlock:^KIFTestStepResult(KIFTestStep *step, NSError **outError) {
        
        NSError *error = nil;
        
        WFSSchema *labelSchema = [[WFSSchema alloc] initWithTypeName:@"label" attributes:nil parameters:@[
                                      [[WFSSchemaParameter alloc] initWithName:@"text" value:
                                           [[WFSParameterProxy alloc] initWithTypeName:@"string" attributes:@{ @"keyPath" : @"testKey" } parameters:@[
                                                [[WFSSchemaParameter alloc] initWithName:@"default" value:@"Default text"]
                                           ]]
                                      ]
                                 ]];
        
        WSTTestContext *context = [[WSTTestContext alloc] init];
        context.parameters = @{ @"testKey" : @"Test text" };
        
        WFSLabel *label = (WFSLabel *)[labelSchema createObjectWithContext:context error:&error];
        WSTFailOnError(error);
        WSTAssert([label.text isEqual:@"Test text"]);
        
        return KIFTestStepResultSuccess;
        
    }]];
    
    return scenario;
}

+ (id)scenarioUnitTestParameterProxyUsedDefault
{
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Test parameter proxies are replaced by the default if the keypath is not found in the context"];
    
    [scenario addStep:[KIFTestStep stepWithDescription:scenario.description executionBlock:^KIFTestStepResult(KIFTestStep *step, NSError **outError) {
        
        NSError *error = nil;
        
        WFSSchema *labelSchema = [[WFSSchema alloc] initWithTypeName:@"label" attributes:nil parameters:@[
                                      [[WFSSchemaParameter alloc] initWithName:@"text" value:
                                           [[WFSParameterProxy alloc] initWithTypeName:@"string" attributes:@{ @"keyPath" : @"testKey" } parameters:@[
                                                [[WFSSchemaParameter alloc] initWithName:@"default" value:@"Default text"]
                                           ]]
                                      ]
                                 ]];
        
        WSTTestContext *context = [[WSTTestContext alloc] init];
        context.parameters = @{ @"notTheTestKey" : @"Test text" };
        
        WFSLabel *label = (WFSLabel *)[labelSchema createObjectWithContext:context error:&error];
        WSTFailOnError(error);
        WSTAssert([label.text isEqual:@"Default text"]);
        
        return KIFTestStepResultSuccess;
        
    }]];
    
    return scenario;
}

+ (id)scenarioUnitTestParameterProxyTemplate
{
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Test parameter proxies are replaced by the templated schema"];
    
    [scenario addStep:[KIFTestStep stepWithDescription:scenario.description executionBlock:^KIFTestStepResult(KIFTestStep *step, NSError **outError) {
        
        NSError *error = nil;
        
        WFSSchema *containerSchema = [[WFSSchema alloc] initWithTypeName:@"container" attributes:nil parameters:@[
                                          [[WFSSchemaParameter alloc] initWithName:@"views" value:
                                               [[WFSParameterProxy alloc] initWithTypeName:@"label" attributes:@{ @"keyPath" : @"outerTestKey" } parameters:@[
                                                    [[WFSSchemaParameter alloc] initWithName:@"template" value:
                                                         [[WFSSchema alloc] initWithTypeName:@"label" attributes:nil parameters:@[
                                                              [[WFSSchemaParameter alloc] initWithName:@"text" value:
                                                                   [[WFSParameterProxy alloc] initWithTypeName:@"string" attributes:@{ @"keyPath" : @"innerTestKey" } parameters:@[
                                                                        [[WFSSchemaParameter alloc] initWithName:@"default" value:@"Default text"]
                                                                   ]]
                                                              ]
                                                         ]]
                                                    ]
                                               ]]
                                          ]
                                     ]];
        
        WSTTestContext *context = [[WSTTestContext alloc] init];
        context.parameters = @{ @"outerTestKey" : @[ @{ @"innerTestKey" : @"test1" }, @{ @"innerTestKey" : @"test2" }, @{ @"innerTestKey" : @"test3" } ] };
        
        WFSContainerView *container = (WFSContainerView *)[containerSchema createObjectWithContext:context error:&error];
        WSTFailOnError(error);
        WSTAssert(container.contentViews.count == 3);
        for (WFSLabel *label in container.contentViews)
        {
            WSTAssert([label isKindOfClass:[WFSLabel class]]);
        }
        NSArray *labelTexts = [container.contentViews valueForKey:@"text"];
        NSArray *expectedTexts = @[ @"test1", @"test2", @"test3" ];
        WSTAssert([labelTexts isEqualToArray:expectedTexts]);
        
        return KIFTestStepResultSuccess;
        
    }]];
    
    return scenario;
}

@end
