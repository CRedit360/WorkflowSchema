//
//  WFSSendMessageAction.m
//  WFSWorkflow
//
//  Created by Simon Booth on 16/10/2012.
//  Copyright (c) 2012 CRedit360. All rights reserved.
//

#import "WFSSendMessageAction.h"

@implementation WFSSendMessageAction

+ (NSArray *)mandatorySchemaParameters
{
    return [[super mandatorySchemaParameters] arrayByAddingObjectsFromArray:@[ @"messageType", @"messageName" ]];
}

+ (NSArray *)arraySchemaParameters
{
    return [[super arraySchemaParameters] arrayByAddingObject:@"actions"];
}

+ (NSArray *)defaultSchemaParameters
{
    return [[super defaultSchemaParameters] arrayByPrependingObject:@[ [WFSAction class], @"actions" ]];
}

+ (NSDictionary *)schemaParameterTypes
{
    return [[super schemaParameterTypes] dictionaryByAddingEntriesFromDictionary:@{ @"messageType" : [NSString class], @"messageName" : [NSString class],  @"actions" : [WFSAction class] }];
}

- (WFSResult *)performActionForController:(UIViewController *)controller context:(WFSContext *)context
{
    WFSMessage *message = [WFSMessage messageWithType:self.messageType name:self.messageName context:context responseHandler:^(WFSResult *result) {
        
        for (WFSAction *action in self.actions)
        {
            if ([action shouldPerformActionForResultName:result.name])
            {
                [action performActionForController:controller context:result.context];
                break;
            }
        }
        
    }];
    
    WFSContext *messageContext = context;
    
    // If a controller is sending a message to itself, send it instead to the controller's message delegate
    if ((id)context.contextDelegate == (id)controller)
    {
        messageContext = controller.workflowContext;
    }
    
    if ([messageContext sendWorkflowMessage:message])
    {
        return [WFSResult successResultWithContext:context];
    }
    else
    {
        NSError *error = WFSError(@"Message type %@, name %@ was not handled", self.messageType, self.messageName);
        [context sendWorkflowError:error];
        return [WFSResult failureResultWithContext:context];
    }
}

@end
