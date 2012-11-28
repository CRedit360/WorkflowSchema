//
//  C360LTTextView.m
//  LoginTest
//
//  Created by Simon Booth on 04/10/2012.
//  Copyright (c) 2012 CRedit360. All rights reserved.
//

#import "WFSTextView.h"
#import "WFSCondition.h"

@interface WFSTextViewDelegate : NSObject <UITextViewDelegate>; @end

@interface WFSTextView ()

@property (nonatomic, strong) WFSTextViewDelegate *textViewDelegate;

@end

@implementation WFSTextView

- (id)initWithSchema:(WFSSchema *)schema context:(WFSContext *)context error:(NSError **)outError
{
    self = [super initWithSchema:schema context:context error:outError];
    if (self)
    {
        self.opaque = NO;
        self.backgroundColor = [UIColor clearColor];
        
        _textViewDelegate = [[WFSTextViewDelegate alloc] init];
        self.delegate = _textViewDelegate;
        
        if (self.accessibilityLabel.length == 0)
        {
            if (outError) *outError = WFSError(@"Text views must have a an accessibilityLabel");
            return nil;
        }
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

+ (NSDictionary *)bitmaskSchemaParameters
{
    return [[super bitmaskSchemaParameters] dictionaryByAddingEntriesFromDictionary:@{
            
            @"dataDetectorTypes" : @{
            
                    @"phoneNumber"   : @(UIDataDetectorTypePhoneNumber),
                    @"link"          : @(UIDataDetectorTypeLink),
                    @"address"       : @(UIDataDetectorTypeAddress),
                    @"calendarEvent" : @(UIDataDetectorTypeCalendarEvent)
            
            }
            
    }];
}

+ (NSDictionary *)schemaParameterTypes
{
    return [[super schemaParameterTypes] dictionaryByAddingEntriesFromDictionary:@{
            
            @"dataDetectorTypes"    : @[ [NSString class], [NSNumber class] ],
            @"editable"             : @[ [NSString class], [NSNumber class] ],
            @"text"                 : [NSString class],
            @"validations"          : [WFSCondition class]
            
    }];
}

- (id)formValue
{
    return (self.text ? self.text : @"");
}

- (NSArray *)validations
{
    return _validations;
}

@end

@implementation WFSTextViewDelegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    [[(WFSTextView *)textView formInputDelegate] formInputWillBeginEditing:(WFSTextView *)textView];
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    [[(WFSTextView *)textView formInputDelegate] formInputDidEndEditing:(WFSTextView *)textView];
}

@end
