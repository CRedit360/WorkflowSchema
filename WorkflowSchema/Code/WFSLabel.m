//
//  RUILabel.m
//  RemoteUserInterface
//
//  Created by Simon Booth on 11/10/2012.
//  Copyright (c) 2012 CRedit360. All rights reserved.
//

#import "WFSLabel.h"

@implementation WFSLabel

- (id)initWithSchema:(WFSSchema *)schema context:(WFSContext *)context error:(NSError **)outError
{
    self = [super initWithSchema:schema context:context error:outError];
    if (self)
    {
        self.opaque = NO;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

+ (NSArray *)mandatorySchemaParameters
{
    return [[super mandatorySchemaParameters] arrayByPrependingObject:@"text"];
}

+ (NSArray *)defaultSchemaParameters
{
    return [[super defaultSchemaParameters] arrayByPrependingObject:@[[NSString class], @"text"]];
}

+ (NSDictionary *)schemaParameterTypes
{
    return [[super schemaParameterTypes] dictionaryByAddingEntriesFromDictionary:@{ @"text" : [NSString class] }];
}

@end
