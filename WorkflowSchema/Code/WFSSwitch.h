//
//  WFSSwitch.h
//  WorkflowSchema
//
//  Created by Simon Booth on 03/12/2012.
//  Copyright (c) 2012 CRedit360. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WFSSchematising.h"
#import "WFSFormInput.h"

@interface WFSSwitch : UISwitch <WFSSchematising, WFSFormInput>

@property (nonatomic, strong, readonly) id formValue;
@property (nonatomic, strong) NSArray *validations;
@property (nonatomic, weak) id<WFSFormInputDelegate> formInputDelegate;

@property (nonatomic, strong) id message;

@property (nonatomic, strong) NSObject *onValue;
@property (nonatomic, strong) NSObject *offValue;

@end
