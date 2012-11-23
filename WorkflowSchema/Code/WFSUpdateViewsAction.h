//
//  WFSUpdateViewsAction.h
//  WorkflowSchema
//
//  Created by Simon Booth on 22/11/2012.
//  Copyright (c) 2012 CRedit360. All rights reserved.
//

#import "WFSViewsAction.h"

@interface WFSUpdateViewsAction : WFSViewsAction

@property (nonatomic, copy) NSString *parameterName;
@property (nonatomic, copy) id value;

@end
