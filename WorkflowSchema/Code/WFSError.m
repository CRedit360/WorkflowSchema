//
//  WFSError.m
//  WFSWorkflow
//
//  Created by Simon Booth on 17/10/2012.
//  Copyright (c) 2012 CRedit360. All rights reserved.
//

#import "WFSError.h"

NSString * const WFSErrorDomain = @"com.credit360.WFSErrorDomain";

NSString * const WFSErrorSelectorKey = @"selector";
NSString * const WFSErrorClassKey = @"class";
NSString * const WFSErrorFileNameKey = @"fileName";
NSString * const WFSErrorLineNumberKey = @"lineNumber";
NSString * const WFSErrorCallStackKey = @"callStack";
NSString * const WFSErrorExceptionKey = @"exception";
NSString * const WFSErrorDescriptionKey = @"description";

@implementation WFSError

+ (WFSError *)errorWithInfo:(NSDictionary *)userInfo
{
    return [self errorWithDomain:WFSErrorDomain code:0 userInfo:userInfo];
}

- (NSString *)localizedDescription
{
    return self.userInfo[WFSErrorDescriptionKey];
}

- (NSString *)localizedFailureReason
{
    return self.userInfo[WFSErrorDescriptionKey];
}

@end
