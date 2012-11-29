//
//  NSAttributedString+WFSSchematising.m
//  WorkflowSchema+DTCoreText
//
//  Created by Simon Booth on 28/11/2012.
//  Copyright (c) 2012 CRedit360. All rights reserved.
//

#import "NSAttributedString+WFSSchematising.h"
#import <WorkflowSchema/WFSSchema+WFSGroupedParameters.h>

@implementation NSAttributedString (WFSSchematising)

- (id)initWithSchema:(WFSSchema *)schema context:(WFSContext *)context error:(NSError **)outError
{
    NSDictionary *groupedParameters = [schema groupedParametersWithContext:context error:outError];
    id value = [groupedParameters objectForKey:@"value"];
    
    if ([value isKindOfClass:[NSString class]])
    {
        value = [value dataUsingEncoding:NSUTF8StringEncoding];
    }
    
    if ([value isKindOfClass:[NSData class]])
    {
        value = [[NSAttributedString alloc] initWithHTMLData:value documentAttributes:nil];
    }
    
    if ([value isKindOfClass:[NSAttributedString class]])
    {
        self = value;
    }

    if (self)
    {
        WFS_SCHEMATISING_INITIALISATION;
    }
    return self;
}

+ (NSArray *)mandatorySchemaParameters
{
    return [[super mandatorySchemaParameters] arrayByAddingObject:@"value"];
}

+ (NSArray *)defaultSchemaParameters
{
    return [[super mandatorySchemaParameters] arrayByPrependingObjectsFromArray:@[
            
            @[ [NSAttributedString class], @"value" ],
            @[ [NSString class], @"value" ],
            @[ [NSData class], @"value" ],
            
    ]];
}

+ (NSDictionary *)schemaParameterTypes
{
    return [[super schemaParameterTypes] dictionaryByAddingEntriesFromDictionary:@{
            
            @"value" : @[ [NSAttributedString class], [NSString class], [NSData class] ]
            
    }];
}

- (BOOL)setSchemaParameterWithName:(NSString *)name value:(id)value context:(WFSContext *)context error:(NSError **)outError
{
    if ([name isEqualToString:@"value"]) return YES;
    return [super setSchemaParameterWithName:name value:value context:context error:outError];
}

@end
