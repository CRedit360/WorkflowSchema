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

NSString * const WFSLoadSchemaActionMessageTarget = @"loadSchema";
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
    
    // tell the workflow delegate to load the schema at the given path
    WFSMessage *message = [WFSMessage messageWithTarget:WFSLoadSchemaActionMessageTarget name:self.path context:context responseHandler:^(WFSResult *result) {
        
        WFSSchema *schema = nil;
        
        if (result.isSuccess)
        {
            schema = result.context.parameters[WFSLoadSchemaActionSchemaKey];
        }
        
        if ([schema isKindOfClass:[WFSSchema class]])
        {
            WFSMutableContext *successContext = [context mutableCopy];
            successContext.parameters = [context.parameters dictionaryByAddingEntriesFromDictionary:@{ WFSLoadSchemaActionSchemaKey:schema }];
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
        NSError *error = WFSError(@"Message type %@, name %@ was not handled", WFSLoadSchemaActionMessageTarget, self.path);
        [context sendWorkflowError:error];
        return [WFSResult failureResultWithContext:context];
    }
}

@end
