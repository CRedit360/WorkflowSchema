//
//  WFSTabBarController.h
//  WFSWorkflow
//
//  Created by Simon Booth on 15/10/2012.
//  Copyright (c) 2012 CRedit360. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WFSSchematising.h"

@interface WFSTabBarController : UITabBarController <WFSSchematising, WFSContextDelegate>

@property (nonatomic, retain) NSArray *actions;

@end
