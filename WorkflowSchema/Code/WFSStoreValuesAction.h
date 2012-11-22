//
//  WFSSetVariableAction.h
//  WorkflowSchema
//
//  Created by Simon Booth on 12/11/2012.
//  Copyright (c) 2012 CRedit360. All rights reserved.
//

#import <WorkflowSchema/WorkflowSchema.h>

@interface WFSStoreValuesAction : WFSAction

@property (nonatomic, strong) NSArray *keyName;
@property (nonatomic, strong) NSArray *keyPath;
@property (nonatomic, strong) id value;

@end
