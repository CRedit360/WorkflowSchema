//
//  WFSShowWorkflowAction.m
//  WFSWorkflow
//
//  Created by Simon Booth on 16/10/2012.
//  Copyright (c) 2012 CRedit360. All rights reserved.
//

#import "WFSLoadSchemaAction.h"
#import "WFSSchema.h"
#import "WFSMessage.h"
#import "WFSControllerAction.h"

NSString * const WFSLoadSchemaActionMessageName = @"loadSchema";
NSString * const WFSLoadSchemaActionPathKey = @"path";
NSString * const WFSLoadSchemaActionSchemaKey = @"schema";

@implementation WFSLoadSchemaAction

+ (NSArray *)mandatorySchemaParameters
{
    return [[super mandatorySchemaParameters] arrayByAddingObjectsFromArray:@[ @"path", @"successAction", @"failureAction" ]];
}

+ (NSArray *)defaultSchemaParameters
{
    return [[super defaultSchemaParameters] arrayByPrependingObjectsFromArray:@[
    
    @[ [NSString class], @"path" ],
    @[ [WFSControllerAction class], @"successAction"],
    @[ [WFSAction class], @"failureAction"]
            
    ]];
}

+ (NSDictionary *)schemaParameterTypes
{
    return [[super schemaParameterTypes] dictionaryByAddingEntriesFromDictionary:@{
            
    @"path" : [NSString class],
    @"successAction" : [WFSControllerAction class],
    @"failureAction" : [WFSAction class]

    }];
}

- (WFSResult *)performActionForController:(UIViewController *)controller context:(WFSContext *)context
{
    // stop listening to the user
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    
    WFSMutableContext *loadContext = [context mutableCopy];
    NSMutableDictionary *userInfo = [context.userInfo mutableCopy];
    userInfo[WFSLoadSchemaActionPathKey] = self.path;
    loadContext.userInfo = userInfo;
    
    // tell the workflow delegate to load the schema at the given path
    WFSMessage *message = [WFSMessage messageWithName:WFSLoadSchemaActionMessageName destinationType:WFSMessageDestinationRootDelegate destinationName:nil context:loadContext responseHandler:^(WFSResult *result) {
        
        WFSSchema *schema = nil;
        
        if (result.isSuccess)
        {
            schema = result.context.userInfo[WFSLoadSchemaActionSchemaKey];
        }
        
        if ([schema isKindOfClass:[WFSSchema class]])
        {
            WFSMutableContext *successContext = [context mutableCopy];
            successContext.userInfo = [context.userInfo dictionaryByAddingEntriesFromDictionary:@{ WFSLoadSchemaActionSchemaKey:schema }];
            [self.successAction performActionForController:controller context:successContext];
        }
        else
        {
            [self.failureAction performActionForController:controller context:context];
        }
        
        // start listening to the user again
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        
    }];
    
    if ([context sendWorkflowMessage:message])
    {
        return [WFSResult successResultWithContext:context];
    }
    else
    {
        // start listening to the user again
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        
        NSError *error = WFSError(@"Load schema message for path %@ was not handled", self.path);
        [context sendWorkflowError:error];
        return [WFSResult failureResultWithContext:context];
    }
}

@end
