//
//  KIFTestScenario+WSTAttributedTextViewUnitTests.m
//  WorkflowSchemaTests
//
//  Created by Simon Booth on 28/11/2012.
//  Copyright (c) 2012 CRedit360. All rights reserved.
//

#import "KIFTestScenario+WSTAttributedTextViewUnitTests.h"
#import "KIFTestStep+WSTShared.h"
#import "WSTAssert.h"
#import "WSTTestAction.h"
#import "WSTTestContext.h"
#import <WorkflowSchema+DTCoreText/WorkflowSchema+DTCoreText.h>

@implementation KIFTestScenario (WSTAttributedTextViewUnitTests)

+ (id)scenarioUnitTestCreateAttributedTextViewWithImplicitHTML
{
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Test attributed text view creation with implicit html"];
    
    [scenario addStep:[KIFTestStep stepWithDescription:scenario.description executionBlock:^KIFTestStepResult(KIFTestStep *step, NSError **outError) {
        
        NSError *error = nil;
        NSString *html = @"This <i>is</i> some <b>rich</b> text &amp; that was an entity";
        NSData *htmlData = [html dataUsingEncoding:NSUTF8StringEncoding];
        
        WFSSchema *attributedTextViewSchema = [[WFSSchema alloc] initWithTypeName:@"attributedTextView" attributes:nil parameters:@[html]];
        
        WSTTestContext *context = [[WSTTestContext alloc] init];
        
        DTAttributedTextView *attributedTextView = (DTAttributedTextView *)[attributedTextViewSchema createObjectWithContext:context error:&error];
        WSTFailOnError(error);
        WSTAssert([attributedTextView isKindOfClass:[DTAttributedTextView class]]);
        
        NSAttributedString *attributedString = [[NSAttributedString alloc] initWithHTMLData:htmlData documentAttributes:nil];
        
        // Test that the descriptions are equal, since NSAttributedString equality is "problematic"
        WSTAssert([[attributedTextView.attributedString description] isEqual:[attributedString description]]);
        
        return KIFTestStepResultSuccess;
        
    }]];
    
    return scenario;
}

+ (id)scenarioUnitTestCreateAttributedTextViewWithExplicitHTML
{
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Test attributed text view creation with explicit html"];
    
    [scenario addStep:[KIFTestStep stepWithDescription:scenario.description executionBlock:^KIFTestStepResult(KIFTestStep *step, NSError **outError) {
        
        NSError *error = nil;
        NSString *html = @"This <i>is</i> some <b>rich</b> text &amp; that was an entity";
        NSData *htmlData = [html dataUsingEncoding:NSUTF8StringEncoding];
        
        WFSSchema *attributedTextViewSchema = [[WFSSchema alloc] initWithTypeName:@"attributedTextView" attributes:nil parameters:@[
                                                [[WFSSchema alloc] initWithTypeName:@"attributedString" attributes:nil parameters:@[html]]
                                              ]];
        
        WSTTestContext *context = [[WSTTestContext alloc] init];
        
        DTAttributedTextView *attributedTextView = (DTAttributedTextView *)[attributedTextViewSchema createObjectWithContext:context error:&error];
        WSTFailOnError(error);
        WSTAssert([attributedTextView isKindOfClass:[DTAttributedTextView class]]);
        
        NSAttributedString *attributedString = [[NSAttributedString alloc] initWithHTMLData:htmlData documentAttributes:nil];
        
        // Test that the descriptions are equal, since NSAttributedString equality is "problematic"
        WSTAssert([[attributedTextView.attributedString description] isEqual:[attributedString description]]);
        
        return KIFTestStepResultSuccess;
        
    }]];
    
    return scenario;
}

@end
