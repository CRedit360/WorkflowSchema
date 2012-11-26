//
//  WFSComparisonCondition.h
//  WorkflowSchema
//
//  Created by Simon Booth on 26/11/2012.
//  Copyright (c) 2012 CRedit360. All rights reserved.
//

#import <WorkflowSchema/WorkflowSchema.h>

typedef enum {
    WFSStrictlyLessThan,
    WFSLessThanOrEqual,
    WFSGreaterThanOrEqual,
    WFSStrictlyGreaterThan
} WFSComparisonType;

@interface WFSComparisonCondition : WFSCondition

@property (nonatomic, assign) WFSComparisonType comparisonType;
@property (nonatomic, strong) id otherValue;

@end
