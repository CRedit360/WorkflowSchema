//
//  WFSSwitch.m
//  WorkflowSchema
//
//  Created by Simon Booth on 03/12/2012.
//  Copyright (c) 2012 CRedit360. All rights reserved.
//

#import "WFSSwitch.h"
#import "WFSMessage.h"

@implementation WFSSwitch

- (id)initWithSchema:(WFSSchema *)schema context:(WFSContext *)context error:(NSError **)outError
{
    self = [super initWithSchema:schema context:context error:outError];
    if (self)
    {
        if (self.accessibilityLabel.length == 0)
        {
            if (outError) *outError = WFSError(@"Switches must have an accessibilityLabel");
            return nil;
        }
        
        if ((self.onValue && !self.offValue) || (self.offValue && !self.onValue))
        {
            if (outError) *outError = WFSError(@"Switches must have both an onValue and an offValue, or neither");
            return nil;
        }
        
        [self addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return self;
}

+ (NSArray *)lazilyCreatedSchemaParameters
{
    return [[super lazilyCreatedSchemaParameters] arrayByPrependingObject:@"message"];
}

+ (NSArray *)defaultSchemaParameters
{
    return [[super defaultSchemaParameters] arrayByPrependingObject:@[ [WFSMessage class], @"message" ]];
}

+ (NSDictionary *)schemaParameterTypes
{
    return [[super schemaParameterTypes] dictionaryByAddingEntriesFromDictionary:@{
            
            @"on"       : @[ [NSString class], [NSNumber class] ],
            @"onValue"  : [NSObject class],
            @"offValue" : [NSObject class],
            @"message"  : @[ [WFSMessage class], [NSString class] ]
            
    }];
}

- (id)formValue
{
    if (self.onValue && self.offValue)
    {
        return (self.on) ? self.onValue : self.offValue;
    }
    else return [NSNumber numberWithBool:self.on];
}

- (void)valueChanged:(id)sender
{
    [self.formInputDelegate formInputDidEndEditing:self];
    
    if (self.message)
    {
        WFSMutableContext *context = [self.workflowContext mutableCopy];
        context.actionSender = sender;
        [self sendMessageFromParameterWithName:@"message" context:context];
    }
}


@end
