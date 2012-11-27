//
//  UIResponder+WFSSchematising.m
//  WorkflowSchema
//
//  Created by Simon Booth on 27/11/2012.
//  Copyright (c) 2012 CRedit360. All rights reserved.
//

#import "UIResponder+WFSSchematising.h"

@implementation UIResponder (WFSSchematising)

+ (NSDictionary *)schemaParameterTypes
{
    return [[super schemaParameterTypes] dictionaryByAddingEntriesFromDictionary:@{
            
            @"inputView"          : [UIView class],
            @"inputAccessoryView" : [UIView class],
            
    }];
}

@end
