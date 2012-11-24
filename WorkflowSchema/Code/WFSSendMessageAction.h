//
//  WFSSendMessageAction.h
//  WFSWorkflow
//
//  Created by Simon Booth on 16/10/2012.
//  Copyright (c) 2012 CRedit360. All rights reserved.
//

#import "WFSAction.h"

@interface WFSSendMessageAction : WFSAction

@property (nonatomic, strong) id message; // The message to send

@property (nonatomic, strong) NSArray *actions;    // Actions to perform based on the response to the message
@property (nonatomic, strong) NSArray *valueNames; // If set, the message context will be restricted to the keys with matching names

@end
