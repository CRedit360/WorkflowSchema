//
//  WFSSlider.m
//  WorkflowSchema
//
//  Created by Simon Booth on 26/11/2012.
//  Copyright (c) 2012 CRedit360. All rights reserved.
//

#import "WFSSlider.h"
#import "WFSMessage.h"

@implementation WFSSlider

- (id)initWithSchema:(WFSSchema *)schema context:(WFSContext *)context error:(NSError **)outError
{
    self = [super initWithSchema:schema context:context error:outError];
    if (self)
    {
        [self addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return self;
}

+ (NSArray *)mandatorySchemaParameters
{
    return [[super mandatorySchemaParameters] arrayByAddingObject:@"accessibilityLabel"];
}

+ (NSDictionary *)schemaParameterTypes
{
    return [[super schemaParameterTypes] dictionaryByAddingEntriesFromDictionary:@{
            
            @"continuous"        : @[ [NSString class], [NSNumber class] ],
            @"value"             : @[ [NSString class], [NSNumber class] ],
            @"minimumValue"      : @[ [NSString class], [NSNumber class] ],
            @"maximumValue"      : @[ [NSString class], [NSNumber class] ],
            @"message"           : @[ [WFSMessage class], [NSString class] ]
            
    }];
}

- (id)formValue
{
    return @(self.value);
}

- (void)valueChanged:(id)sender
{
    WFSMutableContext *context = [self.workflowContext mutableCopy];
    context.actionSender = sender;
    [self sendMessageFromParameterWithName:@"message" context:context];
}

@end
