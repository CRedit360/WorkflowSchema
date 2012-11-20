//
//  WFSButtonItem.m
//  WorkflowSchema
//
//  Created by Simon Booth on 21/10/2012.
//  Copyright (c) 2012 CRedit360. All rights reserved.
//

#import "WFSActionButtonItem.h"
#import "WFSMacros.h"

@implementation WFSActionButtonItem

- (id)initWithSchema:(WFSSchema *)schema context:(WFSContext *)context error:(NSError **)outError
{
    self = [super init];
    if (self)
    {
        _index = NSNotFound;
        
        WFS_SCHEMATISING_INITIALISATION
    }
    return self;
}

+ (NSArray *)mandatorySchemaParameters
{
    return [[super mandatorySchemaParameters] arrayByPrependingObjectsFromArray:@[ @"title", @"message" ]];
}

+ (NSArray *)lazilyCreatedSchemaParameters
{
    return [[super lazilyCreatedSchemaParameters] arrayByPrependingObject:@"message"];
}

+ (NSArray *)defaultSchemaParameters
{
    return [[super defaultSchemaParameters] arrayByPrependingObjectsFromArray:@[
            
            @[ [NSString class], @"title"],
            @[ [WFSMessage class], @"message" ]
            
    ]];
}

+ (NSDictionary *)schemaParameterTypes
{
    return [[super schemaParameterTypes] dictionaryByAddingEntriesFromDictionary:@{
            
            @"title" : [NSString class],
            @"message" : @[ [WFSMessage class], [NSString class] ]
            
    }];
}

@end

@implementation WFSCancelButtonItem

- (id)initWithSchema:(WFSSchema *)schema context:(WFSContext *)context error:(NSError **)outError
{
    self = [super initWithSchema:schema context:context error:outError];
    if (self)
    {
        if (self.title.length == 0)
        {
            self.title = WFSLocalizedString(@"WFSCancelButtonItem.title", @"OK");
        }
    }
    return self;
}

+ (NSArray *)mandatorySchemaParameters
{
    NSMutableArray *mandatorySchemaParameters = [[super mandatorySchemaParameters] mutableCopy];
    [mandatorySchemaParameters removeObject:@"title"];
    [mandatorySchemaParameters removeObject:@"message"];
    return mandatorySchemaParameters;
}

@end

@implementation WFSDestructiveButtonItem; @end
