//
//  WFSMultipleCondition.h
//  WorkflowSchema
//
//  Created by Simon Booth on 01/11/2012.
//  Copyright (c) 2012 CRedit360. All rights reserved.
//

#import <WorkflowSchema/WorkflowSchema.h>

typedef enum {
    
    WFSMultipleConditionAll,
    WFSMultipleConditionAny,
    WFSMultipleConditionNone
    
} WFSMultipleConditionRequirement;

@interface WFSMultipleCondition : WFSCondition

@property (nonatomic, assign) WFSMultipleConditionRequirement requirement;
@property (nonatomic, strong) NSArray *conditions;

@end
