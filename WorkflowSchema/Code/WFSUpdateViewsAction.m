//
//  WFSUpdateViewsAction.m
//  WorkflowSchema
//
//  Created by Simon Booth on 22/11/2012.
//  Copyright (c) 2012 CRedit360. All rights reserved.
//

#import "WFSUpdateViewsAction.h"

@implementation WFSUpdateViewsAction

+ (NSArray *)mandatorySchemaParameters
{
    return [[super mandatorySchemaParameters] arrayByAddingObject:@"parameterName"];
}

+ (NSArray *)lazilyCreatedSchemaParameters
{
    return [[super lazilyCreatedSchemaParameters] arrayByAddingObject:@"value"];
}

+ (NSDictionary *)schemaParameterTypes
{
    return [[super schemaParameterTypes] dictionaryByAddingEntriesFromDictionary:@{
            
            @"parameterName" : [NSString class],
            @"value" : [NSObject class]
            
    }];
}

// TODO: move this logic, and as much of WFSSchema+WFSGroupedParameters as necessary, into
// NSObject+WFSSchematising
- (BOOL)canSetValue:(id)value parameterName:(NSString *)name view:(UIView *)view
{
    NSArray *classes = [[[[view class] schemaParameterTypes] objectForKey:name] flattenedArray];
    BOOL isArrayParameter = [[[view class] arraySchemaParameters] containsObject:name];
    
    bool didFindClass = NO;
    if (isArrayParameter)
    {
        if ([value isKindOfClass:[NSArray class]])
        {
            didFindClass = YES;
            
            for (id subValue in value)
            {
                BOOL didFindSubClass = NO;
                
                for (Class class in classes)
                {
                    if ([value isKindOfClass:class])
                    {
                        didFindSubClass = YES;
                        break;
                    }
                }
                
                if (!didFindSubClass)
                {
                    didFindClass = NO;
                    break;
                }
            }
        }
    }
    else
    {
        for (Class class in classes)
        {
            if ([value isKindOfClass:class])
            {
                didFindClass = YES;
                break;
            }
        }
    }
    
    return didFindClass;
}

- (WFSResult *)performActionForController:(UIViewController *)controller context:(WFSContext *)context
{
    NSError *error = nil;
    NSArray *views = [controller.view subviewsWithWorkflowNames:self.viewNames];
    
    id value = [self schemaParameterWithName:@"value" context:context error:&error];
    if (error)
    {
        [context sendWorkflowError:error];
        return [WFSResult failureResultWithContext:context];
    }
    
    UIView *viewWithoutParameter = nil;
    for (UIView *view in views)
    {
        if (![self canSetValue:value parameterName:self.parameterName view:view])
        {
            viewWithoutParameter = view;
            break;
        }
    }
    
    if (viewWithoutParameter)
    {
        [context sendWorkflowError:WFSError(@"Could not set parameter %@ on view with class %@", self.parameterName, [viewWithoutParameter class])];
        return [WFSResult failureResultWithContext:context];
    }
    
    for (UIView *view in views)
    {
        [view setSchemaParameterWithName:self.parameterName value:value context:context error:&error];
        if (error)
        {
            [context sendWorkflowError:error];
            return [WFSResult failureResultWithContext:context];
        }
    }
    
    [self notifyDidChangeHierarchyOfView:controller.view];
    return [WFSResult successResultWithContext:context];
}

@end
