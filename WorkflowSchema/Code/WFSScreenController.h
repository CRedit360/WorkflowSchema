//
// RUIRemoteController.h.h
// 
// Created on 2012-10-11 using NibFree
// 

#import <UIKit/UIKit.h>
#import "WFSSchematising.h"
#import "WFSScreenView.h"

extern NSString * const WFSScreenMessageType;

@interface WFSScreenController : UIViewController <WFSSchematising, WFSContextDelegate>

@property (nonatomic, retain) NSArray *actions;

@property (nonatomic, strong, readonly) WFSScreenView *screenView;

@end
