//
//  WFSDatePicker.m
//  WorkflowSchema
//
//  Created by Simon Booth on 27/11/2012.
//  Copyright (c) 2012 CRedit360. All rights reserved.
//

#import "WFSDatePicker.h"
#import "WFSMessage.h"
#import "UIView+WorkflowSchema.h"
#import "NSDate+WFSSchematising.h"

@implementation WFSDatePicker

- (id)initWithSchema:(WFSSchema *)schema context:(WFSContext *)context error:(NSError **)outError
{
    self = [super initWithSchema:schema context:context error:outError];
    if (self)
    {
        // set the value again, in case it was set before the min/max
        NSDate *date = [self schemaParameterWithName:@"date" context:context error:outError];
        if (date)
        {
            self.date = date;
        }
        
        [self addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return self;
}

+ (NSDictionary *)enumeratedSchemaParameters
{
    return [[super enumeratedSchemaParameters] dictionaryByAddingEntriesFromDictionary:@{
            
            @"datePickerMode" : @{
            
                    @"time"           : @(UIDatePickerModeTime),
                    @"date"           : @(UIDatePickerModeDate),
                    @"dateAndTime"    : @(UIDatePickerModeDateAndTime),
                    @"countDownTimer" : @(UIDatePickerModeCountDownTimer)
            
            }
            
    }];
}

+ (NSArray *)defaultSchemaParameters
{
    return [[super defaultSchemaParameters] arrayByAddingObjectsFromArray:@[
            
            @[ [NSDate class], @"date" ],
            @[ [WFSMessage class], @"message" ]
            
    ]];
}

+ (NSDictionary *)schemaParameterTypes
{
    return [[super schemaParameterTypes] dictionaryByAddingEntriesFromDictionary:@{
            
            @"datePickerMode"    : @[ [NSNumber class], [NSString class] ],
            @"date"              : @[ [NSDate class], [NSString class] ],
            @"minimumDate"       : @[ [NSDate class], [NSString class] ],
            @"maximumDate"       : @[ [NSDate class], [NSString class] ],
            @"countDownDuration" : @[ [NSNumber class], [NSString class] ],
            @"minuteInterval"    : @[ [NSNumber class], [NSString class] ],
            @"message"           : [WFSMessage class]
            
    }];
}

- (BOOL)setSchemaParameterWithName:(NSString *)name value:(id)value context:(WFSContext *)context error:(NSError **)outError
{
    if ([@[@"date", @"minimumDate", @"maximumDate"] containsObject:name] && [value isKindOfClass:[NSString class]])
    {
        value = [NSDate dateWithString:value format:nil locale:nil error:outError];
        if (!value) return NO;
    }
    
    return [super setSchemaParameterWithName:name value:value context:context error:outError];
}

- (id)formValue
{
    return self.date;
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
    
    // If this is an input view, update the responder
    UIResponder *responder = [[[[UIApplication sharedApplication] delegate] window] findFirstResponder];
    if ((responder.inputView == self) && [responder respondsToSelector:@selector(setText:)])
    {
        NSString *text = nil;
        
        if (self.datePickerMode == UIDatePickerModeCountDownTimer)
        {
            NSUInteger minutes = round(self.countDownDuration) / 60;
            text = [NSString stringWithFormat:@"%02u:%02u", minutes / 60, minutes % 60];
        }
        else
        {
            NSDateFormatterStyle dateStyle = NSDateFormatterNoStyle;
            NSDateFormatterStyle timeStyle = NSDateFormatterShortStyle;
            
            switch (self.datePickerMode) {
                    
                case UIDatePickerModeDate:
                    dateStyle = NSDateFormatterLongStyle;
                    timeStyle = NSDateFormatterNoStyle;
                    break;
                    
                case UIDatePickerModeDateAndTime:
                    dateStyle = NSDateFormatterMediumStyle;
                    break;
                    
                default:
                    break;
                    
            }
            
            text = [NSDateFormatter localizedStringFromDate:self.date dateStyle:dateStyle timeStyle:timeStyle];
        }
        
        [(id)responder setText:text];
    }
}

@end
