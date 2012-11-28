//
//  KIFTestScenario+WSTTextViewUnitTests.m
//  WorkflowSchemaTests
//
//  Created by Simon Booth on 26/10/2012.
//  Copyright (c) 2012 CRedit360. All rights reserved.
//

#import "KIFTestScenario+WSTTextViewUnitTests.h"
#import "KIFTestStep+WSTShared.h"
#import "WSTAssert.h"
#import "WSTTestAction.h"
#import "WSTTestContext.h"
#import <WorkflowSchema/WorkflowSchema.h>

@implementation KIFTestScenario (WSTTextViewUnitTests)

+ (id)scenarioUnitTestCreateTextViewWithoutValidations
{
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Test textView creation without validations"];
    
    [scenario addStep:[KIFTestStep stepWithDescription:scenario.description executionBlock:^KIFTestStepResult(KIFTestStep *step, NSError **outError) {
        
        NSError *error = nil;
        
        WFSSchema *textViewSchema = [[WFSSchema alloc] initWithTypeName:@"textView" attributes:@{@"name":@"foo"} parameters:@[
                                         [[WFSSchemaParameter alloc] initWithName:@"text" value:@"bar"],
                                         [[WFSSchemaParameter alloc] initWithName:@"accessibilityLabel" value:@"fum"]
                                    ]];
        
        WSTTestContext *context = [[WSTTestContext alloc] init];
        
        WFSTextView *textView = (WFSTextView *)[textViewSchema createObjectWithContext:context error:&error];
        WSTFailOnError(error);
        WSTAssert([textView isKindOfClass:[WFSTextView class]]);
        
        WSTAssert(textView.validations.count == 0);
        WSTAssert([textView.workflowName isEqual:@"foo"]);
        WSTAssert([textView.text isEqual:@"bar"]);
        WSTAssert([textView.accessibilityLabel isEqual:@"fum"]);
        
        return KIFTestStepResultSuccess;
        
    }]];
    
    return scenario;
}

+ (id)scenarioUnitTestCreateTextViewWithImplicitValidations
{
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Test text view creation with implicit validations"];
    
    [scenario addStep:[KIFTestStep stepWithDescription:scenario.description executionBlock:^KIFTestStepResult(KIFTestStep *step, NSError **outError) {
        
        NSError *error = nil;
        
        WFSSchema *textViewSchema = [[WFSSchema alloc] initWithTypeName:@"textView" attributes:nil parameters:@[
                                         [[WFSSchemaParameter alloc] initWithName:@"text" value:@"Please enter a value"],
                                         [[WFSSchemaParameter alloc] initWithName:@"accessibilityLabel" value:@"Value"],
                                         [[WFSSchema alloc] initWithTypeName:@"doesMatchRegularExpression" attributes:nil parameters:@[ @"." ]],
                                         [[WFSSchema alloc] initWithTypeName:@"isEqual" attributes:nil parameters:@[ @"other" ]]
                                    ]];
        
        WSTTestContext *context = [[WSTTestContext alloc] init];
        
        WFSTextView *textView = (WFSTextView *)[textViewSchema createObjectWithContext:context error:&error];
        WSTFailOnError(error);
        WSTAssert([textView isKindOfClass:[WFSTextView class]]);
        
        WSTAssert(textView.validations.count == 2);
        WFSRegularExpressionCondition *regexCondition = (id)textView.validations[0];
        WSTAssert([regexCondition isKindOfClass:[WFSRegularExpressionCondition class]]);
        WSTAssert([regexCondition.pattern isEqual:@"."]);
        WFSEqualityCondition *confirmationCondition = (id)textView.validations[1];
        WSTAssert([confirmationCondition isKindOfClass:[WFSEqualityCondition class]]);
        WSTAssert([confirmationCondition.otherValue isEqual:@"other"]);
        
        return KIFTestStepResultSuccess;
        
    }]];
    
    return scenario;
}

+ (id)scenarioUnitTestCreateTextViewWithExplicitValidations
{
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Test textView creation with explicit validations"];
    
    [scenario addStep:[KIFTestStep stepWithDescription:scenario.description executionBlock:^KIFTestStepResult(KIFTestStep *step, NSError **outError) {
        
        NSError *error = nil;
        
        WFSSchema *textViewSchema = [[WFSSchema alloc] initWithTypeName:@"textView" attributes:nil parameters:@[
                                         [[WFSSchemaParameter alloc] initWithName:@"text" value:@"Please enter a value"],
                                         [[WFSSchemaParameter alloc] initWithName:@"accessibilityLabel" value:@"Value"],
                                         [[WFSSchemaParameter alloc] initWithName:@"validations" value:@[
                                              [[WFSSchema alloc] initWithTypeName:@"doesMatchRegularExpression" attributes:nil parameters:@[ @"." ]],
                                              [[WFSSchema alloc] initWithTypeName:@"isEqual" attributes:nil parameters:@[ @"other" ]]
                                         ]]
                                    ]];
        
        WSTTestContext *context = [[WSTTestContext alloc] init];
        
        WFSTextView *textView = (WFSTextView *)[textViewSchema createObjectWithContext:context error:&error];
        WSTFailOnError(error);
        WSTAssert([textView isKindOfClass:[WFSTextView class]]);
        
        WSTAssert(textView.validations.count == 2);
        WFSRegularExpressionCondition *regexCondition = (id)textView.validations[0];
        WSTAssert([regexCondition isKindOfClass:[WFSRegularExpressionCondition class]]);
        WSTAssert([regexCondition.pattern isEqual:@"."]);
        WFSEqualityCondition *confirmationCondition = (id)textView.validations[1];
        WSTAssert([confirmationCondition isKindOfClass:[WFSEqualityCondition class]]);
        WSTAssert([confirmationCondition.otherValue isEqual:@"other"]);
        
        return KIFTestStepResultSuccess;
        
    }]];
    
    return scenario;
}

+ (id)scenarioUnitTestCreateTextViewWithNonValidationParameters
{
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Test textView creation with non-validations parameters"];
    
    [scenario addStep:[KIFTestStep stepWithDescription:scenario.description executionBlock:^KIFTestStepResult(KIFTestStep *step, NSError **outError) {
        
        NSError *error = nil;
        
        WFSSchema *textViewSchema = [[WFSSchema alloc] initWithTypeName:@"textView" attributes:@{@"name":@"foo"} parameters:@[
                                         [[WFSSchemaParameter alloc] initWithName:@"text" value:@"bar"],
                                         [[WFSSchemaParameter alloc] initWithName:@"accessibilityLabel" value:@"fum"],
                                         [[WFSSchemaParameter alloc] initWithName:@"dataDetectorTypes" value:@"phoneNumber,address"],
                                         [[WFSSchemaParameter alloc] initWithName:@"editable" value:@"NO"]
                                    ]];
        
        WSTTestContext *context = [[WSTTestContext alloc] init];
        
        WFSTextView *textView = (WFSTextView *)[textViewSchema createObjectWithContext:context error:&error];
        WSTFailOnError(error);
        WSTAssert([textView isKindOfClass:[WFSTextView class]]);
        
        WSTAssert([textView.workflowName isEqual:@"foo"]);
        WSTAssert([textView.text isEqual:@"bar"]);
        WSTAssert([textView.accessibilityLabel isEqual:@"fum"]);
        WSTAssert(textView.dataDetectorTypes == (UIDataDetectorTypeAddress|UIDataDetectorTypePhoneNumber));
        WSTAssert(textView.editable == NO);
        
        return KIFTestStepResultSuccess;
        
    }]];
    
    return scenario;
}

+ (id)scenarioUnitTestCreateTextViewWithoutAccessibilityLabel
{
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Test textView creation without placeholder or accessibility label"];
    
    [scenario addStep:[KIFTestStep stepWithDescription:scenario.description executionBlock:^KIFTestStepResult(KIFTestStep *step, NSError **outError) {
        
        NSError *error = nil;
        
        WFSSchema *textViewSchema = [[WFSSchema alloc] initWithTypeName:@"textView" attributes:@{@"name":@"foo"} parameters:@[
                                         [[WFSSchemaParameter alloc] initWithName:@"text" value:@"bar"]
                                    ]];
        
        WSTTestContext *context = [[WSTTestContext alloc] init];
        
        WFSTextView *textView = (WFSTextView *)[textViewSchema createObjectWithContext:context error:&error];
        WSTAssert(textView == nil);
        WSTAssert(error);
        
        return KIFTestStepResultSuccess;
        
    }]];
    
    return scenario;
}

@end
