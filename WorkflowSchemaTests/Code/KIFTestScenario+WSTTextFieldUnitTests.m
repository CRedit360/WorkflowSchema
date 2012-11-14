//
//  KIFTestScenario+WSTUnitTests.m
//  WorkflowSchemaTests
//
//  Created by Simon Booth on 26/10/2012.
//  Copyright (c) 2012 CRedit360. All rights reserved.
//

#import "KIFTestScenario+WSTTextFieldUnitTests.h"
#import "KIFTestStep+WSTShared.h"
#import "WSTAssert.h"
#import "WSTTestAction.h"
#import "WSTTestContext.h"
#import <WorkflowSchema/WorkflowSchema.h>

@implementation KIFTestScenario (WSTUnitTests)

+ (id)scenarioUnitTestCreateTextFieldWithImplicitValidations
{
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Test text field creation with implicit validations"];
    
    [scenario addStep:[KIFTestStep stepWithDescription:scenario.description executionBlock:^KIFTestStepResult(KIFTestStep *step, NSError **outError) {
        
        NSError *error = nil;
        
        WFSSchema *textFieldSchema = [[WFSSchema alloc] initWithTypeName:@"textField" attributes:nil parameters:@[
                                          [[WFSSchemaParameter alloc] initWithName:@"placeholder" value:@"Please enter a value"],
                                          [[WFSSchema alloc] initWithTypeName:@"doesMatchRegularExpression" attributes:nil parameters:@[ @"." ]],
                                          [[WFSSchema alloc] initWithTypeName:@"isEqualToInput" attributes:nil parameters:@[ @"other" ]]
                                      ]];
        
        WSTTestContext *context = [[WSTTestContext alloc] init];
        
        WFSTextField *textField = (WFSTextField *)[textFieldSchema createObjectWithContext:context error:&error];
        WSTFailOnError(error);
        WSTAssert([textField isKindOfClass:[WFSTextField class]]);
        
        WSTAssert(textField.validations.count == 2);
        WFSRegularExpressionCondition *regexCondition = (id)textField.validations[0];
        WSTAssert([regexCondition isKindOfClass:[WFSRegularExpressionCondition class]]);
        WSTAssert([regexCondition.pattern isEqual:@"."]);
        WFSConfirmationCondition *confirmationCondition = (id)textField.validations[1];
        WSTAssert([confirmationCondition isKindOfClass:[WFSConfirmationCondition class]]);
        WSTAssert([confirmationCondition.otherInputName isEqual:@"other"]);
        
        return KIFTestStepResultSuccess;
        
    }]];
    
    return scenario;
}

+ (id)scenarioUnitTestCreateTextFieldWithExplicitValidations
{
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Test textField creation with explicit validations"];

    [scenario addStep:[KIFTestStep stepWithDescription:scenario.description executionBlock:^KIFTestStepResult(KIFTestStep *step, NSError **outError) {
        
        NSError *error = nil;
        
        WFSSchema *textFieldSchema = [[WFSSchema alloc] initWithTypeName:@"textField" attributes:nil parameters:@[
                                          [[WFSSchemaParameter alloc] initWithName:@"placeholder" value:@"Please enter a value"],
                                          [[WFSSchemaParameter alloc] initWithName:@"validations" value:@[
                                               [[WFSSchema alloc] initWithTypeName:@"doesMatchRegularExpression" attributes:nil parameters:@[ @"." ]],
                                               [[WFSSchema alloc] initWithTypeName:@"isEqualToInput" attributes:nil parameters:@[ @"other" ]]
                                           ]]
                                      ]];
        
        WSTTestContext *context = [[WSTTestContext alloc] init];
        
        WFSTextField *textField = (WFSTextField *)[textFieldSchema createObjectWithContext:context error:&error];
        WSTFailOnError(error);
        WSTAssert([textField isKindOfClass:[WFSTextField class]]);
        
        WSTAssert(textField.validations.count == 2);
        WFSRegularExpressionCondition *regexCondition = (id)textField.validations[0];
        WSTAssert([regexCondition isKindOfClass:[WFSRegularExpressionCondition class]]);
        WSTAssert([regexCondition.pattern isEqual:@"."]);
        WFSConfirmationCondition *confirmationCondition = (id)textField.validations[1];
        WSTAssert([confirmationCondition isKindOfClass:[WFSConfirmationCondition class]]);
        WSTAssert([confirmationCondition.otherInputName isEqual:@"other"]);
        
        return KIFTestStepResultSuccess;
        
    }]];
    
    return scenario;
}

+ (id)scenarioUnitTestCreateTextFieldWithNonValidationParameters
{
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Test textField creation with non-validations parameters"];

    [scenario addStep:[KIFTestStep stepWithDescription:scenario.description executionBlock:^KIFTestStepResult(KIFTestStep *step, NSError **outError) {
        
        NSError *error = nil;
        
        WFSSchema *textFieldSchema = [[WFSSchema alloc] initWithTypeName:@"textField" attributes:@{@"name":@"foo"} parameters:@[
                                          [[WFSSchema alloc] initWithTypeName:@"doesMatchRegularExpression" attributes:nil parameters:@[ @"." ]],
                                          [[WFSSchemaParameter alloc] initWithName:@"text" value:@"bar"],
                                          [[WFSSchemaParameter alloc] initWithName:@"placeholder" value:@"fum"]
                                      ]];
        
        WSTTestContext *context = [[WSTTestContext alloc] init];
        
        WFSTextField *textField = (WFSTextField *)[textFieldSchema createObjectWithContext:context error:&error];
        WSTFailOnError(error);
        WSTAssert([textField isKindOfClass:[WFSTextField class]]);
        
        WSTAssert(textField.validations.count == 1);
        WFSRegularExpressionCondition *regexCondition = (id)textField.validations[0];
        WSTAssert([regexCondition isKindOfClass:[WFSRegularExpressionCondition class]]);
        WSTAssert([regexCondition.pattern isEqual:@"."]);
        
        WSTAssert([textField.workflowName isEqual:@"foo"]);
        WSTAssert([textField.text isEqual:@"bar"]);
        WSTAssert([textField.placeholder isEqual:@"fum"]);
        
        return KIFTestStepResultSuccess;
        
    }]];
    
    return scenario;
}

+ (id)scenarioUnitTestCreateTextFieldWithoutValidations
{
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Test textField creation without conditions"];

    [scenario addStep:[KIFTestStep stepWithDescription:scenario.description executionBlock:^KIFTestStepResult(KIFTestStep *step, NSError **outError) {
        
        NSError *error = nil;
        
        WFSSchema *textFieldSchema = [[WFSSchema alloc] initWithTypeName:@"textField" attributes:@{@"name":@"foo"} parameters:@[
                                          [[WFSSchemaParameter alloc] initWithName:@"text" value:@"bar"],
                                          [[WFSSchemaParameter alloc] initWithName:@"placeholder" value:@"fum"]
                                      ]];
        
        WSTTestContext *context = [[WSTTestContext alloc] init];
        
        WFSTextField *textField = (WFSTextField *)[textFieldSchema createObjectWithContext:context error:&error];
        WSTFailOnError(error);
        WSTAssert([textField isKindOfClass:[WFSTextField class]]);
        
        WSTAssert(textField.validations.count == 0);
        WSTAssert([textField.workflowName isEqual:@"foo"]);
        WSTAssert([textField.text isEqual:@"bar"]);
        WSTAssert([textField.placeholder isEqual:@"fum"]);

        return KIFTestStepResultSuccess;
        
    }]];
    
    return scenario;
}

@end
