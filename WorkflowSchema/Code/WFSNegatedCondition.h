//
//  WFSNegatedCondition.h
//  WorkflowSchema
//
//  Created by Simon Booth on 22/11/2012.
//  Copyright (c) 2012 CRedit360. All rights reserved.
//

#import "WFSCondition.h"

@interface WFSNegatedCondition : WFSCondition

@property (nonatomic, strong) WFSCondition *condition;

@end
