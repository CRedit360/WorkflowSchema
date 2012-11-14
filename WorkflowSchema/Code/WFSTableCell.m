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
        
        WFS_SCHEMATISING_INITIALISATION
        
        if (self.accessoryType == UITableViewCellAccessoryDetailDisclosureButton)
        {
            if (!self.detailDisclosureActionName)
            {
                if (outError) *outError = WFSError(@"Cells with the detailDetailDisclosure accessory type must have a detailDisclosureActionName");
                return nil;
            }
        }
        else
        {
            if (self.detailDisclosureActionName)
            {
                if (outError) *outError = WFSError(@"Cells without the detailDetailDisclosure accessory type may not have a detailDisclosureActionName");
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
            
            @"style" : @{
            
                    @"default"  :@(UITableViewCellStyleDefault),
                    @"value1"   :@(UITableViewCellStyleValue1),
                    @"value2"   :@(UITableViewCellStyleValue2),
                    @"subtitle" :@(UITableViewCellStyleSubtitle)
            
            },
            
            @"accessoryType" : @{
            
                    @"none"                            : @(UITableViewCellAccessoryNone),
                    @"disclosureIndicator"             : @(UITableViewCellAccessoryDisclosureIndicator),
                    @"detailDisclosureIndicatorButton" : @(UITableViewCellAccessoryDetailDisclosureButton),
                    @"checkmark"                       : @(UITableViewCellAccessoryCheckmark)
            
            }
            
    }];
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
    
            @"style"                      : [NSString class],
            @"text"                       : [NSString class],
            @"detailText"                 : [NSString class],
            @"accessoryType"              : [NSString class],
            @"image"                      : [UIImage class],
            @"actionName"                 : [NSString class],
            @"detailDisclosureActionName" : [NSString class]
    
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
