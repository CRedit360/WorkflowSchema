//
//  WFSSegment.m
//  WorkflowSchema
//
//  Created by Simon Booth on 27/11/2012.
//  Copyright (c) 2012 CRedit360. All rights reserved.
//

#import "WFSSegment.h"
#import "WFSMessage.h"

@implementation WFSSegment

- (id)initWithSchema:(WFSSchema *)schema context:(WFSContext *)context error:(NSError **)outError
{
    self = [super initWithSchema:schema context:context error:outError];
    if (self)
    {
        if ((self.title.length == 0) && (self.image.accessibilityLabel.length == 0))
        {
            if (outError) *outError = WFSError(@"Segments must have a title or an accessibilityLabel");
            return nil;
        }
        
        _enabled = YES;
    }
    return self;
}

+ (NSArray *)defaultSchemaParameters
{
    return [[super defaultSchemaParameters] arrayByPrependingObjectsFromArray:@[
            
            @[ [NSString class], @"title" ],
            @[ [UIImage class], @"image" ],
            @[ [WFSMessage class], @"message" ]
            
    ]];
}

+ (NSArray *)lazilyCreatedSchemaParameters
{
    return [[super lazilyCreatedSchemaParameters] arrayByAddingObject:@"message"];
}

+ (NSDictionary *)schemaParameterTypes
{
    return [[super schemaParameterTypes] dictionaryByAddingEntriesFromDictionary:@{
            
            @"title"   : [NSString class],
            @"image"   : [UIImage class],
            @"message" : @[ [WFSMessage class], [NSString class] ],
            @"enabled" : @[ [NSString class], [NSNumber class] ]
            
    }];
}


@end
