//
// RUIRemoteView.m.h
// 
// Created on 2012-10-11 using NibFree
// 

#import "WFSScreenView.h"

@interface WFSScreenView ()

@property (nonatomic, assign) CGFloat keyboardHeight;

@end

@implementation WFSScreenView

- (id)initWithSchema:(WFSSchema *)schema context:(WFSContext *)context error:(NSError **)outError
{
    self = [super initWithSchema:schema context:context error:outError];
    if (self)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)layoutSubviews
{
    CGRect frame = self.bounds;
    frame.size.height -= self.keyboardHeight;
    self.hostedView.frame = frame;
}

#pragma mark - Notifications

- (void)keyboardDidShow:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    
    CGRect keyboardFrameInWindow = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGRect keyboardFrameInSelf = [self convertRect:keyboardFrameInWindow fromView:nil];
    
    self.keyboardHeight = self.bounds.size.height - keyboardFrameInSelf.origin.y;
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    self.keyboardHeight = 0;
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

@end


