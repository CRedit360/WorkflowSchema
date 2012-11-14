//
//  WFSFormTrigger.h
//  WorkflowSchema
//
//  Created by Simon Booth on 01/11/2012.
//  Copyright (c) 2012 CRedit360. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WFSFormController.h"
#import "WFSSchematising.h"
#import "WFSCondition.h"

@interface WFSFormTrigger : NSObject <WFSSchematising>

@property (nonatomic, strong) WFSCondition *condition;

@property (nonatomic, strong) NSString *successActionName;
@property (nonatomic, strong) NSArray *successTriggers;

@property (nonatomic, strong) NSString *failureActionName;
@property (nonatomic, strong) NSArray *failureTriggers;

- (void)fireWithContext:(WFSContext *)context;

@end
