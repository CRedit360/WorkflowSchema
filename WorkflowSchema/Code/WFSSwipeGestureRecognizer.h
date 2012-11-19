//
//  WFSSwipeGestureRecognizer.h
//  WorkflowSchema
//
//  Created by Simon Booth on 29/10/2012.
//  Copyright (c) 2012 CRedit360. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WFSSchematising.h"
#import "WFSAction.h"

@interface WFSSwipeGestureRecognizer : UISwipeGestureRecognizer <WFSSchematising>

@property (nonatomic, strong) id message;

@end
