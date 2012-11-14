//
//  WFSResult.m
//  WFSWorkflow
//
//  Created by Simon Booth on 16/10/2012.
//  Copyright (c) 2012 CRedit360. All rights reserved.
//

#import "WFSResult.h"

NSString * const WFSResultNameSuccess = @"success";
NSString * const WFSResultNameFailure = @"failure";

@implementation WFSResult

+ (WFSResult *)successResultWithContext:(WFSContext *)context
{
    return [self resultWithSuccess:YES name:WFSResultNameSuccess context:context];
}

+ (WFSResult *)failureResultWithContext:(WFSContext *)context
{
    return [self resultWithSuccess:NO name:WFSResultNameFailure context:context];
}

+ (WFSResult *)resultWithSuccess:(BOOL)success name:(NSString *)name context:(WFSContext *)context
{
    return [[self alloc] initWithSuccess:success name:name context:context];
}

- (id)initWithSuccess:(BOOL)success name:(NSString *)name context:(WFSContext *)context
{
    self = [super init];
    if (self)
    {
        _isSuccess = success;
        _name = [name copy];
        _context = context;
    }
    return self;
}

@end
