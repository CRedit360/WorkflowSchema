//
//  WFSMessage.h
//  WorkflowSchema
//
//  Created by Simon Booth on 29/10/2012.
//  Copyright (c) 2012 CRedit360. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WFSContext;
@class WFSResult;

typedef void(^WFSMessageResponseHandler)(WFSResult *result);

@interface WFSMessage : NSObject

@property (nonatomic, copy, readonly) NSString *target;
@property (nonatomic, copy, readonly) NSString *name;
@property (nonatomic, strong, readonly) WFSContext *context;
@property (nonatomic, copy, readonly) WFSMessageResponseHandler responseHandler;

- (id)initWithTarget:(NSString *)target name:(NSString *)name context:(WFSContext *)context responseHandler:(WFSMessageResponseHandler)responseHandler;
+ (WFSMessage *)messageWithTarget:(NSString *)target name:(NSString *)name context:(WFSContext *)context responseHandler:(WFSMessageResponseHandler)responseHandler;

- (void)respondWithResult:(WFSResult *)result;

@end
