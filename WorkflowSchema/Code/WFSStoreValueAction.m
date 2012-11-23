//
//  WFSSetVariableAction.m
//  WorkflowSchema
//
//  Created by Simon Booth on 12/11/2012.
//  Copyright (c) 2012 CRedit360. All rights reserved.
//

#import "WFSStoreValueAction.h"

@implementation WFSStoreValueAction

+ (NSArray *)mandatorySchemaParameters
{
    return [[super mandatorySchemaParameters] arrayByAddingObject:@"name"];
}

+ (NSArray *)defaultSchemaParameters
{
    return [[super defaultSchemaParameters] arrayByPrependingObject:@[ [NSString class], @"name" ]];
}

+ (NSDictionary *)schemaParameterTypes
{
    return [[super schemaParameterTypes] dictionaryByAddingEntriesFromDictionary:@{
            
            @"name"    : [NSString class],
            @"keyPath" : [NSString class],
            @"value"   : [NSObject class]
            
    }];
}

- (WFSResult *)performActionForController:(UIViewController *)controller context:(WFSContext *)context
{
    NSError *error = nil;
    
    id value = [self schemaParameterWithName:@"value" context:context error:&error];
    
    if (error)
    {
        [context sendWorkflowError:error];
        return [WFSResult failureResultWithContext:context];
    }
    
    if (!value)
    {
        if (self.keyPath) value = [context.parameters valueForKeyPath:self.keyPath];
        else value = context.parameters;
    }
    
    [controller storeValues:@{ self.name : value }];
    return [WFSResult successResultWithContext:context];
}

@end
