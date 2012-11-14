//
//  KIFTestStep+WSTShared.m
//  WorkflowSchemaTests
//
//  Created by Simon Booth on 22/10/2012.
//  Copyright (c) 2012 CRedit360. All rights reserved.
//

#import "KIFTestStep+WSTShared.h"
#import "WSTAppDelegate.h"
#import <WorkflowSchema/WorkflowSchema.h>
#import "UIApplication-KIFAdditions.h"
#import "UIAccessibilityElement-KIFAdditions.h"

@implementation KIFTestStep (WSTShared)

+ (KIFTestStep *)stepToSetupWindowWithWorkflow:(NSString *)fileName
{
    return [self stepWithDescription:[NSString stringWithFormat:@"Set up the main window with workflow '%@'", fileName] executionBlock:^KIFTestStepResult(KIFTestStep *step, NSError **error) {
        
        WSTAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        [appDelegate setupWindowWithWorkflowFile:fileName];
        return KIFTestStepResultSuccess;
        
    }];
}

+ (KIFTestStep *)stepToExamineWindow:(KIFTestStepResult(^)(UIWindow *window, NSError **outError))block
{
    return [self stepWithDescription:@"Examine the main window" executionBlock:^KIFTestStepResult(KIFTestStep *step, NSError **error) {
        
        WSTAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        return block(appDelegate.window, error);
        
    }];
}

+ (KIFTestStep *)stepToSetupMessageType:(NSString *)type name:(NSString *)name data:(NSDictionary *)data
{
    return [self stepWithDescription:@"Set message data" executionBlock:^KIFTestStepResult(KIFTestStep *step, NSError **error) {
        
        WSTAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        appDelegate.messageData = @{ type: @{ name:data }};
        return KIFTestStepResultSuccess;
        
    }];
}

+ (KIFTestStep *)stepToWaitForAbsenceOfViewWithAccessibilityLabel:(NSString *)label zeroSizeIsAbsent:(BOOL)zeroSizeIsAbsent
{
    NSString *description = [NSString stringWithFormat:@"Wait for view with accessibility label \"%@\" to be gone", label];
    
    return [self stepWithDescription:description executionBlock:^(KIFTestStep *step, NSError **error) {
        
        // If the app is ignoring interaction events, then wait before doing our analysis
        KIFTestWaitCondition(![[UIApplication sharedApplication] isIgnoringInteractionEvents], error, @"Application is ignoring interaction events.");
        
        // If the element can't be found, then we're done
        UIAccessibilityElement *element = [[UIApplication sharedApplication] accessibilityElementWithLabel:label accessibilityValue:nil traits:UIAccessibilityTraitNone];
        if (!element) {
            return KIFTestStepResultSuccess;
        }
        
        UIView *view = [UIAccessibilityElement viewContainingAccessibilityElement:element];
        
        // If we found an element, but it's not associated with a view, then something's wrong. Wait it out and try again.
        KIFTestWaitCondition(view, error, @"Cannot find view containing accessibility element with the label \"%@\"", label);
        
        // Hidden views count as absent
        BOOL absent = [view isHidden];
        if (zeroSizeIsAbsent)
        {
            absent |= (view.bounds.size.width == 0);
            absent |= (view.bounds.size.height == 0);
        }
        
        KIFTestWaitCondition(absent, error, @"Accessibility element with label \"%@\" is visible and not hidden.", label);
        
        return KIFTestStepResultSuccess;
    }];
}

+ (NSArray *)stepsToWaitForViewWithAccessibilityLabel:(NSString *)waitLabel dismissedByTappingViewWithAccessibilityLabel:(NSString *)dismissLabel
{
    return @[
        [self stepToWaitForViewWithAccessibilityLabel:waitLabel],
        [self stepToTapViewWithAccessibilityLabel:dismissLabel],
        [self stepToWaitForAbsenceOfViewWithAccessibilityLabel:waitLabel]
    ];
}

@end
