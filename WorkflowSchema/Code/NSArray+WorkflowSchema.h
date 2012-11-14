//
//  NSArray+WorkflowSchema.h
//  WorkflowSchema
//
//  Created by Simon Booth on 26/10/2012.
//  Copyright (c) 2012 CRedit360. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (WorkflowSchema)

- (NSArray *)flattenedArray;

- (NSArray *)arrayByPrependingObject:(id)object;
- (NSArray *)arrayByPrependingObjectsFromArray:(NSArray *)array;

- (NSNumber *)bitmaskByLookupInDictionary:(NSDictionary *)dictionary;

@end
