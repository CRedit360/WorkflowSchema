//
//  WFSAlertAction.h
//  WFSWorkflow
//
//  Created by Simon Booth on 16/10/2012.
//  Copyright (c) 2012 CRedit360. All rights reserved.
//

#import "WFSAction.h"
#import "WFSActionButtonItem.h"

@interface WFSShowAlertAction : WFSAction <UIAlertViewDelegate>

@property (nonatomic, strong) id title;
@property (nonatomic, strong) id message;
@property (nonatomic, strong) WFSActionButtonItem *cancelButtonItem;
@property (nonatomic, strong) NSArray *otherButtonItems;

- (UIAlertView *)alertViewWithContext:(WFSContext *)context error:(NSError **)outError;

@end
