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

@property (nonatomic, strong) id message;
@property (nonatomic, strong) NSString *detailDisclosureMessage;
@property (nonatomic, copy, readwrite) NSString *name;
@property (nonatomic, assign, getter = isSelectable) BOOL selectable;

@end
