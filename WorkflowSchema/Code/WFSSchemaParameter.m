//
//  WFSSchemaParameter.m
//  WFSWorkflow
//
//  Created by Simon Booth on 19/10/2012.
//  Copyright (c) 2012 CRedit360. All rights reserved.
//

#import "WFSSchemaParameter.h"
#import "WFSSchematising.h"

@implementation WFSSchemaParameter

- (id)initWithName:(NSString *)name
{
    return [self initWithName:name value:nil];
}

- (id)initWithName:(NSString *)name value:(id)value
{
    self = [super init];
    if (self)
    {
        _name = name;
        _value = value;
    }
    return self;
}

- (void)addValue:(id)value
{
    if (self.value)
    {
        self.value = [[self.value flattenedArray] arrayByAddingObject:value];
    }
    else self.value = value;
}

@end
