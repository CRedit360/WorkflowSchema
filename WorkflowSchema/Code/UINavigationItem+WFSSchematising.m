//
//  UINavigationItem+WFSSchematising.m
//  WorkflowSchema
//
//  Created by Simon Booth on 27/11/2012.
//  Copyright (c) 2012 CRedit360. All rights reserved.
//

#import "UINavigationItem+WFSSchematising.h"
#import "WFSBarButtonItem.h"

@implementation UINavigationItem (WFSSchematising)

+ (NSArray *)arraySchemaParameters
{
    return [[super arraySchemaParameters] arrayByAddingObjectsFromArray:@[ @"leftBarButtonItems", @"rightBarButtonItems" ]];
}

+ (NSDictionary *)schemaParameterTypes
{
    return [[super schemaParameterTypes] dictionaryByAddingEntriesFromDictionary:@{
            
            @"title"                         : [NSString class],
            @"titleView"                     : [UIView class],
            @"prompt"                        : [NSString class],
            @"hidesBackButton"               : @[ [NSString class], [NSNumber class] ],
            @"leftItemsSupplementBackButton" : @[ [NSString class], [NSNumber class] ],
            @"leftBarButtonItem"             : [WFSBarButtonItem class],
            @"leftBarButtonItems"            : [WFSBarButtonItem class],
            @"rightBarButtonItem"            : [WFSBarButtonItem class],
            @"rightBarButtonItems"           : [WFSBarButtonItem class],
            @"backBarButtonItem"             : @[ [NSString class], [UIImage class], [WFSBarButtonItem class] ]
            
    }];
}

- (BOOL)setSchemaParameterWithName:(NSString *)name value:(id)value context:(WFSContext *)context error:(NSError **)outError
{
    // since the backBarButtonItem is more-or-less ignored except for the title/image, we include these shorthands
    if ([name isEqualToString:@"backBarButtonItem"] && [value isKindOfClass:[NSString class]])
    {
        self.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:value style:UIBarButtonItemStyleBordered target:nil action:nil];
        return YES;
    }
    else if ([name isEqualToString:@"backBarButtonItem"] && [value isKindOfClass:[UIImage class]])
    {
        self.backBarButtonItem = [[UIBarButtonItem alloc] initWithImage:value style:UIBarButtonItemStyleBordered target:nil action:nil];
        return YES;
    }
    
    return [super setSchemaParameterWithName:name value:value context:context error:outError];
}

@end
