//
//  WFSLongPressGestureRecognizer.m
//  WorkflowSchema
//
//  Created by Simon Booth on 29/10/2012.
//  Copyright (c) 2012 CRedit360. All rights reserved.
//

#import "WFSLongPressGestureRecognizer.h"
#import "UIViewController+WFSSchematising.h"

@implementation WFSLongPressGestureRecognizer

- (id)initWithSchema:(WFSSchema *)schema context:(WFSContext *)context error:(NSError **)outError
{
    self = [super init];
    if (self)
    {
        WFS_SCHEMATISING_INITIALISATION
        
        if (!self.beginActionName && !self.endActionName)
        {
            if (outError) *outError = WFSError(@"Long press must have a begin or end action");
            return nil;
        }
        
        [self addTarget:self action:@selector(handleWorkflowLongPress:)];
    }
    return self;
}

+ (NSDictionary *)schemaParameterTypes
{
    return [[super schemaParameterTypes] dictionaryByAddingEntriesFromDictionary:@{
            
    @"beginActionName" : [NSString class],
    @"endActionName" : [NSString class],
    @"numberOfTapsRequired" : @[ [NSString class], [NSNumber class] ],
    @"numberOfTouchesRequired" : @[ [NSString class], [NSNumber class] ],
    @"minimumPressDuration" : @[ [NSString class], [NSNumber class] ],
    @"allowableMovement" : @[ [NSString class], [NSNumber class] ]

    }];
}

- (void)handleWorkflowLongPress:(WFSLongPressGestureRecognizer *)sender
{
    switch (sender.state) {
        case UIGestureRecognizerStateBegan:
        {
            WFSMutableContext *context = [self.workflowContext mutableCopy];
            context.actionSender = sender.view;
            WFSMessage *message = [WFSMessage actionMessageWithName:self.beginActionName context:context];
            [context sendWorkflowMessage:message];
            break;
        }
            
        case UIGestureRecognizerStateEnded:
        {
            WFSMutableContext *context = [self.workflowContext mutableCopy];
            context.actionSender = sender.view;
            WFSMessage *message = [WFSMessage actionMessageWithName:self.endActionName context:context];
            [context sendWorkflowMessage:message];
            break;
        }
            
        default:
            break;
    }
    
}

@end
