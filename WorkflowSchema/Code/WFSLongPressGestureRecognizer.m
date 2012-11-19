//
//  WFSLongPressGestureRecognizer.m
//  WorkflowSchema
//
//  Created by Simon Booth on 29/10/2012.
//  Copyright (c) 2012 CRedit360. All rights reserved.
//

#import "WFSLongPressGestureRecognizer.h"
#import "WFSSchematising.h"

@implementation WFSLongPressGestureRecognizer

- (id)initWithSchema:(WFSSchema *)schema context:(WFSContext *)context error:(NSError **)outError
{
    self = [super init];
    if (self)
    {
        WFS_SCHEMATISING_INITIALISATION
        
        if (!self.beginMessage && !self.endMessage)
        {
            if (outError) *outError = WFSError(@"Long press must have a begin or end message");
            return nil;
        }
        
        [self addTarget:self action:@selector(handleWorkflowLongPress:)];
    }
    return self;
}

+ (NSArray *)lazilyCreatedSchemaParameters
{
    return [[super lazilyCreatedSchemaParameters] arrayByPrependingObjectsFromArray:@[ @"beginMessage", @"endMessage" ]];
}

+ (NSDictionary *)schemaParameterTypes
{
    return [[super schemaParameterTypes] dictionaryByAddingEntriesFromDictionary:@{
            
            @"beginMessage"            : @[ [WFSMessage class], [NSString class] ],
            @"endMessage"              : @[ [WFSMessage class], [NSString class] ],
            @"numberOfTapsRequired"    : @[ [NSString class], [NSNumber class] ],
            @"numberOfTouchesRequired" : @[ [NSString class], [NSNumber class] ],
            @"minimumPressDuration"    : @[ [NSString class], [NSNumber class] ],
            @"allowableMovement"       : @[ [NSString class], [NSNumber class] ]

    }];
}

- (void)handleWorkflowLongPress:(WFSLongPressGestureRecognizer *)sender
{
    switch (sender.state) {
        case UIGestureRecognizerStateBegan:
        {
            WFSMutableContext *context = [self.workflowContext mutableCopy];
            context.actionSender = sender.view;
            if (self.beginMessage) [self sendMessageFromParameterWithName:@"beginMessage" context:context];
            break;
        }
            
        case UIGestureRecognizerStateEnded:
        {
            WFSMutableContext *context = [self.workflowContext mutableCopy];
            context.actionSender = sender.view;
            if (self.endMessage) [self sendMessageFromParameterWithName:@"endMessage" context:context];
            break;
        }
            
        default:
            break;
    }
    
}

@end
