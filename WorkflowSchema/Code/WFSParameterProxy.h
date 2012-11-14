//
//  WFSProxySchema.h
//  WorkflowSchema
//
//  Created by Simon Booth on 21/10/2012.
//  Copyright (c) 2012 CRedit360. All rights reserved.
//

#import <WorkflowSchema/WorkflowSchema.h>

@interface WFSParameterProxy : WFSMutableSchema

@property (nonatomic, strong, readonly) NSString *parameterKeyPath;

@end
