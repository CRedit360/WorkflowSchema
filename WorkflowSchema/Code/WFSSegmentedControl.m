//
//  WFSSegmentedControl.m
//  WorkflowSchema
//
//  Created by Simon Booth on 27/11/2012.
//  Copyright (c) 2012 CRedit360. All rights reserved.
//

#import "WFSSegmentedControl.h"

@interface WFSSegmentedControl ()

@property (nonatomic, strong) NSArray *workflowSegments;

@end

@implementation WFSSegmentedControl

- (id)initWithSchema:(WFSSchema *)schema context:(WFSContext *)context error:(NSError **)outError
{
    self = [super initWithItems:@[]];
    if (self)
    {
        WFS_SCHEMATISING_INITIALISATION;
        
        [self addTarget:self action:@selector(changed:) forControlEvents:UIControlEventValueChanged];
    }
    return self;
}

+ (NSArray *)arraySchemaParameters
{
    return [[super arraySchemaParameters] arrayByAddingObject:@"segments"];
}

+ (NSDictionary *)enumeratedSchemaParameters
{
    return [[super enumeratedSchemaParameters] dictionaryByAddingEntriesFromDictionary:@{
            
            @"segmentedControlStyle" : @{
            
                    @"plain"    : @(UISegmentedControlStylePlain),
                    @"bordered" : @(UISegmentedControlStyleBordered),
                    @"bar"      : @(UISegmentedControlStyleBar)
            
            }
            
    }];
}

+ (NSArray *)defaultSchemaParameters
{
    return [[super defaultSchemaParameters] arrayByPrependingObject:@[ [WFSSegment class], @"segments" ]];
}

+ (NSDictionary *)schemaParameterTypes
{
    return [[super schemaParameterTypes] dictionaryByAddingEntriesFromDictionary:@{
            
            @"apportionsSegmentWidthsByContent" : @[ [NSString class], [NSNumber class] ],
            @"momentary"                        : @[ [NSString class], [NSNumber class] ],
            @"segments"                         : [WFSSegment class],
            @"segmentedControlStyle"            : @[ [NSString class], [NSNumber class] ],
            @"selectedSegmentIndex"             : @[ [NSString class], [NSNumber class] ]
                        
    }];
}

- (BOOL)setSchemaParameterWithName:(NSString *)name value:(id)value context:(WFSContext *)context error:(NSError **)outError
{
    if ([name isEqual:@"segments"])
    {
        self.workflowSegments = value;
        [self removeAllSegments];
        
        for (WFSSegment *segment in self.workflowSegments)
        {
            NSInteger index = self.numberOfSegments;
            
            if (segment.image) [self insertSegmentWithImage:segment.image atIndex:index animated:NO];
            else [self insertSegmentWithTitle:segment.title atIndex:index animated:NO];
            
            [self setEnabled:segment.enabled forSegmentAtIndex:index];
        }
        
        return YES;
    }
    
    return [super setSchemaParameterWithName:name value:value context:context error:outError];
}

- (void)changed:(id)sender
{
    WFSSegment *segment = self.workflowSegments[self.selectedSegmentIndex];
    if (segment.message)
    {
        WFSMutableContext *context = [self.workflowContext mutableCopy];
        context.actionSender = sender;
        [segment sendMessageFromParameterWithName:@"message" context:context];
    }
}

@end
