//
//  WFSSetVariableAction.m
//  WorkflowSchema
//
//  Created by Simon Booth on 12/11/2012.
//  Copyright (c) 2012 CRedit360. All rights reserved.
//

#import "WFSStoreValuesAction.h"

@implementation WFSStoreValuesAction

+ (NSArray *)mandatorySchemaParameters
{
    return [[super mandatorySchemaParameters] arrayByAddingObject:@"keys"];
}

+ (NSArray *)arraySchemaParameters
{
    return [[super arraySchemaParameters] arrayByAddingObject:@"keys"];
}

+ (NSArray *)defaultSchemaParameters
{
    return [[super defaultSchemaParameters] arrayByPrependingObject:@[ [NSString class], @"keys" ]];
}

+ (NSDictionary *)schemaParameterTypes
{
    return [[super schemaParameterTypes] dictionaryByAddingEntriesFromDictionary:@{ @"keys" : [NSString class] }];
}

- (WFSResult *)performActionForController:(UIViewController *)controller context:(WFSContext *)context
{
    NSMutableDictionary *values = [NSMutableDictionary dictionary];
    
    for (NSString *key in self.keys)
    {
        if (context.parameters[key])
        {
            values[key] = context.parameters[key];
        }
        else
        {
            values[key] = [NSNull null];
        }
    }
    
    [controller storeValues:context.parameters];
    return [WFSResult successResultWithContext:context];
}

@end
