//
// RUIRemoteView.h.h
// 
// Created on 2012-10-11 using NibFree
// 

#import <UIKit/UIKit.h>
#import "WFSHostView.h"
#import "WFSToolbar.h"

@interface WFSScreenView : WFSHostView

@property (nonatomic, strong) WFSToolbar *toolbar;

@property (nonatomic, assign) UIInterfaceOrientation interfaceOrientation;
@property (nonatomic, strong) UIImage *backgroundImage UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIImage *portraitBackgroundImage UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIImage *landscapeBackgroundImage UI_APPEARANCE_SELECTOR;

@end


