//
// WFSFormController.h.h
// 
// Created on 2012-10-15 using NibFree
// 

#import <UIKit/UIKit.h>
#import "UIViewController+WFSSchematising.h"
#import "WFSSchematising.h"
#import "WFSAction.h"
#import "WFSFormView.h"
#import "WFSFormInput.h"

// some messages are special-cased for forms
extern NSString * const WFSFormSubmitMessageName;

// A submitted form will try to perform one of didSubmit or didNotSubmit.
extern NSString * const WFSFormDidSubmitActionName;
extern NSString * const WFSFormDidNotSubmitActionName;

@interface WFSFormController : UIViewController <WFSSchematising, WFSContextDelegate>

@property (nonatomic, strong) NSArray *triggers;

@property (nonatomic, strong, readonly) WFSFormView *formView;

@property (nonatomic, strong, readonly) NSArray *allInputs;
@property (nonatomic, strong, readonly) NSArray *responsiveInputs;
@property (nonatomic, strong, readonly) NSDictionary *namedInputs;

@end
