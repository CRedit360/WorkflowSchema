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
    WFSContainerViewVerticalLayout = 0, // Lay out one after another, vertically, at preferred size for width, separated by contentPadding
    WFSContainerViewCenterLayout,       // Size all to fit and show in center
    WFSContainerViewFillLayout          // Fill the available space. If there is not enough room for one, expand all to right or bottom.
} WFSContainerViewLayout;

@interface WFSContainerView : UIView <WFSSchematising>

// Use this instead of addSubview:
- (void)addContentView:(UIView *)view;
@property (nonatomic, strong, readonly) NSArray *contentViews;

@property (nonatomic, assign, readonly) WFSContainerViewLayout layout;

@property (nonatomic, assign) UIEdgeInsets contentEdgeInsets UI_APPEARANCE_SELECTOR;
@property (nonatomic, assign) CGFloat contentPadding UI_APPEARANCE_SELECTOR;
@property (nonatomic, assign) CGSize desiredSize UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIImage *backgroundImage UI_APPEARANCE_SELECTOR;

@end
