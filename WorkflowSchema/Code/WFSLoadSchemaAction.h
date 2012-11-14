//
//  WFSShowWorkflowAction.h
//  WFSWorkflow
//
//  Created by Simon Booth on 16/10/2012.
//  Copyright (c) 2012 CRedit360. All rights reserved.
//

#import "WFSAction.h"

extern NSString * const WFSLoadSchemaActionMessageType; // Tells the message delegate to load a 
extern NSString * const WFSLoadSchemaActionSchemaKey;

@interface WFSLoadSchemaAction : WFSAction

@property (nonatomic, strong) NSString *path;

@property (nonatomic, strong) WFSAction *successAction;
@property (nonatomic, strong) WFSAction *failureAction;

@end
