//
//  C360DFTContainer.h
//  DynamicFormsTest
//
//  Created by Simon Booth on 10/10/2012.
//  Copyright (c) 2012 CRedit360. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WFSSchematising.h"

typedef enum {
    WFSContainerViewVerticalLayout = 0,
    WFSContainerViewCenterLayout,
    WFSContainerViewFillLayout
} WFSContainerViewLayout;

@interface WFSContainerView : UIView <WFSSchematising>

// Use this instead of addSubview:
- (void)addContentView:(UIView *)view;
@property (nonatomic, strong, readonly) NSArray *contentViews;

@property (nonatomic, assign, readonly) WFSContainerViewLayout layout;

@property (nonatomic, assign) UIEdgeInsets contentEdgeInsets UI_APPEARANCE_SELECTOR;
@property (nonatomic, assign) CGFloat contentPadding UI_APPEARANCE_SELECTOR;

@property (nonatomic, copy) NSString *name;

@end
