//
// RUIRemoteView.m.h
// 
// Created on 2012-10-11 using NibFree
// 

#import "WFSScreenView.h"

@interface WFSScreenView ()

@property (nonatomic, assign) CGFloat keyboardHeight;
@property (nonatomic, strong) UIImageView *portraitBackgroundImageView;
@property (nonatomic, strong) UIImageView *landscapeBackgroundImageView;

@end

@implementation WFSScreenView

- (id)initWithSchema:(WFSSchema *)schema context:(WFSContext *)context error:(NSError **)outError
{
    self = [super initWithSchema:schema context:context error:outError];
    if (self)
    {
        _portraitBackgroundImageView = [[UIImageView alloc] init];
        _portraitBackgroundImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self insertSubview:_portraitBackgroundImageView belowSubview:self.hostedView];
        
        _landscapeBackgroundImageView = [[UIImageView alloc] init];
        _landscapeBackgroundImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self insertSubview:_landscapeBackgroundImageView belowSubview:self.hostedView];
        
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
    
    self.portraitBackgroundImageView.frame = frame;
    self.landscapeBackgroundImageView.frame = frame;
    if (UIInterfaceOrientationIsLandscape(self.interfaceOrientation))
    {
        self.landscapeBackgroundImageView.alpha = 1;
    }
    else
    {
        self.landscapeBackgroundImageView.alpha = 0;
    }
}

#pragma mark - Toolbar

- (void)setToolbar:(WFSToolbar *)toolbar
{
    if (toolbar != _toolbar)
    {
        [_toolbar removeFromSuperview];
        _toolbar = toolbar;
        _toolbar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
        if (_toolbar) [self addSubview:_toolbar];
        
        [self setNeedsLayout];
        [self layoutIfNeeded];
    }
}

#pragma mark - Background images

- (void)setInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    _interfaceOrientation = interfaceOrientation;
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (void)setBackgroundImage:(UIImage *)backgroundImage
{
    _backgroundImage = backgroundImage;
    [self updateBackgroundImageViews];
}

- (void)setPortraitBackgroundImage:(UIImage *)portraitBackgroundImage
{
    _portraitBackgroundImage = portraitBackgroundImage;
    [self updateBackgroundImageViews];
}

- (void)setLandscapeBackgroundImage:(UIImage *)landscapeBackgroundImage
{
    _landscapeBackgroundImage = landscapeBackgroundImage;
    [self updateBackgroundImageViews];
}

- (void)updateBackgroundImageViews
{
    self.portraitBackgroundImageView.image = self.portraitBackgroundImage ? self.portraitBackgroundImage : self.backgroundImage;
    self.landscapeBackgroundImageView.image = self.landscapeBackgroundImage ? self.landscapeBackgroundImage : self.backgroundImage;
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
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


