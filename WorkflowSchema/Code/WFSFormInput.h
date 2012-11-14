//
//  WFSFormInput.h
//  WFSWorkflow
//
//  Created by Simon Booth on 15/10/2012.
//  Copyright (c) 2012 CRedit360. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WFSSchematising.h"

@protocol WFSFormInputDelegate;

@protocol WFSFormInput <WFSSchematising>

@property (nonatomic, strong, readonly) id formValue; // this MUST NOT return nil

@property (nonatomic, strong, readonly) NSArray *validations;

@property (nonatomic, weak) id<WFSFormInputDelegate> formInputDelegate;

@end

@protocol WFSResponsiveInput <WFSFormInput>

- (BOOL)canBecomeFirstResponder;
- (BOOL)becomeFirstResponder;

@end

@protocol WFSFormInputDelegate <NSObject>

- (BOOL)formInputShouldReturn:(id<WFSFormInput>)formInput;
- (void)formInputDidEndEditing:(id<WFSFormInput>)formInput;

@end