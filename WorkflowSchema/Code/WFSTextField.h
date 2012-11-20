//
//  C360LTTextField.h
//  LoginTest
//
//  Created by Simon Booth on 04/10/2012.
//  Copyright (c) 2012 CRedit360. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WFSSchematising.h"
#import "WFSFormInput.h"
#import "UIView+WorkflowSchema.h"

@interface WFSTextField : UITextField <WFSSchematising, WFSResponsiveInput>

@property (nonatomic, strong, readonly) id formValue;
@property (nonatomic, strong) NSArray *validations;
@property (nonatomic, weak) id<WFSFormInputDelegate> formInputDelegate;

@property (nonatomic, strong) UIImage *backgroundImage UI_APPEARANCE_SELECTOR; // UITextField misnames this as 'background'
@property (nonatomic, assign) UIEdgeInsets textInsets UI_APPEARANCE_SELECTOR; // default is 4,8,4,8


@end
