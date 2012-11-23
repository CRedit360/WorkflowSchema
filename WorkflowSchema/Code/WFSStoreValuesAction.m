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
    return [[super mandatorySchemaParameters] arrayByAddingObject:@"name"];
}


+ (NSArray *)arraySchemaParameters
{
    return [[super arraySchemaParameters] arrayByAddingObjectsFromArray:@[@"name", @"keyPath", @"value"]];
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
    NSMutableDictionary *valuesToStore = [NSMutableDictionary dictionary];
    
    NSArray *names    = self.name;
    NSArray *keyPaths = self.keyPath;
    NSArray *values   = [self schemaParameterWithName:@"value" context:context error:&error];
    
    if (error)
    {
        [context sendWorkflowError:error];
        return [WFSResult failureResultWithContext:context];
    }
    
    if (!keyPaths) keyPaths = names;
    if (!values)
    {
        if (keyPaths.count != names.count)
        {
            error = WFSError(@"Key path count does not match name count");
            [context sendWorkflowError:error];
            return [WFSResult failureResultWithContext:context];
        }
        
        NSMutableArray *createdValues = [NSMutableArray arrayWithCapacity:names.count];
        for (int i = 0; i < names.count; i++)
        {
            NSString *keyPath = keyPaths[i];
            id value = context.parameters[keyPath];
            if (!value) value = [NSNull null];
            [createdValues addObject:value];
        }
        values = createdValues;
    }
    
    if (values.count != names.count)
    {
        error = WFSError(@"Value count does not match name count");
        [context sendWorkflowError:error];
        return [WFSResult failureResultWithContext:context];
    }
    
    for (int i = 0; i < names.count; i++)
    {
        valuesToStore[names[i]] = values[i];
    }
    
    [controller storeValues:valuesToStore];
    return [WFSResult successResultWithContext:context];
}

@end
