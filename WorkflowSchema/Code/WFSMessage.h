//
//  WFSMessage.h
//  WorkflowSchema
//
//  Created by Simon Booth on 29/10/2012.
//  Copyright (c) 2012 CRedit360. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WFSSchematising.h"

extern NSString * const WFSMessageErrorKey;

typedef enum {
    
    WFSMessageDestinationDelegate = 0, // The message should be sent to the sender's immediate workflow delegate. destinationName is ignored.
    WFSMessageDestinationRootDelegate, // The message should be sent to the root delegate of the workflow. destinationName is interpreted by that delegate.
    WFSMessageDestinationSelf,         // The message should be sent to the sender. destinationName is ignored.
    WFSMessageDestinationDescendant    // The message should be sent to the descendant of the sender with the name given by destinationName. Behaviour is undefined if there are multiple such descendants.
    
} WFSMessageDestinationType;

typedef void(^WFSMessageResponseHandler)(WFSResult *result);

@interface WFSMessage : NSObject <WFSSchematising>

/*
 *  The name of the message to be sent, e.g. didSubmit or shouldLoad
 */
@property (nonatomic, copy) NSString *name;

/*
 *  Where the message should be sent.  See WFSMessageDestinationType for details.
 */
@property (nonatomic, assign) WFSMessageDestinationType destinationType;

/*
 *  Who the message should be sent to.  What this means depends on the destination type; see WFSMessageDestinationType for details.
 */
@property (nonatomic, copy) NSString *destinationName;

/*
 *  A callback which is called with the reponse to the message
 */
@property (nonatomic, copy) WFSMessageResponseHandler responseHandler;

/*
 *  The context in which the message is sent. Its parameters may be used to respond to the message.
 */
@property (nonatomic, strong) WFSContext *context;

- (id)initWithName:(NSString *)name context:(WFSContext *)context responseHandler:(WFSMessageResponseHandler)responseHandler;
- (id)initWithName:(NSString *)name destinationType:(WFSMessageDestinationType)destinationType destinationName:(NSString *)destinationName context:(WFSContext *)context responseHandler:(WFSMessageResponseHandler)responseHandler;

+ (WFSMessage *)messageWithName:(NSString *)name context:(WFSContext *)context responseHandler:(WFSMessageResponseHandler)responseHandler;
+ (WFSMessage *)messageWithName:(NSString *)name destinationType:(WFSMessageDestinationType)destinationType destinationName:(NSString *)destinationName context:(WFSContext *)context responseHandler:(WFSMessageResponseHandler)responseHandler;

- (void)respondWithResult:(WFSResult *)result;
- (void)respondWithError:(NSError *)error context:(WFSContext *)context;

@end
