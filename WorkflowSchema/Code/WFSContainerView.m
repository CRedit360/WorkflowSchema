//
//  C360DFTContainer.m
//  DynamicFormsTest
//
//  Created by Simon Booth on 10/10/2012.
//  Copyright (c) 2012 CRedit360. All rights reserved.
//

#import "WFSContainerView.h"
#import "WFSViewsAction.h"

@interface WFSContainerView ()

@property (nonatomic, strong, readonly) UIImageView *backgroundImageView;
@property (nonatomic, strong, readonly) UIScrollView *contentScrollView;
@property (nonatomic, strong, readwrite) NSArray *contentViews;
@property (nonatomic, assign, readwrite) WFSContainerViewLayout layout;

@end

@implementation WFSContainerView

- (id)initWithSchema:(WFSSchema *)schema context:(WFSContext *)context error:(NSError **)outError
{
    self = [super init];
    if (self)
    {
        _desiredSize = CGSizeZero;
        
        _backgroundImageView = [[UIImageView alloc] init];
        [self addSubview:_backgroundImageView];
        
        _contentViews = [NSArray array];
        _contentEdgeInsets = UIEdgeInsetsMake(20, 20, 20, 20);
        _contentPadding = 8;
        _contentScrollView = [[UIScrollView alloc] init];
        [self addSubview:_contentScrollView];
        
        WFS_SCHEMATISING_INITIALISATION
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hierarchyChanged:) name:WFSViewsActionDidChangeHierarchyNotification object:nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

+ (NSArray *)mandatorySchemaParameters
{
    return [[super mandatorySchemaParameters] arrayByPrependingObject:@"views"];
}

+ (NSArray *)arraySchemaParameters
{
    return [[super arraySchemaParameters] arrayByPrependingObject:@"views"];
}

+ (NSArray *)defaultSchemaParameters
{
    return [[super defaultSchemaParameters] arrayByPrependingObjectsFromArray:@[
            
            @[ [UIView class], @"views" ],
            @[ [UIViewController class], @"views" ]
            
    ]];
}

+ (NSDictionary *)schemaParameterTypes
{
    return [[super schemaParameterTypes] dictionaryByAddingEntriesFromDictionary:@{
            
            @"views" : @[ [UIView class], [UIViewController class] ],
            @"layout" : @[ [NSString class], [NSNumber class] ]
            
    }];
}

+ (NSDictionary *)enumeratedSchemaParameters
{
    return [[super enumeratedSchemaParameters] dictionaryByAddingEntriesFromDictionary:@{
            
            @"layout" : @{
            
                    @"vertical" : @(WFSContainerViewVerticalLayout),
                    @"center"   : @(WFSContainerViewCenterLayout),
                    @"fill"     : @(WFSContainerViewFillLayout)
            
            }
            
    }];
}

- (BOOL)setSchemaParameterWithName:(NSString *)name value:(id)value context:(WFSContext *)context error:(NSError *__autoreleasing *)outError
{
    if ([name isEqual:@"views"])
    {
        for (id subValue in value)
        {
            if ([subValue isKindOfClass:[UIViewController class]])
            {
                UIViewController *controller = (UIViewController *)subValue;
                [controller willMoveToParentViewController:context.containerController];
                [self addContentView:controller.view];
                [context.containerController addChildViewController:controller];
                [controller didMoveToParentViewController:context.containerController];
            }
            else if ([subValue isKindOfClass:[UIView class]])
            {
                UIView *view = (UIView *)subValue;
                [self addContentView:view];
            }
            else
            {
                if (outError) *outError = WFSError(@"Parameter of type %@ is not a view or view controller", [subValue class]);
            }
        }
        
        return YES;
    }
    else return [super setSchemaParameterWithName:name value:value context:context error:outError];
}

- (void)addContentView:(UIView *)view
{
    [self.contentScrollView addSubview:view];
    self.contentViews = [self.contentViews arrayByAddingObject:view];
}

- (CGSize)sizeForSize:(CGSize)size performLayout:(BOOL)performLayout
{
    switch (self.layout)
    {
        case WFSContainerViewCenterLayout:
        {
            for (UIView *view in self.contentViews)
            {
                if (performLayout)
                {
                    [view sizeToFit];
                    view.center = self.contentScrollView.center; // Strictly we should calculate this in the CSV's bounds, but it fills this view so this gives us the right answer
                }
            }
            
            return self.bounds.size;
        }
            
        case WFSContainerViewFillLayout:
        {
            CGRect layoutRect = UIEdgeInsetsInsetRect(self.bounds, self.contentEdgeInsets);
            CGSize fillSize = layoutRect.size;
            
            for (UIView *view in self.contentViews)
            {
                CGSize size = [view sizeThatFits:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
                if (size.width > fillSize.width) fillSize.width = size.width;
                if (size.height > fillSize.height) fillSize.height = size.height;
            }
            
            layoutRect.size = fillSize;
            
            if (performLayout)
            {
                for (UIView *view in self.contentViews)
                {
                    view.frame = layoutRect;
                }
            }
            
            return CGSizeMake(self.contentEdgeInsets.left + layoutRect.size.width + self.contentEdgeInsets.right,
                              self.contentEdgeInsets.top + layoutRect.size.height + self.contentEdgeInsets.bottom);
        }
            
        default:
        {
            CGFloat top = self.contentEdgeInsets.top;
            CGFloat left = self.contentEdgeInsets.left;
            CGFloat contentWidth = size.width - (self.contentEdgeInsets.left + self.contentEdgeInsets.right);
            
            for (UIView *view in self.contentViews)
            {
                CGSize size = [view sizeThatFits:CGSizeMake(contentWidth, CGFLOAT_MAX)];
                if (view.hidden) size.height = 0;
                size.width = contentWidth;
                if (performLayout) { view.frame = CGRectMake(left, top, size.width, size.height); }
                if (!view.hidden) top += size.height + self.contentPadding;
            }
            
            return CGSizeMake(size.width, top + self.contentEdgeInsets.bottom - self.contentPadding);
        }
    }
}

- (void)layoutSubviews
{
    self.backgroundImageView.frame = self.bounds;
    self.contentScrollView.frame = self.bounds;
    self.contentScrollView.contentSize = [self sizeForSize:self.bounds.size performLayout:YES];
}

- (CGSize)sizeThatFits:(CGSize)size
{
    if ((self.desiredSize.width == 0) || (self.desiredSize.height == 0)) size = [self sizeForSize:size performLayout:NO];
    if (self.desiredSize.width > 0) size.width = self.desiredSize.width;
    if (self.desiredSize.height > 0) size.height = self.desiredSize.height;
    return size;
}

- (void)hierarchyChanged:(NSNotification *)notification
{
    UIView *view = notification.userInfo[WFSViewsActionNotificationViewKey];
    if (view && [self isDescendantOfView:view])
    {
        [self layoutSubviews];
    }
}

- (UIImage *)backgroundImage
{
    return self.backgroundImageView.image;
}

- (void)setBackgroundImage:(UIImage *)backgroundImage
{
    self.backgroundImageView.image = backgroundImage;
}

@end
