//
//  WFSButtonItem.h
//  WorkflowSchema
//
//  Created by Simon Booth on 21/10/2012.
//  Copyright (c) 2012 CRedit360. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WFSSchematising.h"
#import "WFSAction.h"

@interface WFSActionButtonItem : NSObject <WFSSchematising>

@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) NSString *actionName;
@property (nonatomic, assign) NSInteger index;

@end

@interface WFSCancelButtonItem : WFSActionButtonItem; @end
@interface WFSDestructiveButtonItem : WFSActionButtonItem; @end