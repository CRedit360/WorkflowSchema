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
    return [[super mandatorySchemaParameters] arrayByAddingObject:@"keyName"];
}


+ (NSArray *)arraySchemaParameters
{
    return [[super arraySchemaParameters] arrayByAddingObjectsFromArray:@[@"keyName", @"keyPath", @"value"]];
}

+ (NSArray *)defaultSchemaParameters
{
    return [[super defaultSchemaParameters] arrayByPrependingObject:@[ [NSString class], @"keyName" ]];
}

+ (NSDictionary *)schemaParameterTypes
{
    return [[super schemaParameterTypes] dictionaryByAddingEntriesFromDictionary:@{
            
            @"keyName" : [NSString class],
            @"keyPath" : [NSString class],
            @"value"   : [NSObject class]
            
    }];
}

- (WFSResult *)performActionForController:(UIViewController *)controller context:(WFSContext *)context
{
    NSError *error = nil;
    NSMutableDictionary *valuesToStore = [NSMutableDictionary dictionary];
    
    NSArray *keyNames = self.keyName;
    NSArray *keyPaths = self.keyPath;
    NSArray *values   = [self schemaParameterWithName:@"value" context:context error:&error];
    
    if (error)
    {
        [context sendWorkflowError:error];
        return [WFSResult failureResultWithContext:context];
    }
    
    if (!keyPaths) keyPaths = keyNames;
    if (!values)
    {
        if (keyPaths.count != keyNames.count)
        {
            error = WFSError(@"Key path count does not match key name count");
            [context sendWorkflowError:error];
            return [WFSResult failureResultWithContext:context];
        }
        
        NSMutableArray *createdValues = [NSMutableArray arrayWithCapacity:keyNames.count];
        for (int i = 0; i < keyNames.count; i++)
        {
            NSString *keyPath = keyPaths[i];
            id value = context.parameters[keyPath];
            if (!value) value = [NSNull null];
            [createdValues addObject:value];
        }
        values = createdValues;
    }
    
    if (values.count != keyNames.count)
    {
        error = WFSError(@"Value count does not match key name count");
        [context sendWorkflowError:error];
        return [WFSResult failureResultWithContext:context];
    }
    
    for (int i = 0; i < keyNames.count; i++)
    {
        valuesToStore[keyNames[i]] = values[i];
    }
    
    [controller storeValues:valuesToStore];
    return [WFSResult successResultWithContext:context];
}

@end
