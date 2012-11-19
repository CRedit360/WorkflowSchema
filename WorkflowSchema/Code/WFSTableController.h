//
//  WFSTableViewController.h
//  WFSWorkflow
//
//  Created by Simon Booth on 17/10/2012.
//  Copyright (c) 2012 CRedit360. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WFSSchematising.h"

extern NSString * const WFSTableMessageTarget;
extern NSString * const WFSTableDidSelectCellActionName;

@interface WFSTableController : UITableViewController <WFSSchematising>

@property (nonatomic, strong) id tableHeaderView;
@property (nonatomic, strong) id sections;
@property (nonatomic, strong) id tableFooterView;

- (void)reloadData;

@end