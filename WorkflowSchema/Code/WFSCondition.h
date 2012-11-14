//
//  WFSValidateAction.h
//  WFSWorkflow
//
//  Created by Simon Booth on 16/10/2012.
//  Copyright (c) 2012 CRedit360. All rights reserved.
//

#import "WFSSchematising.h"
#import "WFSAction.h"

@interface WFSCondition : NSObject <WFSSchematising>

@property (nonatomic, strong) NSString *failureMessage; // Used in form validations
@property (nonatomic, strong) WFSSchema *value;

- (BOOL)evaluateWithContext:(WFSContext *)context;
- (BOOL)evaluateWithValue:(id)value context:(WFSContext *)context;

@end
