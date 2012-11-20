//
//  WFSSendMessageAction.h
//  WFSWorkflow
//
//  Created by Simon Booth on 16/10/2012.
//  Copyright (c) 2012 CRedit360. All rights reserved.
//

#import "WFSAction.h"

@interface WFSSendMessageAction : WFSAction

@property (nonatomic, strong) id message;

@property (nonatomic, strong) NSArray *actions;

@end
