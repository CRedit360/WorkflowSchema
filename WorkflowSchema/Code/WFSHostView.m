//
//  WFSHostView.m
//  WFSWorkflow
//
//  Created by Simon Booth on 15/10/2012.
//  Copyright (c) 2012 CRedit360. All rights reserved.
//

#import "WFSHostView.h"
#import "WFSViewsAction.h"

@interface WFSHostView ()

@end

@implementation WFSHostView

- (id)initWithSchema:(WFSSchema *)schema context:(WFSContext *)context error:(NSError **)outError
{
    NSError *error = nil;
    
    self = [super init];
    if (self)
    {
        self.opaque = YES;
     
        WFS_SCHEMATISING_PROPERTY_INITITIALISATION
        
        if (schema) _hostedElement = [schema createObjectWithContext:context error:&error];
        
        if ([_hostedElement isKindOfClass:[UIViewController class]])
        {
            UIViewController *controller = (UIViewController *)_hostedElement;
            [controller willMoveToParentViewController:context.containerController];
            _hostedView = controller.view;
            [self addSubview:_hostedView];
            [context.containerController addChildViewController:controller];
            [controller didMoveToParentViewController:context.containerController];
            
        }
        else if ([_hostedElement isKindOfClass:[UIView class]])
        {
            _hostedView = (UIView *)_hostedElement;
            [self addSubview:_hostedView];
        }
        else if (schema)
        {
            if (!error) error = WFSError(@"Hosted element of type %@ is not a view or view controller", [_hostedElement class]);
            self = nil;
        }

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hierarchyChanged:) name:WFSViewsActionDidChangeHierarchyNotification object:nil];
    }
    
    if (outError) *outError = error;
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)layoutSubviews
{
    self.hostedView.frame = self.bounds;
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
