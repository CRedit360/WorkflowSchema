//
//  WFSTableViewController.h
//  WFSWorkflow
//
//  Created by Simon Booth on 17/10/2012.
//  Copyright (c) 2012 CRedit360. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WFSSchematising.h"

extern NSString * const WFSTableMessageType;

@interface WFSTableController : UITableViewController <WFSSchematising>

@property (nonatomic, strong) id sections;

- (void)reloadData;

@end