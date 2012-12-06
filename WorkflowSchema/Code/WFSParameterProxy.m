//
//  WFSProxySchema.m
//  WorkflowSchema
//
//  Created by Simon Booth on 21/10/2012.
//  Copyright (c) 2012 CRedit360. All rights reserved.
//

#import "WFSParameterProxy.h"
#import "WFSSchema+WFSGroupedParameters.h"
#import "WFSSchematising.h"

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
            
            if (error) break;
            if (subObject) [proxiedObjects addObject:subObject];
        }
        
        object = proxiedObjects;
    }
    else
    {
        if ([object isKindOfClass:[WFSSchema class]])
        {
            object = [(WFSSchema *)object createObjectWithContext:context error:&error];
        }
        
        if ([object isKindOfClass:[NSNull class]])
        {
            object = nil;
        }
        
        if (object && ![object isKindOfClass:self.schemaClass])
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
    id object = nil;
    
    @try
    {
        object = [context.userInfo valueForKeyPath:self.parameterKeyPath];
        NSDictionary *groupedParameters = [self groupedParametersWithContext:context error:&error];
        
        WFSSchema *template = groupedParameters[@"template"];
        if (object && template)
        {
            BOOL objectIsArray = [object isKindOfClass:[NSArray class]];
            
            object = [object flattenedArray];
            NSMutableArray *subObjects = [NSMutableArray array];
            
            for (__strong NSDictionary *userInfo in object)
            {
                NSString *valueName = self.attributes[@"valueName"];
                if (valueName)
                {
                    userInfo = @{ valueName : userInfo };
                }
                
                if ([userInfo isKindOfClass:[NSDictionary class]])
                {
                    WFSMutableContext *subContext = [context mutableCopy];
                    subContext.userInfo = userInfo;
                    
                    id subObject = [self createProxiedObject:template context:subContext error:&error];
                    
                    if (subObject && ![subObject isKindOfClass:self.schemaClass])
                    {
                        if (!error) error = WFSError(@"Proxied parameter %@ of class %@ did not match schema class %@", self.parameterKeyPath, [subObject class], self.schemaClass);
                    }
                    
                    if (error) break;
                    if (subObject) [subObjects addObject:subObject];
                }
                else
                {
                    error = WFSError(@"Proxied parameter %@ contained illegal value of class %@", self.parameterKeyPath, [userInfo class]);
                    break;
                }
            }
            
            if (objectIsArray)
            {
                object = subObjects;
            }
            else
            {
                object = [subObjects lastObject];
            }
        }
        else
        {
            if (!object || [object isKindOfClass:[NSNull class]])
            {
                object = groupedParameters[@"default"];
            }
            
            object = [self createProxiedObject:object context:context error:&error];
        }
    }
    @catch (NSException *exception)
    {
        error = WFSErrorFromException(exception);
    }
    
    if (outError) *outError = error;
    return error ? nil : object;
}

@end
