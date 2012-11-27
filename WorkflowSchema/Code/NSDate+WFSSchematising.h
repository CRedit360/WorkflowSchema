//
//  NSDate+WFSSchematising.h
//  WorkflowSchema
//
//  Created by Simon Booth on 27/11/2012.
//  Copyright (c) 2012 CRedit360. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WFSSchematising.h"

@interface NSDate (WFSSchematising)

+ (NSDate *)dateWithString:(NSString *)string format:(NSString *)format locale:(NSLocale *)locale error:(NSError **)outError;

@end
