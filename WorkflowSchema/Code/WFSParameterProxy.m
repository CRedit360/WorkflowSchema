//
//  WFSProxySchema.m
//  WorkflowSchema
//
//  Created by Simon Booth on 21/10/2012.
//  Copyright (c) 2012 CRedit360. All rights reserved.
//

#import "WFSParameterProxy.h"
#import "WFSSchema+WFSGroupedParameters.h"

@implementation WFSParameterProxy

- (NSString *)parameterKeyPath
{
    return self.attributes[@"keyPath"];
}

- (Class)classForGroupedParameters
{
    return [self class];
}

+ (NSDictionary *)schemaParameterTypes
{
    return @{ @"default" : [NSObject class], @"template" : [NSObject class] };
}

+ (NSArray *)lazilyCreatedSchemaParameters
{
    return @[ @"template" ];
}

- (id<WFSSchematising>)createProxiedObject:(id)object context:(WFSContext *)context error:(NSError **)outError
{
    NSError *error = nil;
    
    if ([object isKindOfClass:[NSArray class]])
    {
        NSMutableArray *proxiedObjects = [NSMutableArray array];
        
        for (__strong id subObject in object)
        {
            subObject = [self createProxiedObject:subObject context:context error:&error];
            if (error)
            {
                proxiedObjects = nil;
                break;
            }
            [proxiedObjects addObject:subObject];
        }
        
        object = proxiedObjects;
    }
    else
    {
        if ([object isKindOfClass:[WFSSchema class]])
        {
            object = [(WFSSchema *)object createObjectWithContext:context error:&error];
        }
        
        if (![object isKindOfClass:self.schemaClass])
        {
            if (!error) error = WFSError(@"Proxied parameter %@ of class %@ did not match schema class %@", self.parameterKeyPath, [object class], self.schemaClass);
        }
    }
    
    if (outError) *outError = error;
    return error ? nil : object;
}


- (id<WFSSchematising>)createObjectWithContext:(WFSContext *)context error:(NSError **)outError
{
    NSError *error = nil;
    id object = [context.parameters valueForKeyPath:self.parameterKeyPath];
    NSDictionary *groupedParameters = [self groupedParametersWithContext:context error:&error];
    
    WFSSchema *template = groupedParameters[@"template"];
    if (object && [template isKindOfClass:[WFSSchema class]])
    {
        object = [object flattenedArray];
        NSMutableArray *subObjects = [NSMutableArray array];
        
        for (NSDictionary *parameters in object)
        {
            if ([parameters isKindOfClass:[NSDictionary class]])
            {
                WFSMutableContext *subContext = [context mutableCopy];
                subContext.parameters = parameters;
                
                id subObject = [template createObjectWithContext:subContext error:&error];
                if ([subObject isKindOfClass:self.schemaClass])
                {
                    [subObjects addObject:subObject];
                }
                else
                {
                    if (!error) error = WFSError(@"Proxied parameter %@ of class %@ did not match schema class %@", self.parameterKeyPath, [subObject class], self.schemaClass);
                    break;
                }
            }
            else
            {
                error = WFSError(@"Proxied parameter %@ contained illegal value of class %@", self.parameterKeyPath, [parameters class]);
                break;
            }
        }
        
        object = subObjects;
    }
    else
    {
        if (!object || [object isKindOfClass:[NSNull class]])
        {
            object = groupedParameters[@"default"];
        }
        
        object = [self createProxiedObject:object context:context error:&error];
    }
    
    if (outError) *outError = error;
    return error ? nil : object;
}

@end
