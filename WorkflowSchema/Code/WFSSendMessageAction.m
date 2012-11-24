//
//  WFSSendMessageAction.m
//  WFSWorkflow
//
//  Created by Simon Booth on 16/10/2012.
//  Copyright (c) 2012 CRedit360. All rights reserved.
//

#import "WFSSendMessageAction.h"
#import "UIViewController+WFSSchematising.h"
#import "UIViewController+WorkflowSchema.h"

@implementation WFSSendMessageAction

+ (NSArray *)mandatorySchemaParameters
{
    return [[super mandatorySchemaParameters] arrayByAddingObjectsFromArray:@[ @"message" ]];
}

+ (NSArray *)arraySchemaParameters
{
    return [[super arraySchemaParameters] arrayByAddingObjectsFromArray:@[
            
            @"actions",
            @"valueNames"
            
    ]];
}

+ (NSArray *)lazilyCreatedSchemaParameters
{
    return [[super lazilyCreatedSchemaParameters] arrayByAddingObject:@"message" ];
}

+ (NSArray *)defaultSchemaParameters
{
    return [[super defaultSchemaParameters] arrayByPrependingObjectsFromArray:@[
            
            @[ [NSString class], @"message" ],
            @[ [WFSMessage class], @"message" ],
            @[ [WFSAction class], @"actions" ]
            
    ]];
}

+ (NSDictionary *)schemaParameterTypes
{
    return [[super schemaParameterTypes] dictionaryByAddingEntriesFromDictionary:@{
            
            @"message"    : @[ [WFSMessage class], [NSString class], ],
            @"actions"    : [WFSAction class],
            @"valueNames" : [NSString class]
            
    }];
}

- (WFSResult *)performActionForController:(UIViewController *)controller context:(WFSContext *)context
{
    if (self.valueNames)
    {
        WFSMutableContext *restrictedContext = [context mutableCopy];
        NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:self.valueNames.count];
        
        for (NSString *name in self.valueNames)
        {
            id value = context.parameters[name];
            if (value) parameters[name] = value;
            else parameters[name] = [NSNull null];
        }
        
        restrictedContext.parameters = parameters;
        context = restrictedContext;
    }
    
    WFSMessage *message = [self messageFromParameterWithName:@"message" context:context];
    if (!message) return [WFSResult failureResultWithContext:context];
       
    message.responseHandler = ^(WFSResult *result) {
        
        for (WFSAction *action in self.actions)
        {
            if ([action shouldPerformActionForResultName:result.name])
            {
                [action performActionForController:controller context:result.context];
                break;
            }
        }
        
    };
    
    WFSContext *messageContext = nil;
    
    switch (message.destinationType)
    {
        case WFSMessageDestinationDelegate:
        {
            messageContext = controller.workflowContext;
            break;
        }
            
        case WFSMessageDestinationRootDelegate:
        {
            messageContext = context;
            break;
        }
            
        case WFSMessageDestinationSelf:
        {
            messageContext = [controller contextForPerformingActions:context];
            break;
        }
            
        case WFSMessageDestinationDescendant:
        {
            NSArray *descendants = [controller descendantControllersWithWorkflowNames:[NSArray arrayWithObjects:message.destinationName, nil]];
            UIViewController *lastDescendant = [descendants lastObject];
            messageContext = [lastDescendant contextForPerformingActions:context];
            break;
        }
    }
    
    if ([messageContext sendWorkflowMessage:message])
    {
        return [WFSResult successResultWithContext:context];
    }
    else
    {
        NSError *error = WFSError(@"Message with name %@, destination type %d, destination name %@ was not handled", message.name, message.destinationType, message.destinationName);
        [context sendWorkflowError:error];
        return [WFSResult failureResultWithContext:context];
    }
}

@end
