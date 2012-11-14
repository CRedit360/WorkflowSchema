//
//  WFSHostView.h
//  WFSWorkflow
//
//  Created by Simon Booth on 15/10/2012.
//  Copyright (c) 2012 CRedit360. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WFSSchematising.h"

@interface WFSHostView : UIView <WFSSchematising>

@property (nonatomic, strong, readonly) id<WFSSchematising> hostedElement;
@property (nonatomic, strong, readonly) UIView *hostedView;

@end
