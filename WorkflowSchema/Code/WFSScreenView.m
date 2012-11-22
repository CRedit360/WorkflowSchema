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
    CGFloat width = frame.size.width, height = frame.size.height;
    CGFloat toolbarHeight = [self.toolbar sizeThatFits:frame.size].height;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
    {
        self.toolbar.frame = CGRectMake(0, 0, width, toolbarHeight);
        self.hostedView.frame = CGRectMake(0, toolbarHeight, width, height - (toolbarHeight + self.keyboardHeight));
    }
    else
    {
        self.hostedView.frame = CGRectMake(0, 0, width, height - MAX(toolbarHeight, self.keyboardHeight));
        self.toolbar.frame = CGRectMake(0, height - toolbarHeight, width, toolbarHeight);
    }
}

- (void)setToolbar:(WFSToolbar *)toolbar
{
    if (toolbar != _toolbar)
    {
        [_toolbar removeFromSuperview];
        _toolbar = toolbar;
        if (_toolbar) [self addSubview:_toolbar];
    }
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


