//
//  WFSTableCell.m
//  WFSWorkflow
//
//  Created by Simon Booth on 18/10/2012.
//  Copyright (c) 2012 CRedit360. All rights reserved.
//

#import "WFSTableCell.h"
#import "WFSSchema+WFSGroupedParameters.h"

@implementation WFSTableCell

- (id)initWithSchema:(WFSSchema *)schema context:(WFSContext *)context error:(NSError **)outError
{
    NSDictionary *groupedParameters = [schema groupedParametersWithContext:context error:outError];
    
    NSNumber *styleParameter = groupedParameters[@"style"];
    if (!styleParameter) styleParameter = @(UITableViewCellStyleDefault);
    UITableViewStyle style = [styleParameter integerValue];
    
    NSString *reuseIdentifier = NSStringFromClass([self class]);
    for (NSString *key in groupedParameters.allKeys)
    {
        reuseIdentifier = [reuseIdentifier stringByAppendingFormat:@" %@:%@", key, groupedParameters[key]];
    }
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _style = style;
        _selectable = YES;
        
        WFS_SCHEMATISING_INITIALISATION
        
        if (self.accessoryType == UITableViewCellAccessoryDetailDisclosureButton)
        {
            if (!self.detailDisclosureMessage)
            {
                if (outError) *outError = WFSError(@"Cells with the detailDisclosureIndicatorButton accessory type must have a detailDisclosureMessage");
                return nil;
            }
        }
        else
        {
            if (self.detailDisclosureMessage)
            {
                if (outError) *outError = WFSError(@"Cells without the detailDisclosureIndicatorButton accessory type may not have a detailDisclosureMessage");
                return nil;
            }
        }
    }
    return self;
}

+ (NSArray *)mandatorySchemaParameters
{
    return [[super mandatorySchemaParameters] arrayByPrependingObject:@"text" ];
}

+ (NSDictionary *)enumeratedSchemaParameters
{
    return [[super enumeratedSchemaParameters] dictionaryByAddingEntriesFromDictionary:@{
            
            @"accessoryType" : @{
            
                    @"none"                            : @(UITableViewCellAccessoryNone),
                    @"disclosureIndicator"             : @(UITableViewCellAccessoryDisclosureIndicator),
                    @"detailDisclosureIndicatorButton" : @(UITableViewCellAccessoryDetailDisclosureButton),
                    @"checkmark"                       : @(UITableViewCellAccessoryCheckmark)
            
            },
            
            @"style" : @{
            
                    @"default"  :@(UITableViewCellStyleDefault),
                    @"value1"   :@(UITableViewCellStyleValue1),
                    @"value2"   :@(UITableViewCellStyleValue2),
                    @"subtitle" :@(UITableViewCellStyleSubtitle)
            
            },
            
            @"selectionStyle" : @{
            
                    @"none" : @(UITableViewCellSelectionStyleNone),
                    @"blue" : @(UITableViewCellSelectionStyleBlue),
                    @"gray" : @(UITableViewCellSelectionStyleGray)
            
            }
            
    }];
}

+ (NSArray *)lazilyCreatedSchemaParameters
{
    return [[super lazilyCreatedSchemaParameters] arrayByPrependingObjectsFromArray:@[
            
            @"message",
            @"detailDisclosureMessage"
            
    ]];
}

+ (NSArray *)defaultSchemaParameters
{
    return [[super mandatorySchemaParameters] arrayByPrependingObjectsFromArray:@[
            
            @[ [NSString class], @"text" ],
            @[ [UIImage class], @"image" ]

    ]];
}

+ (NSDictionary *)schemaParameterTypes
{
    return [[super schemaParameterTypes] dictionaryByAddingEntriesFromDictionary:@{
    
            @"text"                    : [NSString class],
            @"detailText"              : [NSString class],
            @"accessoryType"           : @[ [NSString class], [NSNumber class] ],
            @"selectionStyle"          : @[ [NSString class], [NSNumber class] ],
            @"style"                   : @[ [NSString class], [NSNumber class] ],
            @"selectable"              : @[ [NSString class], [NSNumber class] ],
            @"image"                   : [UIImage class],
            @"message"                 : @[ [WFSMessage class], [NSString class] ],
            @"detailDisclosureMessage" : @[ [WFSMessage class], [NSString class] ],
            @"indentationLevel"        : @[ [NSString class], [NSNumber class] ]
    
    }];
}

- (BOOL)setSchemaParameterWithName:(NSString *)name value:(id)value context:(WFSContext *)context error:(NSError *__autoreleasing *)outError
{
    if ([name isEqualToString:@"style"])
    {
        return YES;
    }
    else if ([name isEqualToString:@"text"])
    {
        self.textLabel.text = value;
        return YES;
    }
    else if ([name isEqualToString:@"detailText"])
    {
        self.detailTextLabel.text = value;
        return YES;
    }
    
    return [super setSchemaParameterWithName:name value:value context:context error:outError];
}

@end
