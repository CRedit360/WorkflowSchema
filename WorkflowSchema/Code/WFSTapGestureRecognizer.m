//
//  WFSTapGestureRecognizer.m
//  WorkflowSchema
//
//  Created by Simon Booth on 29/10/2012.
//  Copyright (c) 2012 CRedit360. All rights reserved.
//

#import "WFSTapGestureRecognizer.h"
#import "WFSSchematising.h"

@implementation WFSTapGestureRecognizer

- (id)initWithSchema:(WFSSchema *)schema context:(WFSContext *)context error:(NSError **)outError
{
    self = [super init];
    if (self)
    {
        WFS_SCHEMATISING_INITIALISATION
        
        [self addTarget:self action:@selector(handleWorkflowSwipe:)];
    }
    return self;
}

+ (NSArray *)mandatorySchemaParameters
{
    return [[super mandatorySchemaParameters] arrayByPrependingObject:@"message"];
}

+ (NSArray *)lazilyCreatedSchemaParameters
{
    return [[super lazilyCreatedSchemaParameters] arrayByPrependingObject:@"message"];
}


+ (NSDictionary *)schemaParameterTypes
{
    return [[super schemaParameterTypes] dictionaryByAddingEntriesFromDictionary:@{
            
            @"message" : @[ [WFSMessage class], [NSString class] ],
            @"numberOfTapsRequired" : @[ [NSString class], [NSNumber class] ],
            @"numberOfTouchesRequired" : @[ [NSString class], [NSNumber class] ]

    }];
}

- (void)handleWorkflowSwipe:(WFSTapGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateRecognized)
    {
        WFSMutableContext *context = [self.workflowContext mutableCopy];
        context.actionSender = sender.view;
        [self sendMessageFromParameterWithName:@"message" context:context];
    }
}

@end
