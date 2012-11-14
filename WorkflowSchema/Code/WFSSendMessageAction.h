//
//  WFSSendMessageAction.h
//  WFSWorkflow
//
//  Created by Simon Booth on 16/10/2012.
//  Copyright (c) 2012 CRedit360. All rights reserved.
//

#import "WFSAction.h"

@interface WFSSendMessageAction : WFSAction

@property (nonatomic, strong) NSString *messageName;
@property (nonatomic, strong) NSString *messageType;

@property (nonatomic, strong) NSArray *actions;

@end
