//
//  WFSActionSheetAction.h
//  WFSWorkflow
//
//  Created by Simon Booth on 16/10/2012.
//  Copyright (c) 2012 CRedit360. All rights reserved.
//

#import "WFSAction.h"
#import "WFSActionButtonItem.h"

@interface WFSShowActionSheetAction : WFSAction <UIActionSheetDelegate>

@property (nonatomic, strong) id title;
@property (nonatomic, strong) WFSActionButtonItem *cancelButtonItem;
@property (nonatomic, strong) WFSActionButtonItem *destructiveButtonItem;
@property (nonatomic, strong) NSArray *otherButtonItems;

- (UIActionSheet *)actionSheetWithContext:(WFSContext *)context error:(NSError **)outError;

@end
