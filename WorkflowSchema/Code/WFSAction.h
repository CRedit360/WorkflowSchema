//
//  WFSAction.h
//  WFSWorkflow
//
//  Created by Simon Booth on 16/10/2012.
//  Copyright (c) 2012 CRedit360. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WFSSchematising.h"
#import "WFSResult.h"
#import "WFSMessage.h"

@interface WFSAction : NSObject <WFSSchematising>

- (BOOL)shouldPerformActionForResultName:(NSString *)name;
- (WFSResult *)performActionForController:(UIViewController *)controller context:(WFSContext *)context;

+ (BOOL)actionAnimationsAreDisabled;
+ (void)performWithActionAnimationsDisabled:(void(^)(void))block;

@end
