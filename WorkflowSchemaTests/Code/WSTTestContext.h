//
//  WSTTestContext.h
//  WorkflowSchemaTests
//
//  Created by Simon Booth on 29/10/2012.
//  Copyright (c) 2012 CRedit360. All rights reserved.
//

#import <WorkflowSchema/WorkflowSchema.h>

@interface WSTTestContext : WFSMutableContext

@property (nonatomic, strong) NSArray *errors;
@property (nonatomic, strong) NSArray *messages;
@property (nonatomic, strong) WFSResult *messageResult;

@end
