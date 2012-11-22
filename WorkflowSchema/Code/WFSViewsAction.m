//
//  WFSViewsAction.m
//  WorkflowSchema
//
//  Created by Simon Booth on 02/11/2012.
//  Copyright (c) 2012 CRedit360. All rights reserved.
//

#import "WFSViewsAction.h"
#import "UIView+WorkflowSchema.h"

NSString * const WFSViewsActionDidChangeHierarchyNotification = @"WFSViewsActionDidChangeHierarchyNotification";
NSString * const WFSViewsActionNotificationViewKey = @"view";

@implementation WFSViewsAction

+ (NSArray *)arraySchemaParameters
{
    return [[super arraySchemaParameters] arrayByPrependingObject:@"viewNames"];
}

+ (NSArray *)mandatorySchemaParameters
{
    return [[super mandatorySchemaParameters] arrayByPrependingObject:@"viewNames"];
}

+ (NSDictionary *)schemaParameterTypes
{
    return [[super schemaParameterTypes] dictionaryByAddingEntriesFromDictionary:@{
            
            @"viewNames" : [NSString class]
            
    }];
}

- (void)notifyDidChangeHierarchyOfView:(UIView *)view
{
    [[NSNotificationCenter defaultCenter] postNotificationName:WFSViewsActionDidChangeHierarchyNotification
                                                        object:self
                                                      userInfo:@{ WFSViewsActionNotificationViewKey : view }];
}

@end
