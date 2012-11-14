//
//  WFSTabBarController.h
//  WFSWorkflow
//
//  Created by Simon Booth on 15/10/2012.
//  Copyright (c) 2012 CRedit360. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WFSSchematising.h"

extern NSString * const WFSTabsMessageType;

@interface WFSTabBarController : UITabBarController <WFSSchematising, WFSContextDelegate>

@property (nonatomic, retain) NSArray *actions;

@end
