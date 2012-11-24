//
//  NSString+WFSSchematising.h
//  WorkflowSchema
//
//  Created by Simon Booth on 20/10/2012.
//  Copyright (c) 2012 CRedit360. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WFSSchematising.h"

@interface NSString (WFSSchematising) <WFSSchematising>

// Due to a bug in KVC, bool parameters are interpreted as char instead of as bools.
// NSString doesn't define charValue, so it blows up. To prevent this, we forward
// charValue to boolValue.
- (char)charValue;

// On iOS 5, KVC attempts to call this, even though it's not defined on NSString.
- (NSUInteger)unsignedIntValue;

@end
