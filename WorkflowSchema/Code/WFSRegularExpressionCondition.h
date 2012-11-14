//
//  WFSRegularExpressionCondition.h
//  WFSWorkflow
//
//  Created by Simon Booth on 16/10/2012.
//  Copyright (c) 2012 CRedit360. All rights reserved.
//

#import "WFSCondition.h"

@interface WFSRegularExpressionCondition : WFSCondition

@property (nonatomic, strong, readonly) NSString *pattern;
@property (nonatomic, strong, readonly) NSRegularExpression *patternRegex;

@end
