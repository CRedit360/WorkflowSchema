//
//  WFSToolbar.m
//  WorkflowSchema
//
//  Created by Simon Booth on 22/11/2012.
//  Copyright (c) 2012 CRedit360. All rights reserved.
//

#import "WFSToolbar.h"

@implementation WFSToolbar

- (id)initWithSchema:(WFSSchema *)schema context:(WFSContext *)context error:(NSError *__autoreleasing *)outError
{
    self = [super initWithSchema:schema context:context error:outError];
    [self sizeToFit];
    return self;
}

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
