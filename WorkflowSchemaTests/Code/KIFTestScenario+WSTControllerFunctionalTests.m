//
//  KIFTestScenario+WSTTabControllerTests.m
//  WorkflowSchemaTests
//
//  Created by Simon Booth on 22/10/2012.
//  Copyright (c) 2012 CRedit360. All rights reserved.
//

#import "KIFTestScenario+WSTControllerFunctionalTests.h"
#import "KIFTestStep+WSTShared.h"
#import "WSTAppDelegate.h"
#import "WSTAssert.h"
#import <WorkflowSchema/WorkflowSchema.h>

@implementation KIFTestScenario (WSTControllerFunctionalTests)

+ (id)scenarioFunctionalTestTabs
{
    KIFTestScenario *scenario = [self scenarioWithDescription:@"Test that the tabs tag shows a tab controller"];
    [scenario addStep:[KIFTestStep stepToSetupWindowWithWorkflow:@"tab_tests.xml"]];
    
    // First, check that everything deserialised as expected
    [scenario addStep:[KIFTestStep stepToExamineWindow:^KIFTestStepResult(UIWindow *window, NSError **outError) {
        
        WFSTabBarController *tabBarController = (WFSTabBarController *)window.rootViewController;
        WSTAssert([tabBarController isKindOfClass:[WFSTabBarController class]]);
        
        NSArray *items = tabBarController.tabBar.items;
        WSTAssert(items.count == 3);
        
        UITabBarItem *firstItem = items[0];
        WSTAssert(!firstItem.title);
        WSTAssert(!firstItem.image);
        
        UITabBarItem *secondItem = items[1];
        WSTAssert([secondItem.title isEqualToString:@"Screen 2 title"]);
        WSTAssert(!secondItem.image);
        
        UITabBarItem *thirdItem = items[2];
        WSTAssert([thirdItem.title isEqualToString:@"Screen 3 tabItem title"]);
        WSTAssertEqualImages(thirdItem.image, [UIImage imageNamed:@"first"]);
        
        return KIFTestStepResultSuccess;
        
    }]];
    
    // Check that we can flip between screens by tapping the tabs
    [scenario addStep:[KIFTestStep stepToWaitForViewWithAccessibilityLabel:@"Screen 1 contents" traits:UIAccessibilityTraitStaticText]];
    
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Screen 2 title" traits:UIAccessibilityTraitButton]];
    [scenario addStep:[KIFTestStep stepToWaitForAbsenceOfViewWithAccessibilityLabel:@"Screen 1 contents"]];
    [scenario addStep:[KIFTestStep stepToWaitForViewWithAccessibilityLabel:@"Screen 2 contents" traits:UIAccessibilityTraitStaticText]];
    
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Screen 3 tabItem title" traits:UIAccessibilityTraitButton]];
    [scenario addStep:[KIFTestStep stepToWaitForAbsenceOfViewWithAccessibilityLabel:@"Screen 2 contents"]];
    [scenario addStep:[KIFTestStep stepToWaitForViewWithAccessibilityLabel:@"Screen 3 contents" traits:UIAccessibilityTraitStaticText]];
    
    return scenario;
}

+ (id)scenarioFunctionalTestNavigationStack
{
    KIFTestScenario *scenario = [self scenarioWithDescription:@"Test that the navigation tag shows a navigation stack"];
    [scenario addStep:[KIFTestStep stepToSetupWindowWithWorkflow:@"navigation_stack_tests.xml"]];
    
    // First, check that everything deserialised as expected
    [scenario addStep:[KIFTestStep stepToExamineWindow:^KIFTestStepResult(UIWindow *window, NSError **outError) {
        
        WFSNavigationController *navigationController = (WFSNavigationController *)window.rootViewController;
        WSTAssert([navigationController isKindOfClass:[WFSNavigationController class]]);
        
        NSArray *controllers = navigationController.viewControllers;
        WSTAssert(controllers.count == 1);
        
        WFSScreenController *firstController = controllers[0];
        WSTAssert([firstController isKindOfClass:[WFSScreenController class]]);
        
        return KIFTestStepResultSuccess;
        
    }]];
    
    // Check that we can see the title and contents, and that we can push items onto the stack
    [scenario addStep:[KIFTestStep stepToWaitForViewWithAccessibilityLabel:@"Screen 1 title" traits:UIAccessibilityTraitStaticText]];
    [scenario addStep:[KIFTestStep stepToWaitForViewWithAccessibilityLabel:@"Screen 1 contents" traits:UIAccessibilityTraitStaticText]];
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Push screen 2" traits:UIAccessibilityTraitButton]];
    [scenario addStep:[KIFTestStep stepToWaitForAbsenceOfViewWithAccessibilityLabel:@"Screen 1 contents"]];
    
    // Screen two has no title of its own, so it will use the one from the navigation item
    [scenario addStep:[KIFTestStep stepToWaitForViewWithAccessibilityLabel:@"Screen 2 NI title" traits:UIAccessibilityTraitStaticText]];
    [scenario addStep:[KIFTestStep stepToWaitForViewWithAccessibilityLabel:@"Screen 2 NI prompt"]];
    [scenario addStep:[KIFTestStep stepToWaitForViewWithAccessibilityLabel:@"Screen 2 contents"]];
    
    // Check that we can pop the screen using its back button
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Screen 1 title" traits:UIAccessibilityTraitButton]];
    [scenario addStep:[KIFTestStep stepToWaitForAbsenceOfViewWithAccessibilityLabel:@"Screen 2 contents"]];
    [scenario addStep:[KIFTestStep stepToWaitForViewWithAccessibilityLabel:@"Screen 1 contents" traits:UIAccessibilityTraitStaticText]];
    
    // Now push two screens on
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Push screen 2" traits:UIAccessibilityTraitButton]];
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Push screen 3" traits:UIAccessibilityTraitButton]];
    
    // Screen three has its own title, which beats the one in its navigation item
    [scenario addStep:[KIFTestStep stepToWaitForViewWithAccessibilityLabel:@"Screen 3 title" traits:UIAccessibilityTraitStaticText]];
    [scenario addStep:[KIFTestStep stepToWaitForAbsenceOfViewWithAccessibilityLabel:@"Screen 3 NI title"]];
    
    // Check that the second screen's navigation item back button item is used for the back button
    [scenario addStep:[KIFTestStep stepToWaitForAbsenceOfViewWithAccessibilityLabel:@"Screen 2 contents"]];
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"S2" traits:UIAccessibilityTraitButton]];
    [scenario addStep:[KIFTestStep stepToWaitForViewWithAccessibilityLabel:@"Screen 2 contents"]];
    
    return scenario;
}

+ (id)scenarioFunctionalTestNavigationItems
{
    KIFTestScenario *scenario = [self scenarioWithDescription:@"Test that the navigation item buttons and properties work"];
    [scenario addStep:[KIFTestStep stepToSetupWindowWithWorkflow:@"navigation_item_tests.xml"]];
    
    // Test hidesBackButton
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Test hidesBackButton" traits:UIAccessibilityTraitButton]];
    [scenario addStep:[KIFTestStep stepToWaitForViewWithAccessibilityLabel:@"hidesBackButton test" traits:UIAccessibilityTraitStaticText]];
    [scenario addStep:[KIFTestStep stepToWaitForAbsenceOfViewWithAccessibilityLabel:@"Back" zeroSizeIsAbsent:YES]];
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Pop me" traits:UIAccessibilityTraitButton]];
    
    // Test leftBarButtonItem
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Test leftBarButtonItem" traits:UIAccessibilityTraitButton]];
    [scenario addStep:[KIFTestStep stepToWaitForViewWithAccessibilityLabel:@"leftBarButtonItem test" traits:UIAccessibilityTraitStaticText]];
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Left" traits:UIAccessibilityTraitButton]];
    [scenario addStepsFromArray:[KIFTestStep stepsToWaitForViewWithAccessibilityLabel:@"Left!" dismissedByTappingViewWithAccessibilityLabel:@"OK"]];
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Back" traits:UIAccessibilityTraitButton]];
    
    // Test leftBarButtonItem w/o supplement
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Test leftBarButtonItem w/o supplement" traits:UIAccessibilityTraitButton]];
    [scenario addStep:[KIFTestStep stepToWaitForViewWithAccessibilityLabel:@"leftBarButtonItem test w/o supplement" traits:UIAccessibilityTraitStaticText]];
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Left" traits:UIAccessibilityTraitButton]];
    [scenario addStepsFromArray:[KIFTestStep stepsToWaitForViewWithAccessibilityLabel:@"Left!" dismissedByTappingViewWithAccessibilityLabel:@"OK"]];
    [scenario addStep:[KIFTestStep stepToWaitForAbsenceOfViewWithAccessibilityLabel:@"Back" zeroSizeIsAbsent:YES]];
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Pop me" traits:UIAccessibilityTraitButton]];
    
    // Test leftBarButtonItems
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Test leftBarButtonItems" traits:UIAccessibilityTraitButton]];
    [scenario addStep:[KIFTestStep stepToWaitForViewWithAccessibilityLabel:@"leftBarButtonItems test" traits:UIAccessibilityTraitStaticText]];
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Left 1" traits:UIAccessibilityTraitButton]];
    [scenario addStepsFromArray:[KIFTestStep stepsToWaitForViewWithAccessibilityLabel:@"Left 1!" dismissedByTappingViewWithAccessibilityLabel:@"OK"]];
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Left 2" traits:UIAccessibilityTraitButton]];
    [scenario addStepsFromArray:[KIFTestStep stepsToWaitForViewWithAccessibilityLabel:@"Left 2!" dismissedByTappingViewWithAccessibilityLabel:@"OK"]];
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Back" traits:UIAccessibilityTraitButton]];
    
    // Test leftBarButtonItems w/o supplement
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Test leftBarButtonItems w/o supplement" traits:UIAccessibilityTraitButton]];
    [scenario addStep:[KIFTestStep stepToWaitForViewWithAccessibilityLabel:@"leftBarButtonItems test w/o supplement" traits:UIAccessibilityTraitStaticText]];
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Left 1" traits:UIAccessibilityTraitButton]];
    [scenario addStepsFromArray:[KIFTestStep stepsToWaitForViewWithAccessibilityLabel:@"Left 1!" dismissedByTappingViewWithAccessibilityLabel:@"OK"]];
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Left 2" traits:UIAccessibilityTraitButton]];
    [scenario addStepsFromArray:[KIFTestStep stepsToWaitForViewWithAccessibilityLabel:@"Left 2!" dismissedByTappingViewWithAccessibilityLabel:@"OK"]];
    [scenario addStep:[KIFTestStep stepToWaitForAbsenceOfViewWithAccessibilityLabel:@"Back" zeroSizeIsAbsent:YES]];
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Pop me" traits:UIAccessibilityTraitButton]];
    
    // Test rightBarButtonItem
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Test rightBarButtonItem" traits:UIAccessibilityTraitButton]];
    [scenario addStep:[KIFTestStep stepToWaitForViewWithAccessibilityLabel:@"rightBarButtonItem test" traits:UIAccessibilityTraitStaticText]];
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Right" traits:UIAccessibilityTraitButton]];
    [scenario addStepsFromArray:[KIFTestStep stepsToWaitForViewWithAccessibilityLabel:@"Right!" dismissedByTappingViewWithAccessibilityLabel:@"OK"]];
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Back" traits:UIAccessibilityTraitButton]];
    
    // Test rightBarButtonItem w/ image
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Test rightBarButtonItem w/ image" traits:UIAccessibilityTraitButton]];
    [scenario addStep:[KIFTestStep stepToWaitForViewWithAccessibilityLabel:@"rightBarButtonItem test w/ image" traits:UIAccessibilityTraitStaticText]];
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Right" traits:UIAccessibilityTraitButton]];
    [scenario addStepsFromArray:[KIFTestStep stepsToWaitForViewWithAccessibilityLabel:@"Right!" dismissedByTappingViewWithAccessibilityLabel:@"OK"]];
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Back" traits:UIAccessibilityTraitButton]];
    
    // Test rightBarButtonItems
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Test rightBarButtonItems" traits:UIAccessibilityTraitButton]];
    [scenario addStep:[KIFTestStep stepToWaitForViewWithAccessibilityLabel:@"rightBarButtonItems test" traits:UIAccessibilityTraitStaticText]];
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Right 1" traits:UIAccessibilityTraitButton]];
    [scenario addStepsFromArray:[KIFTestStep stepsToWaitForViewWithAccessibilityLabel:@"Right 1!" dismissedByTappingViewWithAccessibilityLabel:@"OK"]];
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Right 2" traits:UIAccessibilityTraitButton]];
    [scenario addStepsFromArray:[KIFTestStep stepsToWaitForViewWithAccessibilityLabel:@"Right 2!" dismissedByTappingViewWithAccessibilityLabel:@"OK"]];
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Back" traits:UIAccessibilityTraitButton]];
    
    return scenario;
}

+ (KIFTestScenario *)scenarioFunctionalTestForms
{
    KIFTestScenario *scenario = [self scenarioWithDescription:@"Test that forms work"];
    [scenario addStep:[KIFTestStep stepToSetupWindowWithWorkflow:@"form_tests_1.xml"]];
    [scenario addStep:[KIFTestStep stepToWaitForViewWithAccessibilityLabel:@"Form test" traits:UIAccessibilityTraitStaticText]];
    
    // try submitting - it should fail
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Submit" traits:UIAccessibilityTraitButton]];
    [scenario addStepsFromArray:[KIFTestStep stepsToWaitForViewWithAccessibilityLabel:@"Enter a screen title" dismissedByTappingViewWithAccessibilityLabel:@"OK"]];
    
    // Add a screen name and try again
    [scenario addStep:[KIFTestStep stepToEnterText:@"Bob" intoViewWithAccessibilityLabel:@"screenTitle"]];
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Submit" traits:UIAccessibilityTraitButton]];
    [scenario addStepsFromArray:[KIFTestStep stepsToWaitForViewWithAccessibilityLabel:@"Titles must match" dismissedByTappingViewWithAccessibilityLabel:@"OK"]];
    
    // Confirm the screen name and try again
    [scenario addStep:[KIFTestStep stepToEnterText:@"Bob" intoViewWithAccessibilityLabel:@"confirmScreenTitle"]];
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Submit" traits:UIAccessibilityTraitButton]];
    
    // The shown screen ought to have the name we just entered
    [scenario addStep:[KIFTestStep stepToWaitForAbsenceOfViewWithAccessibilityLabel:@"Form test" traits:UIAccessibilityTraitStaticText]];
    [scenario addStep:[KIFTestStep stepToWaitForViewWithAccessibilityLabel:@"Bob" traits:UIAccessibilityTraitStaticText]];
    
    // Enter some data into the new form
    [scenario addStep:[KIFTestStep stepToEnterText:@"Fish" intoViewWithAccessibilityLabel:@"Enter an animal"]];
    [scenario addStep:[KIFTestStep stepToEnterText:@"Biscuit" intoViewWithAccessibilityLabel:@"Enter a snack"]];
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Submit" traits:UIAccessibilityTraitButton]];
    [scenario addStepsFromArray:[KIFTestStep stepsToWaitForViewWithAccessibilityLabel:@"All fields must be filled" dismissedByTappingViewWithAccessibilityLabel:@"OK"]];
    [scenario addStep:[KIFTestStep stepToEnterText:@"Lemon" intoViewWithAccessibilityLabel:@"Enter a fruit"]];
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Submit" traits:UIAccessibilityTraitButton]];
    
    // Check that the data we gave is used in the results screen
    [scenario addStep:[KIFTestStep stepToWaitForAbsenceOfViewWithAccessibilityLabel:@"Bob" traits:UIAccessibilityTraitStaticText]];
    [scenario addStep:[KIFTestStep stepToWaitForViewWithAccessibilityLabel:@"Results" traits:UIAccessibilityTraitStaticText]];
    [scenario addStep:[KIFTestStep stepToWaitForViewWithAccessibilityLabel:@"Fish" traits:UIAccessibilityTraitStaticText]];
    [scenario addStep:[KIFTestStep stepToWaitForViewWithAccessibilityLabel:@"Biscuit" traits:UIAccessibilityTraitStaticText]];
    [scenario addStep:[KIFTestStep stepToWaitForViewWithAccessibilityLabel:@"Lemon" traits:UIAccessibilityTraitStaticText]];
    
    // Dismiss the results screen
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Done" traits:UIAccessibilityTraitButton]];
    [scenario addStep:[KIFTestStep stepToWaitForAbsenceOfViewWithAccessibilityLabel:@"Results" traits:UIAccessibilityTraitStaticText]];
    [scenario addStep:[KIFTestStep stepToWaitForViewWithAccessibilityLabel:@"Form test" traits:UIAccessibilityTraitStaticText]];
    
    return scenario;
}

+ (KIFTestScenario *)scenarioFunctionalTestFormTriggers
{
    KIFTestScenario *scenario = [self scenarioWithDescription:@"Test that form triggers work"];
    [scenario addStep:[KIFTestStep stepToSetupWindowWithWorkflow:@"form_triggers_tests.xml"]];
    [scenario addStep:[KIFTestStep stepToWaitForViewWithAccessibilityLabel:@"Form triggers test" traits:UIAccessibilityTraitStaticText]];
    
    // check that the hidden subviews are hidden
    [scenario addStep:[KIFTestStep stepToWaitForAbsenceOfViewWithAccessibilityLabel:@"subthingA1"]];
    [scenario addStep:[KIFTestStep stepToWaitForAbsenceOfViewWithAccessibilityLabel:@"subthingA2"]];
    [scenario addStep:[KIFTestStep stepToWaitForAbsenceOfViewWithAccessibilityLabel:@"subthingB1"]];
    [scenario addStep:[KIFTestStep stepToWaitForAbsenceOfViewWithAccessibilityLabel:@"subthingB2"]];
    
    // Trigger the first trigger
    [scenario addStep:[KIFTestStep stepToEnterText:@"\bA\n" intoViewWithAccessibilityLabel:@"thing1" traits:UIAccessibilityTraitNone expectedResult:@"A"]];
    
    // check that the first set of subviews was shown, but the second remains hidden
    [scenario addStep:[KIFTestStep stepToWaitForViewWithAccessibilityLabel:@"subthingA1"]];
    [scenario addStep:[KIFTestStep stepToWaitForViewWithAccessibilityLabel:@"subthingA2"]];
    [scenario addStep:[KIFTestStep stepToWaitForAbsenceOfViewWithAccessibilityLabel:@"subthingB1"]];
    [scenario addStep:[KIFTestStep stepToWaitForAbsenceOfViewWithAccessibilityLabel:@"subthingB2"]];
    
    // Trigger the second trigger
    [scenario addStep:[KIFTestStep stepToEnterText:@"\bB\n" intoViewWithAccessibilityLabel:@"thing1" traits:UIAccessibilityTraitNone expectedResult:@"B"]];
    
    // check that the first set of subviews was hidden, and the second was shown
    [scenario addStep:[KIFTestStep stepToWaitForAbsenceOfViewWithAccessibilityLabel:@"subthingA1"]];
    [scenario addStep:[KIFTestStep stepToWaitForAbsenceOfViewWithAccessibilityLabel:@"subthingA2"]];
    [scenario addStep:[KIFTestStep stepToWaitForViewWithAccessibilityLabel:@"subthingB1"]];
    [scenario addStep:[KIFTestStep stepToWaitForViewWithAccessibilityLabel:@"subthingB2"]];
    
    // De-trigger them both
    [scenario addStep:[KIFTestStep stepToEnterText:@"\b\n" intoViewWithAccessibilityLabel:@"thing1" traits:UIAccessibilityTraitNone expectedResult:@""]];
    
    // check that the hidden subviews are hidden
    [scenario addStep:[KIFTestStep stepToWaitForAbsenceOfViewWithAccessibilityLabel:@"subthingA1"]];
    [scenario addStep:[KIFTestStep stepToWaitForAbsenceOfViewWithAccessibilityLabel:@"subthingA2"]];
    [scenario addStep:[KIFTestStep stepToWaitForAbsenceOfViewWithAccessibilityLabel:@"subthingB1"]];
    [scenario addStep:[KIFTestStep stepToWaitForAbsenceOfViewWithAccessibilityLabel:@"subthingB2"]];
    
    return scenario;
}

+ (KIFTestScenario *)scenarioFunctionalTestTables
{
    KIFTestScenario *scenario = [self scenarioWithDescription:@"Test that tables work"];
    [scenario addStep:[KIFTestStep stepToSetupWindowWithWorkflow:@"table_tests.xml"]];
    [scenario addStep:[KIFTestStep stepToWaitForViewWithAccessibilityLabel:@"Grouped" traits:UIAccessibilityTraitStaticText]];
    
    // Now check that everything deserialised as expected
    [scenario addStep:[KIFTestStep stepToExamineWindow:^KIFTestStepResult(UIWindow *window, NSError **outError) {
        
        WFSNavigationController *navigationController = (WFSNavigationController *)window.rootViewController;
        if (![navigationController isKindOfClass:[WFSNavigationController class]]) return NO;
        
        NSArray *controllers = navigationController.viewControllers;
        if (controllers.count != 1) return NO;
        
        WFSScreenController *firstController = controllers[0];
        if (![firstController isKindOfClass:[WFSScreenController class]]) return NO;
        
        NSArray *firstChildControllers = [firstController childViewControllers];
        if (firstChildControllers.count != 1) return NO;
        
        WFSTableController *firstTableController = firstChildControllers[0];
        if (![firstTableController isKindOfClass:[WFSTableController class]]) return NO;
        if (firstTableController.tableView.style != UITableViewStyleGrouped) return NO;
        
        return YES;
        
    }]];
    
    // Check that the first group is as we expect
    [scenario addStep:[KIFTestStep stepToWaitForViewWithAccessibilityLabel:@"Group 1" traits:UIAccessibilityTraitStaticText]];
    [scenario addStep:[KIFTestStep stepToWaitForViewWithAccessibilityLabel:@"text 1" traits:UIAccessibilityTraitStaticText]];
    [scenario addStep:[KIFTestStep stepToWaitForViewWithAccessibilityLabel:@"detailText 1" traits:UIAccessibilityTraitStaticText]];
    
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"text 1, detailText 1"]];
    [scenario addStepsFromArray:[KIFTestStep stepsToWaitForViewWithAccessibilityLabel:@"Alert 1" dismissedByTappingViewWithAccessibilityLabel:@"OK"]];
    
    [scenario addStep:[KIFTestStep stepToWaitForViewWithAccessibilityLabel:@"Group 2" traits:UIAccessibilityTraitStaticText]];
    [scenario addStep:[KIFTestStep stepToWaitForViewWithAccessibilityLabel:@"text 2a" traits:UIAccessibilityTraitStaticText]];
    [scenario addStep:[KIFTestStep stepToWaitForViewWithAccessibilityLabel:@"detailText 2a" traits:UIAccessibilityTraitStaticText]];
    [scenario addStep:[KIFTestStep stepToWaitForViewWithAccessibilityLabel:@"text 2b" traits:UIAccessibilityTraitStaticText]];
    [scenario addStep:[KIFTestStep stepToWaitForViewWithAccessibilityLabel:@"detailText 2b" traits:UIAccessibilityTraitStaticText]];
    
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"text 2a, detailText 2a"]];
    [scenario addStepsFromArray:[KIFTestStep stepsToWaitForViewWithAccessibilityLabel:@"Alert 2a" dismissedByTappingViewWithAccessibilityLabel:@"OK"]];    
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"text 2b, detailText 2b"]];
    [scenario addStepsFromArray:[KIFTestStep stepsToWaitForViewWithAccessibilityLabel:@"Alert 2b" dismissedByTappingViewWithAccessibilityLabel:@"OK"]];
    
    // now hit the disclosure button...
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"More info, text 2b, detailText 2b"]];
    [scenario addStep:[KIFTestStep stepToWaitForAbsenceOfViewWithAccessibilityLabel:@"Grouped" traits:UIAccessibilityTraitStaticText]];
    [scenario addStep:[KIFTestStep stepToWaitForViewWithAccessibilityLabel:@"Plain" traits:UIAccessibilityTraitStaticText]];
    
    // Now check that everything deserialised as expected
    [scenario addStep:[KIFTestStep stepToExamineWindow:^KIFTestStepResult(UIWindow *window, NSError **outError) {
        
        WFSNavigationController *navigationController = (WFSNavigationController *)window.rootViewController;
        if (![navigationController isKindOfClass:[WFSNavigationController class]]) return NO;
        
        NSArray *controllers = navigationController.viewControllers;
        if (controllers.count != 2) return NO;
        
        WFSScreenController *secondController = controllers[1];
        if (![secondController isKindOfClass:[WFSScreenController class]]) return NO;
        
        NSArray *secondChildControllers = [secondController childViewControllers];
        if (secondChildControllers.count != 1) return NO;
        
        WFSTableController *secondTableController = secondChildControllers[0];
        if (![secondTableController isKindOfClass:[WFSTableController class]]) return NO;
        if (secondTableController.tableView.style != UITableViewStylePlain) return NO;
        
        return YES;
        
    }]];
    
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Row 5"]];
    [scenario addStepsFromArray:[KIFTestStep stepsToWaitForViewWithAccessibilityLabel:@"Incorrect!" dismissedByTappingViewWithAccessibilityLabel:@"OK"]];
    
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Row 3"]];
    [scenario addStepsFromArray:[KIFTestStep stepsToWaitForViewWithAccessibilityLabel:@"Correct!" dismissedByTappingViewWithAccessibilityLabel:@"OK"]];
    
    
    return scenario;
}

+ (id)scenarioFunctionalTestLoading
{
    KIFTestScenario *scenario = [self scenarioWithDescription:@"Test that loading subschemas into navigation stacks works"];
    [scenario addStep:[KIFTestStep stepToSetupWindowWithWorkflow:@"load_tests_main.xml"]];

    // the first screen should already be loading
    [scenario addStep:[KIFTestStep stepToWaitForViewWithAccessibilityLabel:@"Loading..."]];
    [scenario addStep:[KIFTestStep stepToWaitForViewWithAccessibilityLabel:@"Screen 1 title"]];
    [scenario addStep:[KIFTestStep stepToWaitForViewWithAccessibilityLabel:@"Screen 1 contents"]];
    [scenario addStep:[KIFTestStep stepToWaitForAbsenceOfViewWithAccessibilityLabel:@"Loading..."]];
    
    // If we tap the second tab, the second screen should load
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Screen 2"]];
    [scenario addStep:[KIFTestStep stepToWaitForViewWithAccessibilityLabel:@"Loading..."]];
    [scenario addStep:[KIFTestStep stepToWaitForViewWithAccessibilityLabel:@"Screen 2 title"]];
    [scenario addStep:[KIFTestStep stepToWaitForViewWithAccessibilityLabel:@"Screen 2 contents"]];
    [scenario addStep:[KIFTestStep stepToWaitForAbsenceOfViewWithAccessibilityLabel:@"Loading..."]];
    
    // If we tap the third tab, the third screen should fail to load
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Screen 3"]];
    [scenario addStepsFromArray:[KIFTestStep stepsToWaitForViewWithAccessibilityLabel:@"Failed to load screen 3" dismissedByTappingViewWithAccessibilityLabel:@"OK"]];
    
    return scenario;
}

+ (id)scenarioFunctionalTestGestures
{
    KIFTestScenario *scenario = [self scenarioWithDescription:@"Test that gestures work"];
    [scenario addStep:[KIFTestStep stepToSetupWindowWithWorkflow:@"gesture_recognizer_tests.xml"]];
    
    // Two taps should trigger one alert...
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Test" value:nil traits:UIAccessibilityTraitNone numberOfTaps:2]];
    [scenario addStepsFromArray:[KIFTestStep stepsToWaitForViewWithAccessibilityLabel:@"2 taps" dismissedByTappingViewWithAccessibilityLabel:@"OK"]];
    
     // Three should trigger the other alert...
     [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Test" value:nil traits:UIAccessibilityTraitNone numberOfTaps:3]];
    [scenario addStepsFromArray:[KIFTestStep stepsToWaitForViewWithAccessibilityLabel:@"3 taps" dismissedByTappingViewWithAccessibilityLabel:@"OK"]];
    
    // The four gesture has been added after the others, so they'll fire first
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Test" value:nil traits:UIAccessibilityTraitNone numberOfTaps:4]];
    [scenario addStepsFromArray:[KIFTestStep stepsToWaitForViewWithAccessibilityLabel:@"3 taps" dismissedByTappingViewWithAccessibilityLabel:@"OK"]];
    
    // The long press should trigger its own alert, but only if the duration is exceeded
    [scenario addStep:[KIFTestStep stepToLongPressViewWithAccessibilityLabel:@"Test" duration:2.5]];
    [scenario addStepsFromArray:[KIFTestStep stepsToWaitForViewWithAccessibilityLabel:@"Long press" dismissedByTappingViewWithAccessibilityLabel:@"OK"]];
    [scenario addStep:[KIFTestStep stepToLongPressViewWithAccessibilityLabel:@"Test" duration:1.5]];
    [scenario addStep:[KIFTestStep stepToWaitForAbsenceOfViewWithAccessibilityLabel:@"Long press"]];
    
    // Left and right swipes should trigger alerts...
    [scenario addStep:[KIFTestStep stepToSwipeViewWithAccessibilityLabel:@"Test" inDirection:KIFSwipeDirectionLeft]];
    [scenario addStepsFromArray:[KIFTestStep stepsToWaitForViewWithAccessibilityLabel:@"Left swipe" dismissedByTappingViewWithAccessibilityLabel:@"OK"]];
    [scenario addStep:[KIFTestStep stepToSwipeViewWithAccessibilityLabel:@"Test" inDirection:KIFSwipeDirectionRight]];
    [scenario addStepsFromArray:[KIFTestStep stepsToWaitForViewWithAccessibilityLabel:@"Right swipe" dismissedByTappingViewWithAccessibilityLabel:@"OK"]];
    
    // Up shouldn't.
    [scenario addStep:[KIFTestStep stepToSwipeViewWithAccessibilityLabel:@"Test" inDirection:KIFSwipeDirectionUp]];
    [scenario addStep:[KIFTestStep stepToWaitForAbsenceOfViewWithAccessibilityLabel:@"Left swipe"]];
    [scenario addStep:[KIFTestStep stepToWaitForAbsenceOfViewWithAccessibilityLabel:@"Right swipe"]];
    
    return scenario;
}

+ (id)scenarioFunctionalTestStyles
{
    KIFTestScenario *scenario = [self scenarioWithDescription:@"Test that styles work"];
    [scenario addStep:[KIFTestStep stepToSetupWindowWithWorkflow:@"style_tests.xml"]];
    
    // Check that the labels have the styles we expect
    [scenario addStep:[KIFTestStep stepToExamineWindow:^KIFTestStepResult(UIWindow *window, NSError **outError) {
        
        WFSContainerView *container = (WFSContainerView *)[[(WFSScreenController *)window.rootViewController screenView] hostedView];
        WSTAssert([container isKindOfClass:[WFSContainerView class]]);
        
        NSArray *views = container.contentViews;
        WSTAssert(views.count == 3);
        
        WFSLabel *firstLabel = views[0];
        WSTAssert([firstLabel.textColor isEqual:[UIColor redColor]]);
        WSTAssert(firstLabel.font.pointSize == 24);
        
        WFSLabel *secondLabel = views[1];
        WSTAssert([secondLabel.textColor isEqual:[UIColor greenColor]]);
        WSTAssert([secondLabel.font.fontName hasSuffix:@"-Bold"]);
        
        WFSLabel *thirdLabel = views[2];
        WSTAssert([thirdLabel.textColor isEqual:[UIColor blueColor]]);
        WSTAssert([thirdLabel.font.fontName hasSuffix:@"-Italic"]);
        
        return KIFTestStepResultSuccess;
        
    }]];
    
    
    return scenario;
}

+ (id)scenarioFunctionalTestStoredValues
{
    KIFTestScenario *scenario = [self scenarioWithDescription:@"Test that variables work"];
    [scenario addStep:[KIFTestStep stepToSetupWindowWithWorkflow:@"stored_value_tests.xml"]];
    
    // Initially it should use the default
    [scenario addStep:[KIFTestStep stepToWaitForViewWithAccessibilityLabel:@"This goes at the top"]];
    [scenario addStep:[KIFTestStep stepToWaitForViewWithAccessibilityLabel:@"Push me!"]];
    [scenario addStep:[KIFTestStep stepToWaitForViewWithAccessibilityLabel:@"This goes at the bottom"]];
    
    // A simple replacement should work
    [scenario addStep:[KIFTestStep stepToSetupMessageType:@"scenarioFunctionalTestStoredValues" name:@"performNextStep" data:@{
                       
           @"sections" : @{
               @"cells" : @{
                   @"text" : @"Now push me!",
                   @"actionName" : @"performNextStep"
               }
           }
                       
    }]];
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Push me!"]];
    
    [scenario addStep:[KIFTestStep stepToWaitForViewWithAccessibilityLabel:@"This goes at the top"]];
    [scenario addStep:[KIFTestStep stepToWaitForAbsenceOfViewWithAccessibilityLabel:@"Push me!"]];
    [scenario addStep:[KIFTestStep stepToWaitForViewWithAccessibilityLabel:@"Now push me!"]];
    [scenario addStep:[KIFTestStep stepToWaitForViewWithAccessibilityLabel:@"This goes at the bottom"]];
    
    // An array of cell values should work
    [scenario addStep:[KIFTestStep stepToSetupMessageType:@"scenarioFunctionalTestStoredValues" name:@"performNextStep" data:@{
                       
            @"sections" : @{
                @"cells" : @[
                    @{
                        @"text" : @"Don't push me!",
                        @"actionName" : @"noSuchAction"
                    },
                    @{
                        @"text" : @"Push me instead!",
                        @"actionName" : @"performNextStep"
                    },
                ]
            }

    }]];
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Now push me!"]];
    
    [scenario addStep:[KIFTestStep stepToWaitForViewWithAccessibilityLabel:@"This goes at the top"]];
    [scenario addStep:[KIFTestStep stepToWaitForAbsenceOfViewWithAccessibilityLabel:@"Now push me!"]];
    [scenario addStep:[KIFTestStep stepToWaitForViewWithAccessibilityLabel:@"Don't push me!"]];
    [scenario addStep:[KIFTestStep stepToWaitForViewWithAccessibilityLabel:@"Push me instead!"]];
    [scenario addStep:[KIFTestStep stepToWaitForViewWithAccessibilityLabel:@"This goes at the bottom"]];
    
    // An array of section values should work too
    [scenario addStep:[KIFTestStep stepToSetupMessageType:@"scenarioFunctionalTestStoredValues" name:@"performNextStep" data:@{
                       
            @"sections" : @[
                @{
                    @"cells" : @{
                        @"text" : @"Not me!",
                        @"actionName" : @"noSuchAction"
                    },
                },
                @{
                    @"cells" : @[
                        @{
                            @"text" : @"Not me either!",
                            @"actionName" : @"noSuchAction"
                        },
                        @{
                            @"text" : @"Definitely not me!",
                            @"actionName" : @"noSuchAction"
                        },
                    ]
                },
            ]

    }]];
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Push me instead!"]];
    
    [scenario addStep:[KIFTestStep stepToWaitForViewWithAccessibilityLabel:@"This goes at the top"]];
    [scenario addStep:[KIFTestStep stepToWaitForAbsenceOfViewWithAccessibilityLabel:@"Don't push me!"]];
    [scenario addStep:[KIFTestStep stepToWaitForAbsenceOfViewWithAccessibilityLabel:@"Push me instead!"]];
    [scenario addStep:[KIFTestStep stepToWaitForViewWithAccessibilityLabel:@"Not me!"]];
    [scenario addStep:[KIFTestStep stepToWaitForViewWithAccessibilityLabel:@"Not me either!"]];
    [scenario addStep:[KIFTestStep stepToWaitForViewWithAccessibilityLabel:@"Definitely not me!"]];
    [scenario addStep:[KIFTestStep stepToWaitForViewWithAccessibilityLabel:@"This goes at the bottom"]];
    
    return scenario;
}

@end
