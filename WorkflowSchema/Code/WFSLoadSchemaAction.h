//
//  WFSShowWorkflowAction.h
//  WFSWorkflow
//
//  Created by Simon Booth on 16/10/2012.
//  Copyright (c) 2012 CRedit360. All rights reserved.
//

#import "WFSAction.h"

extern NSString * const WFSLoadSchemaActionMessageName; // Tells the message delegate to load a schema

extern NSString * const WFSLoadSchemaActionPathKey;   // The path will be contained in this key
extern NSString * const WFSLoadSchemaActionSchemaKey; // The schema should be returned in this key

@interface WFSLoadSchemaAction : WFSAction

@property (nonatomic, strong) NSString *path;

@property (nonatomic, strong) WFSAction *successAction;
@property (nonatomic, strong) WFSAction *failureAction;

@end
