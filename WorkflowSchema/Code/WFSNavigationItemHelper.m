//
//  WFSNavigationItem.m
//  WFSWorkflow
//
//  Created by Simon Booth on 17/10/2012.
//  Copyright (c) 2012 CRedit360. All rights reserved.
//

#import "WFSNavigationItemHelper.h"
#import "WFSNavigationItem.h"
#import "WFSBarButtonItem.h"

@implementation WFSNavigationItemHelper

- (id)initWithNavigationItem:(UINavigationItem *)navigationItem
{
    self = [super init];    
    if (self)
    {
        _navigationItem = navigationItem;
    }
    return self;
}

- (BOOL)setupNavigationItemForSchema:(WFSSchema *)schema context:(WFSContext *)context value:(WFSSchema *)subSchema error:(NSError *__autoreleasing *)outError
{   
    return [self setParametersForSchema:schema context:context error:outError];
}

+ (NSArray *)arraySchemaParameters
{
    return @[ @"leftBarButtonItems", @"rightBarButtonItems" ];
}

+ (NSDictionary *)schemaParameterTypes
{
    return @{
    
    @"title" : [NSString class],
    @"prompt" : [NSString class],
    @"hidesBackButton" : [NSString class],
    @"hidesBackButton" : @[ [NSString class], [NSNumber class] ],
    @"leftItemsSupplementBackButton": @[ [NSString class], [NSNumber class] ],
    @"leftBarButtonItem" : [WFSBarButtonItem class],
    @"leftBarButtonItems" : [WFSBarButtonItem class],
    @"rightBarButtonItem" : [WFSBarButtonItem class],
    @"rightBarButtonItems" : [WFSBarButtonItem class],
    @"backBarButtonItem" : @[ [NSString class], [UIImage class], [WFSBarButtonItem class] ]
    
    };
}

- (BOOL)setSchemaParameterWithName:(NSString *)name value:(id)value context:(WFSContext *)context error:(NSError **)outError
{
    // since the backBarButtonItem is more-or-less ignored except for the title/image, we include these shorthands
    if ([name isEqualToString:@"backBarButtonItem"] && [value isKindOfClass:[NSString class]])
    {
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:value style:UIBarButtonItemStyleBordered target:nil action:nil];
        return YES;
    }
    else if ([name isEqualToString:@"backBarButtonItem"] && [value isKindOfClass:[UIImage class]])
    {
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithImage:value style:UIBarButtonItemStyleBordered target:nil action:nil];
        return YES;
    }
    else
    {
        if ([self.navigationItem validateValue:&value forKeyPath:name error:outError])
        {
            [self.navigationItem setValue:value forKeyPath:name];
            return YES;
        }
        
        return NO;
    }

    return NO;
}

@end
