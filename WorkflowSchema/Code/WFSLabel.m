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
        self.numberOfLines = 0;
    }
    return self;
}

+ (NSArray *)defaultSchemaParameters
{
    return [[super defaultSchemaParameters] arrayByPrependingObject:@[[NSString class], @"text"]];
}

+ (NSDictionary *)schemaParameterTypes
{
    return [[super schemaParameterTypes] dictionaryByAddingEntriesFromDictionary:@{
    
            @"adjustsFontSizeToFitWidth" : @[ [NSString class], [NSNumber class] ],
            @"numberOfLines"             : @[ [NSString class], [NSNumber class] ],
            @"text"                      : [NSString class]
            
    }];
}

@end
