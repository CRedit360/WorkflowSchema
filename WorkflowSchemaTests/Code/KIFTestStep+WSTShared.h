//
//  KIFTestStep+WSTShared.h
//  WorkflowSchemaTests
//
//  Created by Simon Booth on 22/10/2012.
//  Copyright (c) 2012 CRedit360. All rights reserved.
//

#import "KIFTestStep.h"

@interface KIFTestStep (WSTShared)

+ (KIFTestStep *)stepToSetupWindowWithWorkflow:(NSString *)fileName;
+ (KIFTestStep *)stepToExamineWindow:(KIFTestStepResult(^)(UIWindow *window, NSError **outError))block;

+ (KIFTestStep *)stepToSetupMessageType:(NSString *)type name:(NSString *)name data:(NSDictionary *)data;

+ (KIFTestStep *)stepToWaitForAbsenceOfViewWithAccessibilityLabel:(NSString *)label zeroSizeIsAbsent:(BOOL)zeroSizeIsAbsent;
+ (NSArray *)stepsToWaitForViewWithAccessibilityLabel:(NSString *)waitLabel dismissedByTappingViewWithAccessibilityLabel:(NSString *)dismissLabel;

@end
