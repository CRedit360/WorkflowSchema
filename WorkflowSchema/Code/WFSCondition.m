//
//  WFSValidateAction.m
//  WFSWorkflow
//
//  Created by Simon Booth on 16/10/2012.
//  Copyright (c) 2012 CRedit360. All rights reserved.
//

#import "WFSCondition.h"

@implementation WFSCondition

- (id)initWithSchema:(WFSSchema *)schema context:(WFSContext *)context error:(NSError **)outError
{
    self = [super init];
    if (self)
    {
        WFS_SCHEMATISING_INITIALISATION;
    }
    return self;
}

+ (NSArray *)lazilyCreatedSchemaParameters
{
    return [[super lazilyCreatedSchemaParameters] arrayByPrependingObject:@"value"];
}

+ (NSDictionary *)schemaParameterTypes
{
    return [[super schemaParameterTypes] dictionaryByAddingEntriesFromDictionary:@{
            
            @"failureMessage" : [NSString class],
            @"value"          : [NSObject class]
            
    }];
}

- (BOOL)evaluateWithContext:(WFSContext *)context
{
    NSError *error = nil;
    id value = [self schemaParameterWithName:@"value" context:context error:&error];
    
    if (!value)
    {
        if (!error) error = WFSError(@"Could not find value for condition");
        [context sendWorkflowError:error];
        return NO;
    }
    
    return [self evaluateWithValue:value context:context];
}

- (BOOL)evaluateWithValue:(id)value context:(WFSContext *)context
{
    return YES;
}

@end
