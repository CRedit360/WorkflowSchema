//
//  WFSToolbar.m
//  WorkflowSchema
//
//  Created by Simon Booth on 22/11/2012.
//  Copyright (c) 2012 CRedit360. All rights reserved.
//

#import "WFSToolbar.h"

@implementation WFSToolbar

+ (NSArray *)arraySchemaParameters
{
    return [[super arraySchemaParameters] arrayByPrependingObject:@"items"];
}

+ (NSArray *)defaultSchemaParameters
{
    return [[super defaultSchemaParameters] arrayByPrependingObject:@[ [UIBarButtonItem class], @"items"]];
}

+ (NSDictionary *)schemaParameterTypes
{
    return [[super schemaParameterTypes] dictionaryByAddingEntriesFromDictionary:@{
            
            @"items" : [UIBarButtonItem class]
            
    }];
}

@end
