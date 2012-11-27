//
//  WFSBarButtonItem.h
//  WFSWorkflow
//
//  Created by Simon Booth on 17/10/2012.
//  Copyright (c) 2012 CRedit360. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WFSAction.h"

@interface WFSBarButtonItem : UIBarButtonItem <WFSSchematising>

@property (nonatomic, strong) id message;

@end
