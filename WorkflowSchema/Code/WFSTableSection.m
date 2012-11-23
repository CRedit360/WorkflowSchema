//
//  WFSTableSection.m
//  WFSWorkflow
//
//  Created by Simon Booth on 17/10/2012.
//  Copyright (c) 2012 CRedit360. All rights reserved.
//

#import "WFSTableSection.h"
#import "WFSTableCell.h"

@interface WFSTableSection ()

@property (nonatomic, strong, readwrite) NSString *headerTitle;
@property (nonatomic, strong, readwrite) NSArray *cells;
@property (nonatomic, strong, readwrite) NSString *footerTitle;

@end

@implementation WFSTableSection

+ (NSArray *)arraySchemaParameters
{
    return [[super arraySchemaParameters] arrayByPrependingObject:@"cells"];
}

+ (NSArray *)defaultSchemaParameters
{
    return [[super defaultSchemaParameters] arrayByPrependingObjectsFromArray:@[ @[ [NSString class], @"headerTitle" ], @[ [UITableViewCell class], @"cells" ] ]];
}

+ (NSDictionary *)schemaParameterTypes
{
    return [[super schemaParameterTypes] dictionaryByAddingEntriesFromDictionary:@{ @"headerTitle" : [NSString class], @"footerTitle" : [NSString class], @"cells" : [UITableViewCell class] }];
}

@end
