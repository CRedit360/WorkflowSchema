//
//  WFSSchema+DTCoreText.m
//  WorkflowSchema+DTCoreText
//
//  Created by Simon Booth on 28/11/2012.
//  Copyright (c) 2012 CRedit360. All rights reserved.
//

#import "WFSSchema+DTCoreText.h"
#import "WorkflowSchema+DTCoreText.h"

@implementation WFSSchema (DTCoreText)

+ (void)load
{
    [self registerClass:[DTAttributedTextView class] forTypeName:@"attributedTextView"];
}

@end
