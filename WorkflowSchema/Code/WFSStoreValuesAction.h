//
//  WFSSetVariableAction.h
//  WorkflowSchema
//
//  Created by Simon Booth on 12/11/2012.
//  Copyright (c) 2012 CRedit360. All rights reserved.
//

#import <WorkflowSchema/WorkflowSchema.h>

@interface WFSStoreValuesAction : WFSAction

@property (nonatomic, strong) NSArray *name;    //Where to store the value
@property (nonatomic, strong) id value;         // The value to store
@property (nonatomic, strong) NSArray *keyPath; // Where to get the value in the context (if value is not set)


@end
