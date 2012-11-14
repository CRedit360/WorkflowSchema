//
//  WFSResult.h
//  WFSWorkflow
//
//  Created by Simon Booth on 16/10/2012.
//  Copyright (c) 2012 CRedit360. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WFSContext.h"

extern NSString * const WFSResultNameSuccess;
extern NSString * const WFSResultNameFailure;

@interface WFSResult : NSObject

+ (WFSResult *)successResultWithContext:(WFSContext *)context;
+ (WFSResult *)failureResultWithContext:(WFSContext *)context;

+ (WFSResult *)resultWithSuccess:(BOOL)success name:(NSString *)name context:(WFSContext *)context;
- (id)initWithSuccess:(BOOL)success name:(NSString *)name context:(WFSContext *)context;

@property (nonatomic, assign, readonly) BOOL isSuccess;
@property (nonatomic, copy, readonly) NSString *name;
@property (nonatomic, strong, readonly) WFSContext *context;

@end
