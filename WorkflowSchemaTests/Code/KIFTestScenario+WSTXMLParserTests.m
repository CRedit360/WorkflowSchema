//
//  KIFTestScenario+WSTXMLParserTests.m
//  WorkflowSchemaTests
//
//  Created by Simon Booth on 30/10/2012.
//  Copyright (c) 2012 CRedit360. All rights reserved.
//

#import "KIFTestScenario+WSTXMLParserTests.h"
#import "KIFTestStep+WSTShared.h"
#import "WSTAssert.h"
#import "WSTTestAction.h"
#import "WSTTestContext.h"
#import <WorkflowSchema/WorkflowSchema.h>



@implementation KIFTestScenario (WSTXMLParserTests)

#pragma mark - Root controllers

#define WSTValidScreenXML @"<screen><title>Test title</title><view><label>Test label</label></view></screen>"

+ (id)scenarioUnitTestParseScreenTag
{
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Test that the parser turns a screen tag into a WFSScreenController schema"];
    
    [scenario addStep:[KIFTestStep stepWithDescription:scenario.description executionBlock:^KIFTestStepResult(KIFTestStep *step, NSError **outError) {
        
        NSError *error = nil;
        
        NSString *screenXML = [NSString stringWithFormat:@"<workflow>%@</workflow>", WSTValidScreenXML];
        WFSSchema *screenSchema = [[[WFSXMLParser alloc] initWithString:screenXML] parse:&error];
        WSTFailOnError(error);
        WSTAssert(screenSchema.schemaClass == [WFSScreenController class]);
        
        return KIFTestStepResultSuccess;
        
    }]];
    
    return scenario;
}

+ (id)scenarioUnitTestParseNavigationTag
{
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Test that the parser turns a navigation tag into a WFSNavigationController schema"];
    
    [scenario addStep:[KIFTestStep stepWithDescription:scenario.description executionBlock:^KIFTestStepResult(KIFTestStep *step, NSError **outError) {
        
        NSError *error = nil;
        
        NSString *navigationXML = [NSString stringWithFormat:@"<workflow><navigation><viewControllers>%@</viewControllers></navigation></workflow>", WSTValidScreenXML];
        WFSSchema *navigationSchema = [[[WFSXMLParser alloc] initWithString:navigationXML] parse:&error];
        WSTFailOnError(error);
        WSTAssert(navigationSchema.schemaClass == [WFSNavigationController class]);
        
        return KIFTestStepResultSuccess;
        
    }]];
    
    return scenario;
}

+ (id)scenarioUnitTestParseTabsTag
{
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Test that the parser turns a tabs tag into a WFSTabBarController schema"];
    
    [scenario addStep:[KIFTestStep stepWithDescription:scenario.description executionBlock:^KIFTestStepResult(KIFTestStep *step, NSError **outError) {
        
        NSError *error = nil;
        
        NSString *tabsXML = [NSString stringWithFormat:@"<workflow><tabs><viewControllers>%@%@%@</viewControllers></tabs></workflow>", WSTValidScreenXML, WSTValidScreenXML, WSTValidScreenXML];
        WFSSchema *tabsSchema = [[[WFSXMLParser alloc] initWithString:tabsXML] parse:&error];
        WSTFailOnError(error);
        WSTAssert(tabsSchema.schemaClass == [WFSTabBarController class]);
        
        return KIFTestStepResultSuccess;
        
    }]];
    
    return scenario;
}

#pragma mark - Simple views

#define WSTScreenXMLFormat @"<workflow><screen><title>Test title</title><view>%@</view></screen>"

+ (id)scenarioUnitTestParseButtonTag
{
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Test that the parser turns a button tag into a WFSButton schema"];
    
    [scenario addStep:[KIFTestStep stepWithDescription:scenario.description executionBlock:^KIFTestStepResult(KIFTestStep *step, NSError **outError) {
        
        NSError *error = nil;
        
        NSString *buttonXML = [NSString stringWithFormat:WSTScreenXMLFormat, @"<button><title>Test</title><message>didTap</message></button>"];
        WFSSchema *buttonSchema = [(WFSSchemaParameter *)([[[WFSXMLParser alloc] initWithString:buttonXML] parse:&error].parameters[1]) value];
        WSTFailOnError(error);
        WSTAssert(buttonSchema.schemaClass == [WFSButton class]);
        WSTAssert(buttonSchema.parameters.count == 2);
        WFSSchemaParameter *buttonTitleParameter = buttonSchema.parameters[0];
        WSTAssert([buttonTitleParameter.name isEqual:@"title"]);
        WSTAssert([buttonTitleParameter.value isEqual:@"Test"]);
        WFSSchemaParameter *buttonMessageParameter = buttonSchema.parameters[1];
        WSTAssert([buttonMessageParameter.name isEqual:@"message"]);
        WSTAssert([buttonMessageParameter.value isEqual:@"didTap"]);
        
        return KIFTestStepResultSuccess;
        
    }]];
    
    return scenario;
}

+ (id)scenarioUnitTestParseImageViewTagWithPCDATA
{
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Test that the parser turns an imageView tag with PCDATA into a WFSImageView with a string parameter"];
    
    [scenario addStep:[KIFTestStep stepWithDescription:scenario.description executionBlock:^KIFTestStepResult(KIFTestStep *step, NSError **outError) {
        
        NSError *error = nil;
        
        NSString *imageViewXML = [NSString stringWithFormat:WSTScreenXMLFormat, @"<imageView>Test</imageView>"];
        WFSSchema *imageViewSchema = [(WFSSchemaParameter *)([[[WFSXMLParser alloc] initWithString:imageViewXML] parse:&error].parameters[1]) value];
        WSTFailOnError(error);
        WSTAssert(imageViewSchema.schemaClass == [WFSImageView class]);
        WSTAssert([imageViewSchema.parameters isEqual:@[ @"Test" ]]);
        
        return KIFTestStepResultSuccess;
        
    }]];
    
    return scenario;
}

+ (id)scenarioUnitTestParseImageViewTagWithImage
{
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Test that the parser turns an imageView tag with an image tag into a WFSImageView with an image schema"];
    
    [scenario addStep:[KIFTestStep stepWithDescription:scenario.description executionBlock:^KIFTestStepResult(KIFTestStep *step, NSError **outError) {
        
        NSError *error = nil;
        
        NSString *imageViewXML = [NSString stringWithFormat:WSTScreenXMLFormat, @"<imageView><image>Test</image></imageView>"];
        WFSSchema *imageViewSchema = [(WFSSchemaParameter *)([[[WFSXMLParser alloc] initWithString:imageViewXML] parse:&error].parameters[1]) value];
        WSTFailOnError(error);
        WSTAssert(imageViewSchema.schemaClass == [WFSImageView class]);
        WSTAssert(imageViewSchema.parameters.count == 1);
        WFSSchema *imageViewImageSchema = imageViewSchema.parameters[0]; // Note - not a parameter because "image" is a registered name.
        WSTAssert(imageViewImageSchema.schemaClass == [UIImage class]);
        WSTAssert([imageViewImageSchema.parameters isEqual:@[ @"Test" ]]);
        
        return KIFTestStepResultSuccess;
        
    }]];
    
    return scenario;
}

+ (id)scenarioUnitTestParseLabelTagWithPCDATA
{
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Test that the parser turns a label tag with PCDATA into a WFSLabel with a string parameter"];
    
    [scenario addStep:[KIFTestStep stepWithDescription:scenario.description executionBlock:^KIFTestStepResult(KIFTestStep *step, NSError **outError) {
        
        NSError *error = nil;
        
        NSString *labelXML = [NSString stringWithFormat:WSTScreenXMLFormat, @"<label>Test</label>"];
        WFSSchema *labelSchema = [(WFSSchemaParameter *)([[[WFSXMLParser alloc] initWithString:labelXML] parse:&error].parameters[1]) value];
        WSTFailOnError(error);
        WSTAssert(labelSchema.schemaClass == [WFSLabel class]);
        WSTAssert([labelSchema.parameters isEqual:@[ @"Test" ]]);
        
        return KIFTestStepResultSuccess;
        
    }]];
    
    return scenario;
}

+ (id)scenarioUnitTestParseLabelTagWithParameter
{
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Test that the parser turns a label tag with a text tag into a WFSLabel with a text schema parameter"];
    
    [scenario addStep:[KIFTestStep stepWithDescription:scenario.description executionBlock:^KIFTestStepResult(KIFTestStep *step, NSError **outError) {
        
        NSError *error = nil;
        
        NSString *labelXML = [NSString stringWithFormat:WSTScreenXMLFormat, @"<label><text>Test</text></label>"];
        WFSSchema *labelSchema = [(WFSSchemaParameter *)([[[WFSXMLParser alloc] initWithString:labelXML] parse:&error].parameters[1]) value];
        WSTFailOnError(error);
        WSTAssert(labelSchema.schemaClass == [WFSLabel class]);
        WSTAssert(labelSchema.parameters.count == 1);
        WFSSchemaParameter *labelTextParameter = labelSchema.parameters[0];
        WSTAssert([labelTextParameter.name isEqual:@"text"]);
        WSTAssert([labelTextParameter.value isEqual:@"Test"]);
        
        return KIFTestStepResultSuccess;
        
    }]];
    
    return scenario;
}

#pragma mark - Text fields

#define WSTTextFieldXMLFormat [NSString stringWithFormat:WSTScreenXMLFormat, @"<textField name=\"Test\"><text>Text</text><placeholder>Placeholder</placeholder>%@</textField>"]
#define WSTTextFieldConditionsXML @"<doesMatchRegularExpression>.</doesMatchRegularExpression><isEqual>blah</isEqual>"

+ (id)scenarioUnitTestParseTextFieldTagWithImplicitConditions
{
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Test that the parser turns a textField tag into a WFSTextField schema with implicit conditions"];
    
    [scenario addStep:[KIFTestStep stepWithDescription:scenario.description executionBlock:^KIFTestStepResult(KIFTestStep *step, NSError **outError) {
        
        NSError *error = nil;
        
        NSString *textFieldXML = [NSString stringWithFormat:WSTTextFieldXMLFormat, WSTTextFieldConditionsXML];
        WFSSchema *textFieldSchema = [(WFSSchemaParameter *)([[[WFSXMLParser alloc] initWithString:textFieldXML] parse:&error].parameters[1]) value];
        WSTFailOnError(error);
        WSTAssert(textFieldSchema.schemaClass == [WFSTextField class]);
        WSTAssert([textFieldSchema.attributes isEqualToDictionary:@{@"name":@"Test"}]);
        WSTAssert((int)textFieldSchema.parameters.count == 4);
        WFSSchemaParameter *textFieldTextParameter = textFieldSchema.parameters[0];
        WSTAssert([textFieldTextParameter.name isEqual:@"text"]);
        WSTAssert([textFieldTextParameter.value isEqual:@"Text"]);
        WFSSchemaParameter *textFieldPlaceholderParameter = textFieldSchema.parameters[1];
        WSTAssert([textFieldPlaceholderParameter.name isEqual:@"placeholder"]);
        WSTAssert([textFieldPlaceholderParameter.value isEqual:@"Placeholder"]);
        WFSSchema *textFieldFirstConditionSchema = textFieldSchema.parameters[2];
        WSTAssert(textFieldFirstConditionSchema.schemaClass == [WFSRegularExpressionCondition class]);
        WFSSchema *textFieldSecondConditionSchema = textFieldSchema.parameters[3];
        WSTAssert(textFieldSecondConditionSchema.schemaClass == [WFSEqualityCondition class]);
        
        return KIFTestStepResultSuccess;
        
    }]];
    
    return scenario;
}

+ (id)scenarioUnitTestParseTextFieldTagWithExplicitConditions
{
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Test that the parser turns a textField tag into a WFSTextField schema with explicit conditions"];
    
    [scenario addStep:[KIFTestStep stepWithDescription:scenario.description executionBlock:^KIFTestStepResult(KIFTestStep *step, NSError **outError) {
        
        NSError *error = nil;
        
        NSString *textFieldXML = [NSString stringWithFormat:WSTTextFieldXMLFormat, [NSString stringWithFormat:@"<conditions>%@</conditions>", WSTTextFieldConditionsXML]];
        WFSSchema *textFieldSchema = [(WFSSchemaParameter *)([[[WFSXMLParser alloc] initWithString:textFieldXML] parse:&error].parameters[1]) value];
        WSTFailOnError(error);
        WSTAssert(textFieldSchema.schemaClass == [WFSTextField class]);
        WSTAssert([textFieldSchema.attributes isEqualToDictionary:@{@"name":@"Test"}]);
        WSTAssert((int)textFieldSchema.parameters.count == 3);
        WFSSchemaParameter *textFieldTextParameter = textFieldSchema.parameters[0];
        WSTAssert([textFieldTextParameter.name isEqual:@"text"]);
        WSTAssert([textFieldTextParameter.value isEqual:@"Text"]);
        WFSSchemaParameter *textFieldPlaceholderParameter = textFieldSchema.parameters[1];
        WSTAssert([textFieldPlaceholderParameter.name isEqual:@"placeholder"]);
        WSTAssert([textFieldPlaceholderParameter.value isEqual:@"Placeholder"]);
        WFSSchemaParameter *textFieldConditionsParameter = textFieldSchema.parameters[2];
        WSTAssert([textFieldConditionsParameter.name isEqual:@"conditions"]);
        NSArray *textFieldConditionsArray = textFieldConditionsParameter.value;
        WFSSchema *textFieldFirstConditionSchema = textFieldConditionsArray[0];
        WSTAssert(textFieldFirstConditionSchema.schemaClass == [WFSRegularExpressionCondition class]);
        WFSSchema *textFieldSecondConditionSchema = textFieldConditionsArray[1];
        WSTAssert(textFieldSecondConditionSchema.schemaClass == [WFSEqualityCondition class]);
        
        return KIFTestStepResultSuccess;
        
    }]];
    
    return scenario;
}

#pragma mark - Schema variants

+ (id)scenarioUnitTestParseParameterProxy
{
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Test that the parser turns a screen tag with a parameter attribute into a parameter proxy"];
    
    [scenario addStep:[KIFTestStep stepWithDescription:scenario.description executionBlock:^KIFTestStepResult(KIFTestStep *step, NSError **outError) {
        
        NSError *error = nil;
        
        NSString *proxyXML = @"<workflow><screen keyPath=\"test\" /></workflow>";
        WFSParameterProxy *proxySchema = (WFSParameterProxy *)[[[WFSXMLParser alloc] initWithString:proxyXML] parse:&error];
        WSTFailOnError(error);
        WSTAssert([proxySchema isKindOfClass:[WFSParameterProxy class]]);
        WSTAssert(proxySchema.schemaClass == [WFSScreenController class]);
        WSTAssert([proxySchema.parameterKeyPath isEqualToString:@"test"]);
        
        return KIFTestStepResultSuccess;
        
    }]];
    
    return scenario;
}

+ (id)scenarioUnitTestParseWithStyleNames
{
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Test that the parser turns a screen tag with a parameter attribute into a parameter proxy"];
    
    [scenario addStep:[KIFTestStep stepWithDescription:scenario.description executionBlock:^KIFTestStepResult(KIFTestStep *step, NSError **outError) {
        
        NSError *error = nil;
        
        NSString *styledScreenXML = @"<workflow><screen class=\"test\"><title>Test title</title><view><label>Test label</label></view></screen></workflow>";
        WFSSchema *styledScreenSchema = [[[WFSXMLParser alloc] initWithString:styledScreenXML] parse:&error];
        WSTFailOnError(error);
        WSTAssert([styledScreenSchema isKindOfClass:[WFSSchema class]]);
        WSTAssert([styledScreenSchema.styleName isEqualToString:@"test"]);
        
        return KIFTestStepResultSuccess;
        
    }]];
    
    return scenario;
}

@end
