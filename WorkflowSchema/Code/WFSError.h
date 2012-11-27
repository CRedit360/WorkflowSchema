//
//  WFSError.h
//  WFSWorkflow
//
//  Created by Simon Booth on 17/10/2012.
//  Copyright (c) 2012 CRedit360. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WFSSchema;
@class WFSContext;

extern NSString * const WFSErrorDomain;
extern NSString * const WFSErrorCodeError;
extern NSString * const WFSErrorCodeException;

extern NSString * const WFSErrorSelectorKey;
extern NSString * const WFSErrorClassKey;
extern NSString * const WFSErrorFileNameKey;
extern NSString * const WFSErrorLineNumberKey;
extern NSString * const WFSErrorCallStackKey;
extern NSString * const WFSErrorExceptionKey;
extern NSString * const WFSErrorDescriptionKey;

#define WFSError(X, args...) [WFSError errorWithInfo:@{ \
WFSErrorSelectorKey:NSStringFromSelector(_cmd), \
WFSErrorClassKey:(self ? NSStringFromClass([self class]) : [NSNull null]), \
WFSErrorFileNameKey:[[NSString stringWithUTF8String:__FILE__] lastPathComponent], \
WFSErrorLineNumberKey:[NSNumber numberWithInt:__LINE__], \
WFSErrorCallStackKey:[NSThread callStackSymbols], \
WFSErrorDescriptionKey:[NSString stringWithFormat:X, ##args] }]

#define WFSErrorFromException(E)  [WFSError errorWithInfo:@{ \
WFSErrorExceptionKey:E, \
WFSErrorCallStackKey:[E callStackSymbols], \
WFSErrorDescriptionKey:[NSString stringWithFormat:@"Exception %@: %@", E.name, E.reason] }]

@interface WFSError : NSError

+ (WFSError *)errorWithInfo:(NSDictionary *)userInfo;

@end
