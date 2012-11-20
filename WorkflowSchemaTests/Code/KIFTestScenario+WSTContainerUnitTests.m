//
//  KIFTestScenario+WSTUnitTests.m
//  WorkflowSchemaTests
//
//  Created by Simon Booth on 26/10/2012.
//  Copyright (c) 2012 CRedit360. All rights reserved.
//

#import "KIFTestScenario+WSTContainerUnitTests.h"
#import "KIFTestStep+WSTShared.h"
#import "WSTAssert.h"
#import "WSTTestAction.h"
#import "WSTTestContext.h"
#import <WorkflowSchema/WorkflowSchema.h>

@implementation KIFTestScenario (WSTUnitTests)

+ (id)scenarioUnitTestCreateContainerViewWithImplicitViews
{
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Test container view creation with implicit views"];
    
    [scenario addStep:[KIFTestStep stepWithDescription:scenario.description executionBlock:^KIFTestStepResult(KIFTestStep *step, NSError **outError) {
        
        NSError *error = nil;
        
        WFSSchema *textFieldSchema = [[WFSSchema alloc] initWithTypeName:@"container" attributes:nil parameters:@[
                                          [[WFSSchema alloc] initWithTypeName:@"button" attributes:nil parameters:@[
                                               [[WFSSchemaParameter alloc] initWithName:@"title" value:@"Test"],
                                               [[WFSSchema alloc] initWithTypeName:@"message" attributes:nil parameters:@[ @"didTap" ]]
                                          ]],
                                          [[WFSSchema alloc] initWithTypeName:@"imageView" attributes:nil parameters:@[
                                               @"first"
                                          ]],
                                          [[WFSSchema alloc] initWithTypeName:@"label" attributes:nil parameters:@[
                                               @"Text"
                                          ]],
                                          [[WFSSchema alloc] initWithTypeName:@"textField" attributes:@{@"name":@"foo"} parameters:@[
                                               [[WFSSchemaParameter alloc] initWithName:@"placeholder" value:@"Please enter a value for foo"]
                                          ]]
                                      ]];
        
        WSTTestContext *context = [[WSTTestContext alloc] init];
        
        WFSContainerView *container = (WFSContainerView *)[textFieldSchema createObjectWithContext:context error:&error];
        WSTFailOnError(error);
        WSTAssert([container isKindOfClass:[WFSContainerView class]]);
        WSTAssert(container.layout == WFSContainerViewVerticalLayout);
        
        WSTAssert(container.contentViews.count == 4);
        WSTAssert([container.contentViews[0] isKindOfClass:[WFSButton class]]);
        WSTAssert([container.contentViews[1] isKindOfClass:[WFSImageView class]]);
        WSTAssert([container.contentViews[2] isKindOfClass:[WFSLabel class]]);
        WSTAssert([container.contentViews[3] isKindOfClass:[WFSTextField class]]);
        
        return KIFTestStepResultSuccess;
        
    }]];
    
    return scenario;
}

+ (id)scenarioUnitTestCreateContainerViewWithExplicitViews
{
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Test container view creation with explicit views"];
    
    [scenario addStep:[KIFTestStep stepWithDescription:scenario.description executionBlock:^KIFTestStepResult(KIFTestStep *step, NSError **outError) {
        
        NSError *error = nil;
        
        WFSSchema *textFieldSchema = [[WFSSchema alloc] initWithTypeName:@"container" attributes:nil parameters:@[
                                          [[WFSSchemaParameter alloc] initWithName:@"views" value:@[
                                               [[WFSSchema alloc] initWithTypeName:@"button" attributes:nil parameters:@[
                                                    [[WFSSchemaParameter alloc] initWithName:@"title" value:@"Test"],
                                                    [[WFSSchema alloc] initWithTypeName:@"message" attributes:nil parameters:@[ @"didTap" ]]
                                               ]],
                                               [[WFSSchema alloc] initWithTypeName:@"imageView" attributes:nil parameters:@[
                                                    @"first"
                                               ]],
                                               [[WFSSchema alloc] initWithTypeName:@"label" attributes:nil parameters:@[
                                                    @"Text"
                                               ]],
                                               [[WFSSchema alloc] initWithTypeName:@"textField" attributes:@{@"name":@"foo"} parameters:@[
                                                    [[WFSSchemaParameter alloc] initWithName:@"placeholder" value:@"Please enter a value for foo"]
                                               ]]
                                          ]]
                                     ]];
        
        WSTTestContext *context = [[WSTTestContext alloc] init];
        
        WFSContainerView *container = (WFSContainerView *)[textFieldSchema createObjectWithContext:context error:&error];
        WSTFailOnError(error);
        WSTAssert([container isKindOfClass:[WFSContainerView class]]);
        WSTAssert(container.layout == WFSContainerViewVerticalLayout);
        
        WSTAssert(container.contentViews.count == 4);
        WSTAssert([container.contentViews[0] isKindOfClass:[WFSButton class]]);
        WSTAssert([container.contentViews[1] isKindOfClass:[WFSImageView class]]);
        WSTAssert([container.contentViews[2] isKindOfClass:[WFSLabel class]]);
        WSTAssert([container.contentViews[3] isKindOfClass:[WFSTextField class]]);
        
        return KIFTestStepResultSuccess;
        
    }]];
    
    return scenario;
}

+ (id)scenarioUnitTestCreateContainerViewWithLayout
{
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Test container view creation with layout"];

    [scenario addStep:[KIFTestStep stepWithDescription:scenario.description executionBlock:^KIFTestStepResult(KIFTestStep *step, NSError **outError) {
        
        NSError *error = nil;
        
        WFSSchema *textFieldSchema = [[WFSSchema alloc] initWithTypeName:@"container" attributes:nil parameters:@[
                                          [[WFSSchemaParameter alloc] initWithName:@"layout" value:@"center"],
                                          [[WFSSchema alloc] initWithTypeName:@"label" attributes:nil parameters:@[
                                           @"Text"
                                           ]]
                                      ]];
        
        WSTTestContext *context = [[WSTTestContext alloc] init];
        
        WFSContainerView *container = (WFSContainerView *)[textFieldSchema createObjectWithContext:context error:&error];
        WSTFailOnError(error);
        WSTAssert([container isKindOfClass:[WFSContainerView class]]);
        WSTAssert(container.layout == WFSContainerViewCenterLayout);
        
        return KIFTestStepResultSuccess;
        
    }]];
    
    return scenario;
}

+ (id)scenarioUnitTestCreateContainerViewWithoutViews
{
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Test container view creation without views"];

    [scenario addStep:[KIFTestStep stepWithDescription:scenario.description executionBlock:^KIFTestStepResult(KIFTestStep *step, NSError **outError) {
        
        NSError *error = nil;
        
        WFSSchema *textFieldSchema = [[WFSSchema alloc] initWithTypeName:@"container" attributes:nil parameters:nil];
        
        WSTTestContext *context = [[WSTTestContext alloc] init];
        
        WFSContainerView *container = (WFSContainerView *)[textFieldSchema createObjectWithContext:context error:&error];
        WSTAssert(container == nil);
        WSTAssert(error != nil);
        
        return KIFTestStepResultSuccess;
        
    }]];
    
    
    return scenario;
}


@end
