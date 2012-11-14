//
//  KIFTestScenario+WSTUnitTests.m
//  WorkflowSchemaTests
//
//  Created by Simon Booth on 26/10/2012.
//  Copyright (c) 2012 CRedit360. All rights reserved.
//

#import "KIFTestScenario+WSTImageViewUnitTests.h"
#import "KIFTestStep+WSTShared.h"
#import "WSTAssert.h"
#import "WSTTestAction.h"
#import "WSTTestContext.h"
#import <WorkflowSchema/WorkflowSchema.h>

@implementation KIFTestScenario (WSTUnitTests)

+ (id)scenarioUnitTestCreateImageViewWithImplicitImageName
{
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Test image view creation with implicit image name"];
        
    [scenario addStep:[KIFTestStep stepWithDescription:scenario.description executionBlock:^KIFTestStepResult(KIFTestStep *step, NSError **outError) {
        
        NSError *error = nil;
        
        WFSSchema *imageViewSchema = [[WFSSchema alloc] initWithTypeName:@"imageView" attributes:nil parameters:@[
                                          @"first"
                                      ]];
        
        WSTTestContext *context = [[WSTTestContext alloc] init];
        
        WFSImageView *imageView = (WFSImageView *)[imageViewSchema createObjectWithContext:context error:&error];
        WSTFailOnError(error);
        WSTAssertEqualImages(imageView.image, [UIImage imageNamed:@"first"]);
        
        return KIFTestStepResultSuccess;
        
    }]];
    
    return scenario;
}

+ (id)scenarioUnitTestCreateImageViewWithExplicitImageName
{
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Test image view creation with explicit image name"];

    [scenario addStep:[KIFTestStep stepWithDescription:scenario.description executionBlock:^KIFTestStepResult(KIFTestStep *step, NSError **outError) {
        
        NSError *error = nil;
        
        WFSSchema *imageViewSchema = [[WFSSchema alloc] initWithTypeName:@"imageView" attributes:nil parameters:@[
                                          [[WFSSchemaParameter alloc] initWithName:@"imageName" value:@"first"],
                                      ]];
        
        WSTTestContext *context = [[WSTTestContext alloc] init];
        
        WFSImageView *imageView = (WFSImageView *)[imageViewSchema createObjectWithContext:context error:&error];
        WSTFailOnError(error);
        WSTAssertEqualImages(imageView.image, [UIImage imageNamed:@"first"]);
        
        return KIFTestStepResultSuccess;
        
    }]];
    
    return scenario;
}

+ (id)scenarioUnitTestCreateImageViewWithImageSchema
{
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Test image view creation with image schema"];

    [scenario addStep:[KIFTestStep stepWithDescription:scenario.description executionBlock:^KIFTestStepResult(KIFTestStep *step, NSError **outError) {
        
        NSError *error = nil;
        
        WFSSchema *imageViewSchema = [[WFSSchema alloc] initWithTypeName:@"imageView" attributes:nil parameters:@[
                                      [[WFSSchema alloc] initWithTypeName:@"image" attributes:nil parameters:@[ @"first" ]]
                                      ]];
        
        WSTTestContext *context = [[WSTTestContext alloc] init];
        
        WFSImageView *imageView = (WFSImageView *)[imageViewSchema createObjectWithContext:context error:&error];
        WSTFailOnError(error);
        WSTAssertEqualImages(imageView.image, [UIImage imageNamed:@"first"]);
        
        return KIFTestStepResultSuccess;
        
    }]];
    
    return scenario;
}

+ (id)scenarioUnitTestCreateImageViewWithoutImage
{
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Test image view creation without image"];

    [scenario addStep:[KIFTestStep stepWithDescription:scenario.description executionBlock:^KIFTestStepResult(KIFTestStep *step, NSError **outError) {
        
        NSError *error = nil;
        
        WFSSchema *imageViewSchema = [[WFSSchema alloc] initWithTypeName:@"imageView" attributes:nil parameters:@[
                                      ]];
        
        WSTTestContext *context = [[WSTTestContext alloc] init];
        
        WFSImageView *imageView = (WFSImageView *)[imageViewSchema createObjectWithContext:context error:&error];
        WSTAssert(imageView == nil);
        WSTAssert(error != nil);
        
        return KIFTestStepResultSuccess;
        
    }]];
    
    return scenario;
}

@end
