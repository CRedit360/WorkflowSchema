//
//  WSTAppDelegate.h
//  WorkflowSchemaTests
//
//  Created by Simon Booth on 22/10/2012.
//  Copyright (c) 2012 CRedit360. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WSTAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
- (void)setupWindowWithWorkflowFile:(NSString *)fileName;

@property (strong, nonatomic) NSDictionary *messageData; // keys are message types; values should also be dictionaries with keys being message names; values should also be dictionaries to be returned as response parameters

@end
