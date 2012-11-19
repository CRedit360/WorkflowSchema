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

+ (NSArray *)lazilyCreatedSchemaParameters
{
    return [[super lazilyCreatedSchemaParameters] arrayByPrependingObjectsFromArray:@[@"successMessage", @"successMessage"]];
}

+ (NSDictionary *)schemaParameterTypes
{
    return [[super schemaParameterTypes] dictionaryByAddingEntriesFromDictionary:@{
            
            @"condition"       : [WFSCondition class],
            
            @"successMessage"  : @[ [WFSMessage class], [NSString class] ],
            @"successTriggers" : [WFSFormTrigger class],
            
            @"failureMessage"  : @[ [WFSMessage class], [NSString class] ],
            @"failureTriggers" : [WFSFormTrigger class]
            
    }];
}

- (void)fireWithContext:(WFSContext *)context
{
    id message = nil;
    NSString *messageParameterName = nil;
    NSArray *triggers = nil;
    
    if (!self.condition || [self.condition evaluateWithContext:context])
    {
        message = self.successMessage;
        messageParameterName = @"successMessage";
        triggers = self.successTriggers;
    }
    else
    {
        message = self.failureMessage;
        messageParameterName = @"failureMessage";
        triggers = self.failureTriggers;
    }
    
    if (message)
    {
        [self sendMessageFromParameterWithName:messageParameterName context:context];
    }
    
    for (WFSFormTrigger *trigger in triggers)
    {
        [trigger fireWithContext:context];
    }
}

@end
