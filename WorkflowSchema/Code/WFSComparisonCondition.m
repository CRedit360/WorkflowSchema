//
//  WFSComparisonCondition.m
//  WorkflowSchema
//
//  Created by Simon Booth on 26/11/2012.
//  Copyright (c) 2012 CRedit360. All rights reserved.
//

#import "WFSComparisonCondition.h"

@implementation WFSComparisonCondition

- (id)initWithSchema:(WFSSchema *)schema context:(WFSContext *)context error:(NSError **)outError
{
    self = [super initWithSchema:schema context:context error:outError];
    if (self)
    {
        self.comparisonType = [self comparisonTypeForTypeName:schema.typeName];
    }
    return self;
}

+ (NSArray *)mandatorySchemaParameters
{
    return [[super mandatorySchemaParameters] arrayByAddingObjectsFromArray:@[ @"otherValue" ]];
}

+ (NSArray *)lazilyCreatedSchemaParameters
{
    return [[super lazilyCreatedSchemaParameters] arrayByAddingObjectsFromArray:@[ @"otherValue" ]];
}

+ (NSArray *)defaultSchemaParameters
{
    return [[super defaultSchemaParameters] arrayByPrependingObject:@[ [NSObject class], @"otherValue" ]];
}

+ (NSDictionary *)schemaParameterTypes
{
    return [[super schemaParameterTypes] dictionaryByAddingEntriesFromDictionary:@{ @"otherValue" : [NSObject class] }];
}

- (WFSComparisonType)comparisonTypeForTypeName:(NSString *)typeName
{
    if ([typeName isEqualToString:@"isLessThan"]) return WFSStrictlyLessThan;
    if ([typeName isEqualToString:@"isLessThanOrEqualTo"]) return WFSLessThanOrEqual;
    if ([typeName isEqualToString:@"isGreaterThanOrEqualTo"]) return WFSGreaterThanOrEqual;
    if ([typeName isEqualToString:@"isGreaterThan"]) return WFSStrictlyGreaterThan;
    
    return (WFSComparisonType)0;
}

- (BOOL)resultForComparisonResult:(NSComparisonResult)comparisonResult
{
    switch (self.comparisonType)
    {
        case WFSStrictlyLessThan:
            return (comparisonResult == NSOrderedAscending);
            
        case WFSLessThanOrEqual:
            return (comparisonResult != NSOrderedDescending);
            
        case WFSGreaterThanOrEqual:
            return (comparisonResult != NSOrderedAscending);
            
        case WFSStrictlyGreaterThan:
            return (comparisonResult == NSOrderedDescending);
    }
}

- (BOOL)evaluateWithValue:(id)value context:(WFSContext *)context
{
    NSError *error = nil;
    
    if ([value isKindOfClass:[NSString class]])
    {
        value = [NSDecimalNumber decimalNumberWithString:value locale:self.workflowSchema.locale];
    }
    
    id otherValue = [self schemaParameterWithName:@"otherValue" context:context error:&error];
    if ([otherValue isKindOfClass:[NSString class]])
    {
        otherValue = [NSDecimalNumber decimalNumberWithString:otherValue locale:self.workflowSchema.locale];
    }
    
    if ([value isKindOfClass:[NSNumber class]] && [otherValue isKindOfClass:[NSNumber class]])
    {
        NSComparisonResult comparisonResult = [value compare:otherValue];
        return [self resultForComparisonResult:comparisonResult];
    }
    else
    {
        NSError *error = WFSError(@"Cannot compare non-numeric values");
        [context sendWorkflowError:error];
        return NO;
    }
}

@end
