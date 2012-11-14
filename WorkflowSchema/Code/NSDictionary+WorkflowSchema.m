//
//  NSDictionary+WorkflowSchema.m
//  WorkflowSchema
//
//  Created by Simon Booth on 23/10/2012.
//  Copyright (c) 2012 CRedit360. All rights reserved.
//

#import "NSDictionary+WorkflowSchema.h"

@implementation NSDictionary (WorkflowSchema)

- (NSDictionary *)dictionaryByAddingEntriesFromDictionary:(NSDictionary *)otherDictionary
{
    NSMutableDictionary *dictionary = [self mutableCopy];
    [dictionary addEntriesFromDictionary:otherDictionary];
    return dictionary;
}

@end
