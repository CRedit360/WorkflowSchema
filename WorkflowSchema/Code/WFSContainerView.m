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

- (CGSize)sizeForWidth:(CGFloat)width performLayout:(BOOL)performLayout
{
    switch (self.layout)
    {
        case WFSContainerViewCenterLayout:
        {
            CGRect layoutRect = UIEdgeInsetsInsetRect(self.bounds, self.contentEdgeInsets);

            for (UIView *view in self.contentViews)
            {
                if (performLayout)
                {
                    [view sizeToFit];
                    view.center = self.contentScrollView.center; // Strictly we should calculate this in the CSV's bounds, but it fills this view so this gives us the right answer
                }
            }
            
            return layoutRect.size;
        }
            
        case WFSContainerViewFillLayout:
        {
            CGRect layoutRect = UIEdgeInsetsInsetRect(self.bounds, self.contentEdgeInsets);
            
            for (UIView *view in self.contentViews)
            {
                if (performLayout)
                {
                    [view sizeToFit];
                    view.frame = layoutRect;
                }
            }
            
            return layoutRect.size;
        }
            
        default:
        {
            CGFloat top = self.contentEdgeInsets.top;
            CGFloat left = self.contentEdgeInsets.left;
            CGFloat contentWidth = width - (self.contentEdgeInsets.left + self.contentEdgeInsets.right);
            
            for (UIView *view in self.contentViews)
            {
                CGSize size = [view sizeThatFits:CGSizeMake(contentWidth, CGFLOAT_MAX)];
                if (view.hidden) size.height = 0;
                size.width = contentWidth;
                if (performLayout) { view.frame = CGRectMake(left, top, size.width, size.height); }
                if (!view.hidden) top += size.height + self.contentPadding;
            }
            
            return CGSizeMake(width, top + self.contentEdgeInsets.bottom - self.contentPadding);
        }
    }
}

- (void)layoutSubviews
{
    self.contentScrollView.frame = self.bounds;
    self.contentScrollView.contentSize = [self sizeForWidth:self.bounds.size.width performLayout:YES];
}

- (CGSize)sizeThatFits:(CGSize)size
{
    return [self sizeForWidth:size.width performLayout:NO];
}

- (void)hierarchyChanged:(NSNotification *)notification
{
    UIView *view = notification.userInfo[WFSViewsActionNotificationViewKey];
    if (view && [self isDescendantOfView:view])
    {
        [self layoutSubviews];
    }
}

@end
