//
// RUIRemoteController.h.h
// 
// Created on 2012-10-11 using NibFree
// 

#import <UIKit/UIKit.h>
#import "WFSSchematising.h"
#import "WFSScreenView.h"

@interface WFSScreenController : UIViewController <WFSSchematising, WFSContextDelegate>

@property (nonatomic, retain) NSArray *actions;

@property (nonatomic, strong) WFSScreenView *screenView;
@property (nonatomic, strong) WFSToolbar *toolbar;

@end
