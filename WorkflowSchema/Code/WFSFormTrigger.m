//
//  WFSFormTrigger.m
//  WorkflowSchema
//
//  Created by Simon Booth on 01/11/2012.
//  Copyright (c) 2012 CRedit360. All rights reserved.
//

#import "WFSFormTrigger.h"
#import "WFSCondition.h"

@implementation WFSFormTrigger

- (id)initWithSchema:(WFSSchema *)schema context:(WFSContext *)context error:(NSError **)outError
{
    self = [super init];
    if (self)
    {
        WFS_SCHEMATISING_INITIALISATION;
    }
    return self;
}

+ (NSArray *)arraySchemaParameters
{
    return [[super arraySchemaParameters] arrayByPrependingObjectsFromArray:@[
            
            @"successTriggers",
            @"failureTriggers"
            
    ]];
}

+ (NSArray *)defaultSchemaParameters
{
    return [[super defaultSchemaParameters] arrayByPrependingObjectsFromArray:@[
            
            @[ [WFSCondition class], @"condition" ]
            
    ]];
}

+ (NSDictionary *)schemaParameterTypes
{
    return [[super schemaParameterTypes] dictionaryByAddingEntriesFromDictionary:@{
            
            @"condition"         : [WFSCondition class],
            
            @"successActionName" : [NSString class],
            @"successTriggers"   : [WFSFormTrigger class],
            
            @"failureActionName" : [NSString class],
            @"failureTriggers"   : [WFSFormTrigger class]
            
    }];
}

- (void)fireWithContext:(WFSContext *)context
{
    NSString *actionName = nil;
    NSArray *triggers = nil;
    
    if (!self.condition || [self.condition evaluateWithContext:context])
    {
        actionName = self.successActionName;
        triggers = self.successTriggers;
    }
    else
    {
        actionName = self.failureActionName;
        triggers = self.failureTriggers;
    }
    
    if (actionName)
    {
        WFSMessage *message = [WFSMessage actionMessageWithName:actionName context:context];
        [context sendWorkflowMessage:message];
    }
    
    for (WFSFormTrigger *trigger in triggers)
    {
        [trigger fireWithContext:context];
    }
}

@end
