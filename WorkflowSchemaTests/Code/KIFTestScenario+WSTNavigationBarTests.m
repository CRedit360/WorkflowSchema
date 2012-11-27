//
//  KIFTestScenario+WSTNavigationBarTests.m
//  WorkflowSchemaTests
//
//  Created by Simon Booth on 27/11/2012.
//  Copyright (c) 2012 CRedit360. All rights reserved.
//

#import "KIFTestScenario+WSTNavigationBarTests.h"
#import "KIFTestStep+WSTShared.h"
#import "WSTAssert.h"
#import "WSTTestAction.h"
#import "WSTTestContext.h"
#import <WorkflowSchema/WorkflowSchema.h>

@implementation KIFTestScenario (WSTNavigationBarTests)

+ (id)scenarioUnitTestCreateNavigationBarWithImplicitItems
{
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Test navigation bar creation with implicit items"];
    
    [scenario addStep:[KIFTestStep stepWithDescription:scenario.description executionBlock:^KIFTestStepResult(KIFTestStep *step, NSError **outError) {
        
        NSError *error = nil;
        
        WFSSchema *navigationBarSchema = [[WFSSchema alloc] initWithTypeName:@"navigationBar" attributes:@{@"name":@"foo"} parameters:@[
                                              [[WFSSchemaParameter alloc] initWithName:@"barStyle" value:@"black"],
                                              [[WFSSchema alloc] initWithTypeName:@"navigationItem" attributes:nil parameters:@[
                                                   [[WFSSchemaParameter alloc] initWithName:@"title" value:@"test title"],
                                                   [[WFSSchemaParameter alloc] initWithName:@"prompt" value:@"test prompt"],
                                              ]]
                                         ]];
        
        WSTTestContext *context = [[WSTTestContext alloc] init];
        
        WFSNavigationBar *navigationBar = (WFSNavigationBar *)[navigationBarSchema createObjectWithContext:context error:&error];
        WSTFailOnError(error);
        WSTAssert([navigationBar isKindOfClass:[WFSNavigationBar class]]);
        
        WSTAssert([navigationBar.workflowName isEqual:@"foo"]);
        WSTAssert(navigationBar.barStyle == UIBarStyleBlack);
        WSTAssert(navigationBar.items.count == 1);
        WSTAssert([[navigationBar.items[0] title] isEqual:@"test title"]);
        WSTAssert([[navigationBar.items[0] prompt] isEqual:@"test prompt"]);
        
        return KIFTestStepResultSuccess;
        
    }]];
    
    return scenario;
}

+ (id)scenarioUnitTestCreateNavigationBarWithExplicitItems
{
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Test navigation bar creation with explicit items"];
    
    [scenario addStep:[KIFTestStep stepWithDescription:scenario.description executionBlock:^KIFTestStepResult(KIFTestStep *step, NSError **outError) {
        
        NSError *error = nil;
        
        WFSSchema *navigationBarSchema = [[WFSSchema alloc] initWithTypeName:@"navigationBar" attributes:@{@"name":@"foo"} parameters:@[
                                              [[WFSSchemaParameter alloc] initWithName:@"barStyle" value:@"black"],
                                              [[WFSSchemaParameter alloc] initWithName:@"items" value:@[
                                                   [[WFSSchema alloc] initWithTypeName:@"navigationItem" attributes:nil parameters:@[
                                                        [[WFSSchemaParameter alloc] initWithName:@"title" value:@"test title"],
                                                        [[WFSSchemaParameter alloc] initWithName:@"prompt" value:@"test prompt"],
                                                   ]]
                                              ]]
                                         ]];
        
        WSTTestContext *context = [[WSTTestContext alloc] init];
        
        WFSNavigationBar *navigationBar = (WFSNavigationBar *)[navigationBarSchema createObjectWithContext:context error:&error];
        WSTFailOnError(error);
        WSTAssert([navigationBar isKindOfClass:[WFSNavigationBar class]]);
        
        WSTAssert([navigationBar.workflowName isEqual:@"foo"]);
        WSTAssert(navigationBar.barStyle == UIBarStyleBlack);
        WSTAssert(navigationBar.items.count == 1);
        WSTAssert([[navigationBar.items[0] title] isEqual:@"test title"]);
        WSTAssert([[navigationBar.items[0] prompt] isEqual:@"test prompt"]);
        
        return KIFTestStepResultSuccess;
        
    }]];
    
    return scenario;
}

@end
