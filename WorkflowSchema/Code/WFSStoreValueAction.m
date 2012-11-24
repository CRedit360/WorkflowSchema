//
//  WFSSetVariableAction.m
//  WorkflowSchema
//
//  Created by Simon Booth on 12/11/2012.
//  Copyright (c) 2012 CRedit360. All rights reserved.
//

#import "WFSStoreValueAction.h"
#import "UIViewController+WFSSchematising.h"

@implementation WFSStoreValueAction

+ (NSArray *)mandatorySchemaParameters
{
    return [[super mandatorySchemaParameters] arrayByAddingObject:@"name"];
}

+ (NSArray *)defaultSchemaParameters
{
    return [[super defaultSchemaParameters] arrayByPrependingObject:@[ [NSString class], @"name" ]];
}

+ (NSArray *)lazilyCreatedSchemaParameters
{
    return [[super lazilyCreatedSchemaParameters] arrayByAddingObject:@"value"];
}

+ (NSDictionary *)schemaParameterTypes
{
    return [[super schemaParameterTypes] dictionaryByAddingEntriesFromDictionary:@{
            
            @"name"    : [NSString class],
            @"value"   : [NSObject class]
            
    }];
}

- (WFSResult *)performActionForController:(UIViewController *)controller context:(WFSContext *)context
{
    NSError *error = nil;
    
    id value = nil;
    if (self.value)
    {
        value = [self schemaParameterWithName:@"value" context:context error:&error];
        
        if (error)
        {
            [context sendWorkflowError:error];
            return [WFSResult failureResultWithContext:context];
        }
    }
    else
    {
        value = context.parameters;
    }
    
    if (!value) value = [NSNull null];
    NSDictionary *valuesToStore = @{ self.name : value };
    
    // Store the value in the controller
    [controller storeValues:valuesToStore];
    
    // *also* store it in the current context
    WFSMutableContext *responseContext = [context mutableCopy];
    responseContext.parameters = [context.parameters dictionaryByAddingEntriesFromDictionary:valuesToStore];
    
    return [WFSResult successResultWithContext:responseContext];
}

@end
