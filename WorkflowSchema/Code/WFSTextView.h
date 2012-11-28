//
//  WFSTextView.h
//  WorkflowSchema
//
//  Created by Simon Booth on 28/11/2012.
//  Copyright (c) 2012 CRedit360. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WFSSchematising.h"
#import "WFSFormInput.h"

@interface WFSTextView : UITextView <WFSSchematising, WFSFormInput>

@property (nonatomic, strong, readonly) id formValue;
@property (nonatomic, strong) NSArray *validations;
@property (nonatomic, weak) id<WFSFormInputDelegate> formInputDelegate;

@end
