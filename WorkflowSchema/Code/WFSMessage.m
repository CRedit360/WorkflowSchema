//
//  WFSMessage.m
//  WorkflowSchema
//
//  Created by Simon Booth on 29/10/2012.
//  Copyright (c) 2012 CRedit360. All rights reserved.
//

#import "WFSMessage.h"
#import "WFSContext.h"
#import "WFSResult.h"

@implementation WFSMessage

+ (WFSMessage *)messageWithTarget:(NSString *)target name:(NSString *)name context:(WFSContext *)context responseHandler:(WFSMessageResponseHandler)responseHandler
{
    return [[self alloc] initWithTarget:target name:name context:context responseHandler:responseHandler];
}

- (id)initWithTarget:(NSString *)target name:(NSString *)name context:(WFSContext *)context responseHandler:(WFSMessageResponseHandler)responseHandler
{
    self = [super init];
    if (self)
    {
        _target = [target copy];
        _name = [name copy];
        _context = context;
        _responseHandler = [responseHandler copy];
    }
    return self;
}

- (void)respondWithResult:(WFSResult *)result
{
    __block WFSMessageResponseHandler handler = self.responseHandler;
    if (!handler) return;
    
    dispatch_queue_t main_queue = dispatch_get_main_queue();
    dispatch_queue_t this_queue = dispatch_get_current_queue();
    
    if (this_queue == main_queue)
    {
        handler(result);
    }
    else
    {
        dispatch_async(main_queue, ^{
            handler(result);
        });
    }
}

@end
