//
//  WFSNavigationItem.h
//  WFSWorkflow
//
//  Created by Simon Booth on 17/10/2012.
//  Copyright (c) 2012 CRedit360. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WFSSchematising.h"

@interface WFSNavigationItemHelper : NSObject

@property (nonatomic, weak) UINavigationItem *navigationItem;
- (id)initWithNavigationItem:(UINavigationItem *)navigationItem;

- (BOOL)setupNavigationItemForSchema:(WFSSchema *)schema context:(WFSContext *)context value:(WFSSchema *)value error:(NSError **)outError;

@end
