//
//  KIFTestScenario+WSTToolbarTests.m
//  WorkflowSchemaTests
//
//  Created by Simon Booth on 22/11/2012.
//  Copyright (c) 2012 CRedit360. All rights reserved.
//

#import "KIFTestScenario+WSTToolbarTests.h"
#import "KIFTestStep+WSTShared.h"
#import "WSTAssert.h"
#import "WSTTestAction.h"
#import "WSTTestContext.h"
#import <WorkflowSchema/WorkflowSchema.h>

@implementation KIFTestScenario (WSTToolbarTests)

+ (id)scenarioUnitTestCreateToolbarWithImplicitItems
{
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Test toolbar creation with implicit items"];
    
    [scenario addStep:[KIFTestStep stepWithDescription:scenario.description executionBlock:^KIFTestStepResult(KIFTestStep *step, NSError **outError) {
        
        NSError *error = nil;
        
        WFSSchema *toolbarSchema = [[WFSSchema alloc] initWithTypeName:@"toolbar" attributes:@{@"name":@"foo"} parameters:@[
                                        [[WFSSchemaParameter alloc] initWithName:@"barStyle" value:@"black"],
                                        [[WFSSchema alloc] initWithTypeName:@"barButtonItem" attributes:nil parameters:@[ @"item1" ]],
                                        [[WFSSchema alloc] initWithTypeName:@"barButtonItem" attributes:nil parameters:@[ @"item2" ]],
                                        [[WFSSchema alloc] initWithTypeName:@"barButtonItem" attributes:nil parameters:@[ @"item3" ]]
                                   ]];
        
        WSTTestContext *context = [[WSTTestContext alloc] init];
        
        WFSToolbar *toolbar = (WFSToolbar *)[toolbarSchema createObjectWithContext:context error:&error];
        WSTFailOnError(error);
        WSTAssert([toolbar isKindOfClass:[WFSToolbar class]]);
        
        WSTAssert([toolbar.workflowName isEqual:@"foo"]);
        WSTAssert(toolbar.barStyle == UIBarStyleBlack);
        WSTAssert(toolbar.items.count == 3);
        WSTAssert([[toolbar.items[0] title] isEqual:@"item1"]);
        WSTAssert([[toolbar.items[1] title] isEqual:@"item2"]);
        WSTAssert([[toolbar.items[2] title] isEqual:@"item3"]);
        
        return KIFTestStepResultSuccess;
        
    }]];
    
    return scenario;
}

+ (id)scenarioUnitTestCreateToolbarWithExplicitItems
{
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Test toolbar creation with explicit items"];
    
    [scenario addStep:[KIFTestStep stepWithDescription:scenario.description executionBlock:^KIFTestStepResult(KIFTestStep *step, NSError **outError) {
        
        NSError *error = nil;
        
        WFSSchema *toolbarSchema = [[WFSSchema alloc] initWithTypeName:@"toolbar" attributes:@{@"name":@"foo"} parameters:@[
                                        [[WFSSchemaParameter alloc] initWithName:@"barStyle" value:@"black"],
                                        [[WFSSchemaParameter alloc] initWithName:@"items" value:@[
                                             [[WFSSchema alloc] initWithTypeName:@"barButtonItem" attributes:nil parameters:@[ @"item1" ]],
                                             [[WFSSchema alloc] initWithTypeName:@"barButtonItem" attributes:nil parameters:@[ @"item2" ]],
                                             [[WFSSchema alloc] initWithTypeName:@"barButtonItem" attributes:nil parameters:@[ @"item3" ]]
                                        ]]
                                   ]];
        
        WSTTestContext *context = [[WSTTestContext alloc] init];
        
        WFSToolbar *toolbar = (WFSToolbar *)[toolbarSchema createObjectWithContext:context error:&error];
        WSTFailOnError(error);
        WSTAssert([toolbar isKindOfClass:[WFSToolbar class]]);
        
        WSTAssert([toolbar.workflowName isEqual:@"foo"]);
        WSTAssert(toolbar.barStyle == UIBarStyleBlack);
        WSTAssert(toolbar.items.count == 3);
        WSTAssert([[toolbar.items[0] title] isEqual:@"item1"]);
        WSTAssert([[toolbar.items[1] title] isEqual:@"item2"]);
        WSTAssert([[toolbar.items[2] title] isEqual:@"item3"]);
        
        return KIFTestStepResultSuccess;
        
    }]];
    
    return scenario;
}

@end
