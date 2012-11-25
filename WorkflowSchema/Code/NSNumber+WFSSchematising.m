//
//  NSNumber+WFSSchematising.m
//  WorkflowSchema
//
//  Created by Simon Booth on 25/11/2012.
//  Copyright (c) 2012 CRedit360. All rights reserved.
//

#import "NSNumber+WFSSchematising.h"
#import "WFSSchema+WFSGroupedParameters.h"

@implementation NSNumber (WFSSchematising)

- (id)initWithSchema:(WFSSchema *)schema context:(WFSContext *)context error:(NSError **)outError
{
    NSDictionary *groupedParameters = [schema groupedParametersWithContext:context error:outError];
    
    NSNumber *numberValue = groupedParameters[@"value"];
    if ([numberValue isKindOfClass:[NSNumber class]]) return numberValue;
    
    NSString *stringValue = groupedParameters[@"value"];
    if ([schema.typeName isEqual:@"bool"])
    {
        return [NSNumber numberWithBool:[stringValue boolValue]];
    }
    
    return [NSDecimalNumber decimalNumberWithString:stringValue locale:schema.locale];
}

+ (NSArray *)defaultSchemaParameters
{
    return [[super defaultSchemaParameters] arrayByAddingObject:@[ [NSObject class], @"value" ]];
}

+ (NSArray *)mandatorySchemaParameters
{
    return [[super mandatorySchemaParameters] arrayByAddingObject:@"value"];
}

+ (NSDictionary *)schemaParameterTypes
{
    return [[super schemaParameterTypes] dictionaryByAddingEntriesFromDictionary:@{
            
            @"value" : @[ [NSString class], [NSNumber class] ]
            
    }];
}

- (BOOL)setSchemaParameterWithName:(NSString *)name value:(id)value context:(WFSContext *)context error:(NSError *__autoreleasing *)outError
{
    if ([@[@"value"] containsObject:name]) return YES;
    return [super setSchemaParameterWithName:name value:value context:context error:outError];
}

@end
