//
//  NSObject+WorkflowSchema.h
//  WorkflowSchema
//
//  Created by Simon Booth on 13/11/2012.
//  Copyright (c) 2012 CRedit360. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WFSContext;
@class WFSMessage;

@interface NSObject (WorkflowSchema)

- (NSArray *)flattenedArray;

- (WFSMessage *)messageFromParameterWithName:(NSString *)name context:(WFSContext *)context;
- (void)sendMessageFromParameterWithName:(NSString *)name context:(WFSContext *)context;


@end
