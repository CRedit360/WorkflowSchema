//
//  WFSNavigationController.m
//  WFSWorkflow
//
//  Created by Simon Booth on 15/10/2012.
//  Copyright (c) 2012 CRedit360. All rights reserved.
//

#import "WFSNavigationController.h"
#import "UIViewController+WFSSchematising.h"
#import "WFSAction.h"

@interface WFSNavigationController ()

@end

@implementation WFSNavigationController

+ (NSArray *)mandatorySchemaParameters
{
    return [[super mandatorySchemaParameters] arrayByAddingObjectsFromArray:@[ @"viewControllers" ]];
}

+ (NSArray *)arraySchemaParameters
{
    return [[super arraySchemaParameters] arrayByAddingObjectsFromArray:@[ @"viewControllers" ]];
}

+ (NSArray *)defaultSchemaParameters
{
    return [[super defaultSchemaParameters] arrayByPrependingObjectsFromArray:@[
    
    @[ [UIViewController class], @"viewControllers" ]
    
    ]];
}

+ (NSDictionary *)schemaParameterTypes
{
    return [[super schemaParameterTypes] dictionaryByAddingEntriesFromDictionary:@{
    
            @"viewControllers"     : [UIViewController class],
            @"navigationBarHidden" : @[ [NSString class], [NSNumber class] ],
            @"toolbarHidden"       : @[ [NSString class], [NSNumber class] ]
            
    }];
}

#pragma mark - Actions

WFS_UIVIEWCONTROLLER_LIFECYCLE

@end
