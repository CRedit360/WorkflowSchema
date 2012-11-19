//
//  WFSConditionalAction.h
//  WorkflowSchema
//
//  Created by Simon Booth on 19/11/2012.
//  Copyright (c) 2012 CRedit360. All rights reserved.
//

#import "WFSAction.h"
#import "WFSCondition.h"

@interface WFSConditionalAction : WFSAction

@property (nonatomic, strong) WFSCondition *condition;
@property (nonatomic, strong) WFSAction *successAction;
@property (nonatomic, strong) WFSAction *failureAction;

@end
