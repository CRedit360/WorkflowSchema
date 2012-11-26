//
//  WFSSetVariableAction.h
//  WorkflowSchema
//
//  Created by Simon Booth on 12/11/2012.
//  Copyright (c) 2012 CRedit360. All rights reserved.
//

#import "WFSAction.h"

@interface WFSStoreValueAction : WFSAction

@property (nonatomic, strong) NSString *name; // Where to store the value
@property (nonatomic, strong) id value;       // The value to store
@property (nonatomic, assign) BOOL transient; // If true, the value is only stored in the result's context. If false, it is also stored to the controller.

@end
