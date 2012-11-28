//
//  WFSSlider.m
//  WorkflowSchema
//
//  Created by Simon Booth on 26/11/2012.
//  Copyright (c) 2012 CRedit360. All rights reserved.
//

#import "WFSSlider.h"
#import "WFSMessage.h"
#import "WFSCondition.h"

@implementation WFSSlider

- (id)initWithSchema:(WFSSchema *)schema context:(WFSContext *)context error:(NSError **)outError
{
    self = [super initWithSchema:schema context:context error:outError];
    if (self)
    {
        if (self.accessibilityLabel.length == 0)
        {
            if (outError) *outError = WFSError(@"Sliders must have an accessibilityLabel");
            return nil;
        }
        
        // set the value again, in case it was set before the min/max
        NSNumber *value = [self schemaParameterWithName:@"value" context:context error:outError];
        if (value)
        {
            self.value = [value integerValue];
        }
        
        [self addTarget:self action:@selector(touchDown:) forControlEvents:UIControlEventTouchDown];
        [self addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
        [self addTarget:self action:@selector(touchUp:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

+ (NSArray *)arraySchemaParameters
{
    return [[super arraySchemaParameters] arrayByPrependingObject:@"validations"];
}

+ (NSArray *)defaultSchemaParameters
{
    return [[super defaultSchemaParameters] arrayByPrependingObject:@[ [WFSCondition class], @"validations" ]];
}

+ (NSDictionary *)schemaParameterTypes
{
    return [[super schemaParameterTypes] dictionaryByAddingEntriesFromDictionary:@{
            
            @"continuous"   : @[ [NSString class], [NSNumber class] ],
            @"value"        : @[ [NSString class], [NSNumber class] ],
            @"minimumValue" : @[ [NSString class], [NSNumber class] ],
            @"maximumValue" : @[ [NSString class], [NSNumber class] ],
            @"message"      : @[ [WFSMessage class], [NSString class] ],
            @"validations"  : [WFSCondition class]
            
    }];
}

- (id)formValue
{
    return @(self.value);
}

- (void)touchDown:(id)sender
{
    [self.formInputDelegate formInputWillBeginEditing:self];
}

- (void)valueChanged:(id)sender
{
    if (self.continuous && self.message)
    {
        WFSMutableContext *context = [self.workflowContext mutableCopy];
        context.actionSender = sender;
        [self sendMessageFromParameterWithName:@"message" context:context];
    }
}

- (void)touchUp:(id)sender
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
