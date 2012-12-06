//
//  WFSContext.h
//  WFSWorkflow
//
//  Created by Simon Booth on 15/10/2012.
//  Copyright (c) 2012 CRedit360. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WFSSchema;
@class WFSResult;
@class WFSMessage;

@protocol WFSSchematising;
@protocol WFSSchemaDelegate;
@protocol WFSContextDelegate;

extern NSString * const WFSContextException;

@interface WFSContext : NSObject <NSCopying, NSMutableCopying>

+ (WFSContext *)contextWithDelegate:(id<WFSContextDelegate>)delegate;
- (id)initWithDelegate:(id<WFSContextDelegate>)delegate;

@property (nonatomic, strong, readonly) NSDictionary *userInfo;

@property (nonatomic, weak, readonly) id actionSender; // A view or bar item to be used by actions when e.g. showing action sheets

@property (nonatomic, weak, readonly) UIViewController *containerController; // To be used when adding a child controller to a container

@property (nonatomic, weak, readonly) id<WFSContextDelegate> contextDelegate; // Delegate for context operations e.g. message passing
@property (nonatomic, weak, readonly) id<WFSSchemaDelegate> schemaDelegate; // Delegate for schema operations e.g. object creation

- (void)sendWorkflowError:(NSError *)error;
- (BOOL)sendWorkflowMessage:(WFSMessage *)message;

@end

@interface WFSMutableContext : WFSContext

@property (nonatomic, strong, readwrite) NSDictionary *userInfo;

@property (nonatomic, weak, readwrite) id actionSender;
@property (nonatomic, weak, readwrite) UIViewController *containerController;

@property (nonatomic, weak, readwrite) id<WFSContextDelegate> contextDelegate;
@property (nonatomic, weak, readwrite) id<WFSSchemaDelegate> schemaDelegate;

@end

@protocol WFSContextDelegate <NSObject>

/*
 *  This is called when an unrecoverable error occurs.  Implementing apps are advised to use this
 *  to give the user the information they need to put together a support request.
 */
- (void)context:(WFSContext *)context didReceiveWorkflowError:(NSError *)error;

/*
 *  This is called when the workflow wants a message handled.  Implementors should either return NO
 *  to say that the message cannot be handled, or YES to say that it can; if they return YES then they
 *  MUST eventually call -respondWithResult: on the message that is passed.  This can occur later if
 *  e.g. asynchronouse communication is required.  -respondWithResult: can be called safely from any queue.
 */
- (BOOL)context:(WFSContext *)context didReceiveWorkflowMessage:(WFSMessage *)message;

@end