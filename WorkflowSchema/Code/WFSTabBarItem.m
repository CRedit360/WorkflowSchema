//
//  WFSTabBarItem.m
//  WFSWorkflow
//
//  Created by Simon Booth on 17/10/2012.
//  Copyright (c) 2012 CRedit360. All rights reserved.
//

#import "WFSTabBarItem.h"
#import "WFSSchema+WFSGroupedParameters.h"

@implementation WFSTabBarItem

- (id)initWithSchema:(WFSSchema *)schema context:(WFSContext *)context error:(NSError **)outError
{
    NSDictionary *groupedParameters = [schema groupedParametersWithContext:context error:outError];
    if (!groupedParameters) return nil;
    
    NSString *title = groupedParameters[@"title"];
    UIImage *image = groupedParameters[@"image"];
    
    self = [super initWithTitle:title image:image tag:0];
    if (self)
    {
        WFS_SCHEMATISING_INITIALISATION
    }
    return self;
}

+ (NSArray *)mandatorySchemaParameters
{
    return [[super mandatorySchemaParameters] arrayByPrependingObjectsFromArray:@[ @"title", @"image" ]];
}

+ (NSDictionary *)schemaParameterTypes
{
    return [[super schemaParameterTypes] dictionaryByAddingEntriesFromDictionary:@{ @"image" : [UIImage class], @"title" : [NSString class], @"badgeValue" : [NSString class] }];
}

- (BOOL)setSchemaParameterWithName:(NSString *)name value:(id)value context:(WFSContext *)context error:(NSError *__autoreleasing *)outError
{
    if ([@[ @"image", @"title" ] containsObject:name])
    {
        // we had to deal with these in advance
        return YES;
    }
    
    return [super setSchemaParameterWithName:name value:value context:context error:outError];
}

@end
