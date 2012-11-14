//
//  NSArray+WorkflowSchema.m
//  WorkflowSchema
//
//  Created by Simon Booth on 26/10/2012.
//  Copyright (c) 2012 CRedit360. All rights reserved.
//

#import "NSArray+WorkflowSchema.h"
#import "NSObject+WFSSchematising.h"

@implementation NSArray (WorkflowSchema)

- (NSArray *)flattenedArray
{
    NSMutableArray *flattenedArray = [NSMutableArray array];
    
    for (id value in self)
    {
        if ([value isKindOfClass:[NSArray class]])
        {
            [flattenedArray addObjectsFromArray:[value flattenedArray]];
        }
        else
        {
            [flattenedArray addObject:value];
        }
    }
    
    return flattenedArray;
}

- (NSArray *)arrayByPrependingObject:(id)object
{
    return [@[ object ] arrayByAddingObjectsFromArray:self];
}

- (NSArray *)arrayByPrependingObjectsFromArray:(NSArray *)array
{
    return [array arrayByAddingObjectsFromArray:self];
}

- (NSNumber *)bitmaskByLookupInDictionary:(NSDictionary *)dictionary
{
    long long value = 0;
    
    for (id object in self)
    {
        NSNumber *objectValue = dictionary[object];
        if (![objectValue isKindOfClass:[NSNumber class]]) return nil;
        value |= [objectValue longLongValue];
    }
    
    return @(value);
}

@end
