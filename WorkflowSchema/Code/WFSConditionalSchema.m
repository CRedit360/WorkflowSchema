//
//  WFSConditionalSchema.m
//  WorkflowSchema
//
//  Created by Simon Booth on 03/12/2012.
//  Copyright (c) 2012 CRedit360. All rights reserved.
//

#import "WFSConditionalSchema.h"
#import "WFSCondition.h"
#import "WFSSchema+WFSGroupedParameters.h"

@implementation WFSConditionalSchema

- (Class)classForGroupedParameters
{
    return [self class];
}

+ (NSDictionary *)schemaParameterTypes
{
    return @{ @"successValue" : [NSObject class], @"failureValue" : [NSObject class], @"condition" : [WFSCondition class] };
}

+ (NSArray *)defaultSchemaParameters
{
    return @[ @[ [WFSCondition class], @"condition" ] ];
}

+ (NSArray *)lazilyCreatedSchemaParameters
{
    return @[ @"successValue", @"failureValue" ];
}

+ (NSArray *)mandatorySchemaParameters
{
    return @[ @"condition" ];
}

- (id<WFSSchematising>)createObjectWithContext:(WFSContext *)context error:(NSError **)outError
{
    NSError *error = nil;
    WFSSchema *schema = nil;
    
    @try
    {
        NSDictionary *groupedParameters = [self groupedParametersWithContext:context error:&error];
        WFSCondition *condition = groupedParameters[@"condition"];
        
        if ([condition evaluateWithContext:context])
        {
            schema = groupedParameters[@"successValue"];
        }
        else
        {
            schema = groupedParameters[@"failureValue"];
        }
    }
    @catch (NSException *exception)
    {
        error = WFSErrorFromException(exception);
    }
    
    if (outError) *outError = error;
    return error ? nil : [schema createObjectWithContext:context error:outError];
}

@end
