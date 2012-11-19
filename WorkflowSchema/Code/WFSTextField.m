//
//  C360LTTextField.m
//  LoginTest
//
//  Created by Simon Booth on 04/10/2012.
//  Copyright (c) 2012 CRedit360. All rights reserved.
//

#import "WFSTextField.h"
#import "WFSCondition.h"

@interface WFSTextFieldDelegate : NSObject <UITextFieldDelegate>; @end

@interface WFSTextField ()

@property (nonatomic, strong) WFSTextFieldDelegate *textFieldDelegate;

@end

@implementation WFSTextField

- (id)initWithSchema:(WFSSchema *)schema context:(WFSContext *)context error:(NSError **)outError
{
    self = [super init];
    if (self)
    {
        _textInsets = UIEdgeInsetsMake(4, 8, 4, 8);
        _textFieldDelegate = [[WFSTextFieldDelegate alloc] init];
        self.delegate = _textFieldDelegate;
        
        WFS_SCHEMATISING_INITIALISATION
        
        if (self.accessibilityLabel.length == 0)
        {
            if (self.placeholder) self.accessibilityLabel = self.placeholder;
        }
        
        if (self.accessibilityLabel.length == 0)
        {
            if (outError) *outError = WFSError(@"Text fields must have a placeholder or an accessibilityLabel");
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

+ (NSDictionary *)schemaParameterTypes
{
    return [[super schemaParameterTypes] dictionaryByAddingEntriesFromDictionary:@{
    
    @"placeholder" : [NSString class],
    @"text" : [NSString class],
    @"validations" : [WFSCondition class]
    
    }];
}

- (UIImage *)backgroundImage
{
    return self.background;
}

- (void)setBackgroundImage:(UIImage *)image
{
    self.background = image;
}

- (id)formValue
{
    return (self.text ? self.text : @"");
}

#pragma mark - layout

- (CGRect)textRectForBounds:(CGRect)bounds
{
    return UIEdgeInsetsInsetRect(bounds, self.textInsets);
}

- (CGRect)editingRectForBounds:(CGRect)bounds
{
    return UIEdgeInsetsInsetRect(bounds, self.textInsets);
}

@end

@implementation WFSTextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return [[(WFSTextField *)textField formInputDelegate] formInputShouldReturn:(WFSTextField *)textField];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [[(WFSTextField *)textField formInputDelegate] formInputDidEndEditing:(WFSTextField *)textField];
}

@end
