//
//  WFSFormAccessoryView.m
//  WorkflowSchema
//
//  Created by Simon Booth on 27/11/2012.
//  Copyright (c) 2012 CRedit360. All rights reserved.
//

#import "WFSFormAccessoryView.h"
#import "WFSMacros.h"
#import "WFSFormInput.h"
#import "UIView+WorkflowSchema.h"

@interface WFSFormAccessoryView ()

@property (nonatomic, strong) UISegmentedControl *prevNextControl;
@property (nonatomic, strong) UIBarButtonItem *doneButtonItem;

@end

@implementation WFSFormAccessoryView

- (id)initWithSchema:(WFSSchema *)schema context:(WFSContext *)context error:(NSError **)outError
{
    self = [super initWithSchema:schema context:context error:outError];
    if (self)
    {
        if (!self.previousButtonTitle) self.previousButtonTitle = WFSLocalizedString(@"WFSFormAccessoryView.previousButtonTitle", @"Prev");
        if (!self.nextButtonTitle) self.nextButtonTitle = WFSLocalizedString(@"WFSFormAccessoryView.nextButtonTitle", @"Next");
        
        self.prevNextControl = [[UISegmentedControl alloc] initWithItems:@[ self.previousButtonTitle, self.nextButtonTitle ]];
        self.prevNextControl.segmentedControlStyle = UISegmentedControlStyleBar;
        self.prevNextControl.momentary = YES;
        [self.prevNextControl addTarget:self action:@selector(prevNextControlTapped:) forControlEvents:UIControlEventValueChanged];

        UIBarButtonItem *prevNextItem = [[UIBarButtonItem alloc] initWithCustomView:self.prevNextControl];
        UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        self.doneButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonTapped:)];
        
        self.items = @[ prevNextItem, spaceItem, self.doneButtonItem ];
    }
    
    return self;
}

- (UIResponder<WFSFormInput> *)findFormInput
{
    UIResponder<WFSFormInput> *responder = (UIResponder<WFSFormInput> *)[[[[UIApplication sharedApplication] delegate] window] findFirstResponder];
    if ((responder.inputAccessoryView == self) && [responder conformsToProtocol:@protocol(WFSFormInput)])
    {
        return responder;
    }
    return nil;
}

- (void)layoutSubviews
{
    UIResponder<WFSFormInput> *formInput = [self findFormInput];
    
    BOOL canFocusPreviousInput = [formInput.formInputDelegate canFocusPreviousInput:formInput];
    [self.prevNextControl setEnabled:canFocusPreviousInput forSegmentAtIndex:0];
    
    bool canFocusNextInput = [formInput.formInputDelegate canFocusPreviousInput:formInput];
    [self.prevNextControl setEnabled:canFocusNextInput forSegmentAtIndex:1];
    
    [self sizeToFit];
    [super layoutSubviews];
}

- (void)prevNextControlTapped:(id)sender
{
    UIResponder<WFSFormInput> *formInput = [self findFormInput];
    
    switch (self.prevNextControl.selectedSegmentIndex)
    {
        case 0:
            [formInput.formInputDelegate focusPreviousInput:formInput];
            break;
            
        case 1:
            [formInput.formInputDelegate focusNextInput:formInput];
            break;
            
        default:
            break;
    }
}

- (void)doneButtonTapped:(id)sender
{
    UIResponder<WFSFormInput> *formInput = [self findFormInput];
    
    if ([formInput.formInputDelegate formInputShouldReturn:formInput])
    {
        [self.window endEditing:YES];
    }
}

@end
