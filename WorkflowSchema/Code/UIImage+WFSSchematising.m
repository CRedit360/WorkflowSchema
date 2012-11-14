//
//  UIImage+WFSSchematising.m
//  WorkflowSchema
//
//  Created by Simon Booth on 21/10/2012.
//  Copyright (c) 2012 CRedit360. All rights reserved.
//

#import "UIImage+WFSSchematising.h"
#import "WFSSchema+WFSGroupedParameters.h"
#import <objc/runtime.h>

@implementation UIImage (WFSSchematising)

- (id)initWithSchema:(WFSSchema *)schema context:(WFSContext *)context error:(NSError **)outError
{
    NSDictionary *groupedParameters = [schema groupedParametersWithContext:context error:outError];
    if (!groupedParameters) return nil;
    
    NSString *imageName = groupedParameters[@"imageName"];
    if (!imageName)
    {
        if (outError) *outError = WFSError(@"Images require a name");
        return nil;
    }
    
    self = [[self class] imageNamed:imageName];
    if (self)
    {
        WFS_SCHEMATISING_PROPERTY_INITITIALISATION;
    }
    else
    {
        if (outError) *outError = WFSError(@"Could not find image named '%@'", imageName);
        return nil;
    }
    return self;
}

+ (NSArray *)mandatorySchemaParameters
{
    return [[super mandatorySchemaParameters] arrayByPrependingObject:@"imageName" ];
}

+ (NSArray *)defaultSchemaParameters
{
    return [[super defaultSchemaParameters] arrayByPrependingObject:@[ [NSString class], @"imageName"] ];
}

+ (NSDictionary *)schemaParameterTypes
{
    return [[super schemaParameterTypes] dictionaryByAddingEntriesFromDictionary:@{ @"imageName" : [NSString class] }];
}

@end
