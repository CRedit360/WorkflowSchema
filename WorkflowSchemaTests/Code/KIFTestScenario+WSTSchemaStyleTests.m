//
//  KIFTestScenario+WSTSchemaStyleTests.m
//  WorkflowSchemaTests
//
//  Created by Simon Booth on 30/10/2012.
//  Copyright (c) 2012 CRedit360. All rights reserved.
//

#import "KIFTestScenario+WSTSchemaStyleTests.h"
#import "KIFTestStep+WSTShared.h"
#import "WSTAssert.h"
#import "WSTTestAction.h"
#import "WSTTestContext.h"
#import <WorkflowSchema/WorkflowSchema.h>

@implementation KIFTestScenario (WSTSchemaStyleTests)

+ (id)scenarioUnitTestCreateLabelsWithStyleNames
{
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Test that styled schemata have dynamic schemaClasses"];
    
    [scenario addStep:[KIFTestStep stepWithDescription:scenario.description executionBlock:^KIFTestStepResult(KIFTestStep *step, NSError **outError) {
        
        NSError *error = nil;
        
        // First check that the schemata have the classes we expect
        
        WFSSchema *vanillaLabelSchema = [[WFSSchema alloc] initWithTypeName:@"label" attributes:nil parameters:@[@"Text"]];
        WSTAssert(vanillaLabelSchema.schemaClass == [WFSLabel class]);
        
        WFSSchema *chocolateLabelSchema = [[WFSSchema alloc] initWithTypeName:@"label" attributes:@{@"class":@"chocolate"} parameters:@[@"Text"]];
        Class chocolateLabelClass = [chocolateLabelSchema schemaClass];
        
        WSTAssert([NSStringFromClass(chocolateLabelClass) isEqualToString:@"WFSLabel.chocolate"])
        WSTAssert([chocolateLabelClass isSubclassOfClass:[WFSLabel class]]);
        
        WFSSchema *strawberryLabelSchema1 = [[WFSSchema alloc] initWithTypeName:@"label" attributes:@{@"class":@"strawberry"} parameters:@[@"Text"]];
        Class strawberryLabelClass1 = [strawberryLabelSchema1 schemaClass];
        
        WSTAssert([NSStringFromClass(strawberryLabelClass1) isEqualToString:@"WFSLabel.strawberry"])
        WSTAssert([strawberryLabelClass1 isSubclassOfClass:[WFSLabel class]]);
        
        WFSSchema *strawberryLabelSchema2 = [[WFSSchema alloc] initWithTypeName:@"label" attributes:@{@"class":@"strawberry"} parameters:@[@"Text"]];
        Class strawberryLabelClass2 = [strawberryLabelSchema2 schemaClass];
        
        WSTAssert(strawberryLabelClass1 == strawberryLabelClass2);
        
        // Now check that the classes can actually be instantiated
        
        WSTTestContext *context = [[WSTTestContext alloc] init];
        
        WFSLabel *vanillaLabel = (WFSLabel *)[vanillaLabelSchema createObjectWithContext:context error:&error];
        WSTFailOnError(error);
        WSTAssert([vanillaLabel isKindOfClass:[WFSLabel class]]);
        
        WFSLabel *chocolateLabel = (WFSLabel *)[chocolateLabelSchema createObjectWithContext:context error:&error];
        WSTFailOnError(error);
        WSTAssert([chocolateLabel isKindOfClass:chocolateLabelClass]);
        
        WFSLabel *strawberryLabel1 = (WFSLabel *)[strawberryLabelSchema1 createObjectWithContext:context error:&error];
        WSTFailOnError(error);
        WSTAssert([strawberryLabel1 isKindOfClass:strawberryLabelClass1]);
        
        WFSLabel *strawberryLabel2 = (WFSLabel *)[strawberryLabelSchema2 createObjectWithContext:context error:&error];
        WSTFailOnError(error);
        WSTAssert([strawberryLabel2 isKindOfClass:strawberryLabelClass2]);
        
        return KIFTestStepResultSuccess;
        
    }]];
    
    return scenario;
}

@end
