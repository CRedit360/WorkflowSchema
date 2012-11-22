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
        NSArray *classes = [[[[view class] schemaParameterTypes] objectForKey:self.parameterName] flattenedArray];
        
        bool didFindClass = NO;
        for (Class class in classes)
        {
            if ([[value class] isSubclassOfClass:class])
            {
                didFindClass = YES;
                break;
            }
        }
        
        if (!didFindClass)
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
    
    return [WFSResult successResultWithContext:context];
}

@end
