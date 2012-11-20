//
//  NSObject+WorkflowSchema.m
//  WorkflowSchema
//
//  Created by Simon Booth on 13/11/2012.
//  Copyright (c) 2012 CRedit360. All rights reserved.
//

#import "NSObject+WorkflowSchema.h"
#import "WFSMessage.h"
#import "WFSContext.h"

@implementation NSObject (WorkflowSchema)

- (NSArray *)flattenedArray
{
    return @[ self ];
}

#pragma mark - Message sending

- (WFSMessage *)messageFromParameterWithName:(NSString *)name context:(WFSContext *)context
{
    NSError *error = nil;
    id message = [self schemaParameterWithName:name context:context error:&error];
    if ([message isKindOfClass:[NSString class]])
    {
        message = [WFSMessage messageWithName:message context:context responseHandler:nil];
    }
    
    if ([message isKindOfClass:[WFSMessage class]])
    {
        return message;
    }
    else
    {
        if (!error) error = WFSError(@"Could not find message for parameter %@", name);
        [context sendWorkflowError:error];
        return nil;
    }
}

- (void)sendMessageFromParameterWithName:(NSString *)name context:(id)context
{
    WFSMessage *message = [self messageFromParameterWithName:name context:context];
    if (message) [context sendWorkflowMessage:message];
}


@end
