//
//  WFSImageView.m
//  WorkflowSchema
//
//  Created by Simon Booth on 20/10/2012.
//  Copyright (c) 2012 CRedit360. All rights reserved.
//

#import "WFSImageView.h"

@implementation WFSImageView

- (id)initWithSchema:(WFSSchema *)schema context:(WFSContext *)context error:(NSError **)outError
{
    self = [super init];
    if (self) {
        WFS_SCHEMATISING_INITIALISATION
        
        if (!self.image)
        {
            if (outError) *outError = WFSError(@"Image views must have an image");
            return nil;
        }
    }
    return self;
}

+ (NSArray *)defaultSchemaParameters
{
    return [[super defaultSchemaParameters] arrayByPrependingObjectsFromArray:@[ @[ [NSString class], @"imageName" ], @[ [UIImage class], @"image" ] ]];
}

+ (NSDictionary *)schemaParameterTypes
{
    return [[super schemaParameterTypes] dictionaryByAddingEntriesFromDictionary:@{ @"imageName" : [NSString class], @"image" : [UIImage class] }];
}

- (BOOL)setSchemaParameterWithName:(NSString *)name value:(id)value context:(WFSContext *)context error:(NSError *__autoreleasing *)outError
{
    if ([name isEqualToString:@"imageName"])
    {
        UIImage *image = [UIImage imageNamed:value];
        if (!image)
        {
            if (outError) *outError = WFSError(@"Cannot find image named %@", value);
            return NO;
        }
        
        return [super setSchemaParameterWithName:@"image" value:image context:context error:outError];
    }
    
    return [super setSchemaParameterWithName:name value:value context:context error:outError];
}

@end
