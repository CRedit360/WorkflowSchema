//
//  WFSTableCellSchematising.h
//  WFSWorkflow
//
//  Created by Simon Booth on 18/10/2012.
//  Copyright (c) 2012 CRedit360. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WFSSchematising.h"
#import "WFSAction.h"

@protocol WFSTableCellSchematising <WFSSchematising>

@property (nonatomic, strong) id message;
@property (nonatomic, strong) id detailDisclosureMessage;
@property (nonatomic, assign, getter = isSelectable) BOOL selectable;

@end