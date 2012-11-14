//
//  WFSSchema+WFSGroupedParameters.m
//  WFSWorkflow
//
//  Created by Simon Booth on 19/10/2012.
//  Copyright (c) 2012 CRedit360. All rights reserved.
//

#import "WFSSchema+WFSGroupedParameters.h"
#import "NSObject+WFSSchematising.h"
#import "WFSParameterProxy.h"

#import <objc/runtime.h>

@interface WFSSchema ()

@property (nonatomic, strong) NSDictionary *groupedParameters;
@property (nonatomic, strong) WFSContext *groupedParametersContext;

@end

@implementation WFSSchema (WFSGroupedParameters)

- (Class)classForGroupedParameters
{
    return self.schemaClass;
}

- (NSString *)defaultSchemaParameterNameForType:(Class)parameterClass
{
    NSArray *defaultSchemaParameters = [self.classForGroupedParameters defaultSchemaParameters];
    
    for (NSArray *defaultSchemaParameter in defaultSchemaParameters)
    {
        if (![defaultSchemaParameter isKindOfClass:[NSArray class]] || (defaultSchemaParameter.count != 2))
        {
            [NSException raise:NSInternalInconsistencyException format:@"defaultSchemaParameters incorrectly defined for %@", parameterClass];
        }
        
        Class type = defaultSchemaParameter[0];
        NSString *name = defaultSchemaParameter[1];
        
        if ([parameterClass isSubclassOfClass:type]) return name;
    }
    
    return nil;
}

- (BOOL)canSetSchemaParameterWithName:(NSString *)parameterName type:(Class)parameterType
{
    NSArray *parameterClasses = [self.classForGroupedParameters schemaParameterTypes][parameterName];
    if (!parameterClasses) parameterClasses = @[];
    parameterClasses = [parameterClasses flattenedArray];
    
    for (Class type in parameterClasses)
    {
        if ([parameterType isSubclassOfClass:type]) return YES;
    }
    
    return NO;
}

- (NSDictionary *)groupedParametersWithContext:(WFSContext *)context error:(NSError **)outError
{
    if ([context isEqual:self.groupedParametersContext ])
    {
        if (self.groupedParameters) return self.groupedParameters;
    }
    else
    {
        self.groupedParameters = nil;
    }
    
    NSError *error = nil;
    NSMutableDictionary *groupedParameters = [NSMutableDictionary dictionary];
    
    for (id parameter in self.parameters)
    {
        id parameterValues = parameter;
        NSArray *parameterNames = @[];
        
        if ([parameter isKindOfClass:[WFSSchemaParameter class]])
        {
            WFSSchemaParameter *schemaParameter = parameter;
            
            parameterNames = @[ schemaParameter.name ];
            parameterValues = schemaParameter.value;
        }
        
        parameterValues = [parameterValues flattenedArray];
        for (id parameterValue in parameterValues)
        {
            Class parameterClass = [parameterValue class];
            
            if ([parameterValue isKindOfClass:[WFSSchema class]])
            {
                WFSSchema *schema = parameterValue;
                parameterClass = schema.schemaClass;
                
                if (parameterNames.count == 0)
                {
                    NSString *defaultName = [self defaultSchemaParameterNameForType:parameterClass];
                    parameterNames = [NSArray arrayWithObjects:schema.typeName, defaultName, nil];
                }
            }
            else if (parameterNames.count == 0)
            {
                NSString *defaultName = [self defaultSchemaParameterNameForType:parameterClass];
                parameterNames = [NSArray arrayWithObjects:defaultName, nil];
            }
            
            BOOL didAddParameter = NO;
            
            for (NSString *parameterName in parameterNames)
            {   
                if ([self canSetSchemaParameterWithName:parameterName type:parameterClass])
                {
                    id newValue = parameterValue;
                    BOOL didLoadParameter = [self eagerLoadParameterName:parameterName value:&newValue context:context error:&error];
                    
                    if (!didLoadParameter)
                    {
                        if (!error) error = WFSError(@"Failed to eager load parameter %@", parameterName);
                        break;
                    }
                    
                    BOOL didParseParameter = [self parseParameterName:parameterName value:&newValue error:&error];
                    
                    if (!didParseParameter)
                    {
                        if (!error) error = WFSError(@"Failed to parse parameter %@", parameterName);
                        break;
                    }
                    
                    id existingValue = groupedParameters[parameterName];
                    
                    if (existingValue)
                    {
                        if (![[self.classForGroupedParameters arraySchemaParameters] containsObject:parameterName])
                        {
                            error = WFSError(@"Cannot reassign non-array parameter %@", parameterName);
                            break;
                        }
                        
                        newValue = [newValue flattenedArray];
                        groupedParameters[parameterName] = [(NSArray *)existingValue arrayByAddingObjectsFromArray:newValue];
                    }
                    else
                    {
                        if ([[self.classForGroupedParameters arraySchemaParameters] containsObject:parameterName])
                        {
                            newValue = [newValue flattenedArray];
                            groupedParameters[parameterName] = newValue;
                        }
                        else
                        {
                            groupedParameters[parameterName] = newValue;
                        }
                    }
                    
                    didAddParameter = YES;
                    break;
                }
            }
            
            if (!didAddParameter)
            {
                if (!error) error = WFSError(@"Failed to add parameter for any of %@", parameterNames);
                break;
            }
        }
    }

    if (outError) *outError = error;
    if (error) return nil;
    
    self.groupedParameters = groupedParameters;
    self.groupedParametersContext = context;
    
    return groupedParameters;
}

- (BOOL)eagerLoadParameterName:(NSString *)name value:(id *)inOutValue context:(WFSContext *)context error:(NSError **)outError
{
    NSError *error = nil;
    
    id value = nil;
    if (inOutValue) value = *inOutValue;
    
    if ([[self.classForGroupedParameters lazilyCreatedSchemaParameters] containsObject:name])
    {
        return YES;
    }
    else if ([value isKindOfClass:[NSArray class]])
    {
        NSMutableArray *newValues = [NSMutableArray array];
        
        for (id subValue in value)
        {
            id newSubValue = subValue;
            BOOL didLoadSubParameter = [self eagerLoadParameterName:name value:&newSubValue context:context error:&error];
            
            if (!didLoadSubParameter)
            {
                if (!error) error = WFSError(@"Failed to eager load subparameter of parameter %@", name);
                if (outError) *outError = error;
                return NO;
            }
            
            [newValues addObject:newSubValue];
        }
    }
    else if ([value isKindOfClass:[WFSSchema class]])
    {
        value = [(WFSSchema *)value createObjectWithContext:context error:&error];
        
        if (!value)
        {
            if (!error) error = WFSError(@"Failed to eager load parameter %@", name);
            if (outError) *outError = error;
            return NO;
        }
    }
    
    if (inOutValue) *inOutValue = value;
    
    return YES;
}

- (BOOL)parseParameterName:(NSString *)name value:(id *)inOutValue error:(NSError **)outError
{
    NSError *error = nil;
    
    id value = nil;
    if (inOutValue) value = *inOutValue;
    
    NSDictionary *enumerationDictionary = [self.classForGroupedParameters enumeratedSchemaParameters][name];
    NSDictionary *bitmaskDictionary = [self.classForGroupedParameters bitmaskSchemaParameters][name];
    
    if (enumerationDictionary)
    {
        if ([value isKindOfClass:[NSString class]])
        {
            NSNumber *enumValue = enumerationDictionary[value];
            
            if (!enumValue)
            {
                if (!error) error = WFSError(@"%@ is not an allowed value for %@. Allowed values are: %@", value, name, [enumerationDictionary allKeys]);
                if (outError) *outError = error;
                return NO;
            }
            
            value = enumValue;
        }
    }
    else if (bitmaskDictionary)
    {
        if ([value isKindOfClass:[NSString class]])
        {
            NSArray *components = [(NSString *)value componentsSeparatedByCharactersInSet:[[NSCharacterSet alphanumericCharacterSet] invertedSet]];
            NSNumber *bitmaskValue = [components bitmaskByLookupInDictionary:bitmaskDictionary];
            
            if (!bitmaskValue)
            {
                if (!error) error = WFSError(@"%@ is not an allowed value for %@. Allowed values are: %@", value, name, [bitmaskDictionary allKeys]);
                if (outError) *outError = error;
                return NO;
            }
            
            value = bitmaskValue;
        }
    }
    
    if (inOutValue) *inOutValue = value;
    
    return YES;
}

@end
