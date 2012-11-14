//
//  WFSTableCell.h
//  WFSWorkflow
//
//  Created by Simon Booth on 18/10/2012.
//  Copyright (c) 2012 CRedit360. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WFSTableCellSchematising.h"
#import "WFSAction.h"

@interface WFSTableCell : UITableViewCell <WFSTableCellSchematising>

@property (nonatomic, assign, readonly) UITableViewCellStyle style;

@property (nonatomic, strong) NSString *actionName;
@property (nonatomic, strong) NSString *detailDisclosureActionName;
@property (nonatomic, copy, readwrite) NSString *name;

@end
