//
//  WFSControllerAction.h
//  WorkflowSchema
//
//  Created by Simon Booth on 21/10/2012.
//  Copyright (c) 2012 CRedit360. All rights reserved.
//

#import "WFSAction.h"

@interface WFSControllerAction : WFSAction

@property (nonatomic, strong) id controller;

- (WFSResult *)showController:(UIViewController *)controller forController:(UIViewController *)controller context:(WFSContext *)context;

@end
