//
//  WFSTabBarController.m
//  WFSWorkflow
//
//  Created by Simon Booth on 15/10/2012.
//  Copyright (c) 2012 CRedit360. All rights reserved.
//

#import "WFSTabBarController.h"
#import "UIViewController+WFSSchematising.h"
#import "WFSAction.h"

NSString * const WFSTabsMessageTarget = @"tabs";

@interface WFSTabBarController ()

@end

@implementation WFSTabBarController

- (id)initWithSchema:(WFSSchema *)schema context:(WFSContext *)context error:(NSError **)outError
{
    self = [super init];
    if (self)
    {
        WFS_SCHEMATISING_INITIALISATION
    }
    return self;
}

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
    
    @"viewControllers" : [UIViewController class]
    
    }];
}

#pragma mark - Actions

+ (NSString *)actionWorkflowMessageTarget
{
    return WFSTabsMessageTarget;
}

WFS_UIVIEWCONTROLLER_LIFECYCLE

@end
