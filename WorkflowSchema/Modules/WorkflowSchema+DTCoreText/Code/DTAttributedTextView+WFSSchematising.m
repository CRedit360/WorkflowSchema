//
//  DTAttributedTextView+WFSSchematising.m
//  WorkflowSchema+DTCoreText
//
//  Created by Simon Booth on 28/11/2012.
//  Copyright (c) 2012 CRedit360. All rights reserved.
//

#import "DTAttributedTextView+WFSSchematising.h"

@implementation DTAttributedTextView (WFSSchematising)

- (id)initWithSchema:(WFSSchema *)schema context:(WFSContext *)context error:(NSError **)outError
{
    self = [super initWithSchema:schema context:context error:outError];
    if (self)
    {
        self.isAccessibilityElement = YES;
        
        if (!self.accessibilityLabel)
        {
            self.accessibilityLabel = [self.attributedString string];
        }
    }
    return self;
}

+ (NSArray *)mandatorySchemaParameters
{
    return [[super mandatorySchemaParameters] arrayByAddingObject:@"attributedString"];
}

+ (NSArray *)defaultSchemaParameters
{
    return [[super mandatorySchemaParameters] arrayByPrependingObjectsFromArray:@[
            
            @[ [NSAttributedString class], @"attributedString" ],
            @[ [NSString class], @"attributedString" ]
            
    ]];
}

+ (NSDictionary *)schemaParameterTypes
{
    return [[super schemaParameterTypes] dictionaryByAddingEntriesFromDictionary:@{
            
            @"attributedString" : @[ [NSAttributedString class], [NSString class] ]
            
    }];
}

- (BOOL)setSchemaParameterWithName:(NSString *)name value:(id)value context:(WFSContext *)context error:(NSError **)outError
{
    if ([name isEqualToString:@"attributedString"] && [value isKindOfClass:[NSString class]])
    {
        NSData *data = [value dataUsingEncoding:NSUTF8StringEncoding];
        value = [[NSAttributedString alloc] initWithHTMLData:data documentAttributes:nil];
    }
    
    return [super setSchemaParameterWithName:name value:value context:context error:outError];
}

- (CGSize)sizeThatFits:(CGSize)size
{
    return [self.contentView sizeThatFits:size];
}

@end
