//
//  NSObject+WFSSchematising.m
//  WFSWorkflow
//
//  Created by Simon Booth on 17/10/2012.
//  Copyright (c) 2012 CRedit360. All rights reserved.
//

#import "NSObject+WFSSchematising.h"
#import "WFSSchema+WFSGroupedParameters.h"
#import "WFSMessage.h"
#import <objc/runtime.h>
#import <UIKit/UIAccessibility.h>

static char * const WFSSchematisingSchemaKey = "schema";
static char * const WFSSchematisingContextKey = "context";
static char * const WFSSchematisingNameKey = "name";

@implementation NSObject (WFSSchematising)

- (WFSSchema *)workflowSchema
{
    return objc_getAssociatedObject(self, WFSSchematisingSchemaKey);
}

- (void)setWorkflowSchema:(WFSSchema *)workflowSchema
{
    objc_setAssociatedObject(self, WFSSchematisingSchemaKey, workflowSchema, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (WFSContext *)workflowContext
{
    return objc_getAssociatedObject(self, WFSSchematisingContextKey);
}

- (void)setWorkflowContext:(WFSContext *)workflowContext
{
    objc_setAssociatedObject(self, WFSSchematisingContextKey, workflowContext, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)workflowName
{
    return objc_getAssociatedObject(self, WFSSchematisingNameKey);
}

- (void)setWorkflowName:(NSString *)workflowName
{
    objc_setAssociatedObject(self, WFSSchematisingNameKey, workflowName, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (id)initWithSchema:(WFSSchema *)schema context:(WFSContext *)context error:(NSError **)outError
{
    self = [self init];
    if (self)
    {
        WFS_SCHEMATISING_INITIALISATION
    }
    return self;
}

+ (NSArray *)mandatorySchemaParameters
{
    return @[];
}

+ (NSArray *)arraySchemaParameters
{
    return @[];
}

+ (NSDictionary *)enumeratedSchemaParameters
{
    return @{};
}

+ (NSDictionary *)bitmaskSchemaParameters
{
    return @{
        
        @"accessibilityTraits" : @{
        
            @"button"                   : @(UIAccessibilityTraitButton),
            @"link"                     : @(UIAccessibilityTraitLink),
            @"searchField"              : @(UIAccessibilityTraitSearchField),
            @"image"                    : @(UIAccessibilityTraitImage),
            @"selected"                 : @(UIAccessibilityTraitSelected),
            @"playsSound"               : @(UIAccessibilityTraitPlaysSound),
            @"keyboardKey"              : @(UIAccessibilityTraitKeyboardKey),
            @"staticText"               : @(UIAccessibilityTraitStaticText),
            @"summaryElement"           : @(UIAccessibilityTraitSummaryElement),
            @"notEnabled"               : @(UIAccessibilityTraitNotEnabled),
            @"updatesFrequently"        : @(UIAccessibilityTraitUpdatesFrequently),
            @"startsMediaSession"       : @(UIAccessibilityTraitStartsMediaSession),
            @"adjustable"               : @(UIAccessibilityTraitAdjustable),
            @"allowsDirectInteraction"  : @(UIAccessibilityTraitAllowsDirectInteraction),
            @"causesPageTurn"           : @(UIAccessibilityTraitCausesPageTurn)
    
        }
    
    };
}

+ (NSArray *)lazilyCreatedSchemaParameters
{
    return @[];
}

+ (NSDictionary *)schemaParameterTypes
{
    return @{
    
            @"accessibilityLabel"  : [NSString class],
            @"accessibilityHint"   : [NSString class],
            @"accessibilityValue"  : @[ [NSString class], [NSValue class] ],
            @"accessibilityTraits" : @[ [NSString class], [NSNumber class] ]
    
    };
}

+ (NSArray *)defaultSchemaParameters
{
    return @[];
}

- (WFSMutableContext *)contextForSchemaParameters:(WFSContext *)context
{
    return [context mutableCopy];
}

- (id)schemaParameterWithName:(NSString *)name context:(WFSContext *)context error:(NSError **)outError
{
    id value = [self valueForKeyPath:name];
    
    if ([value isKindOfClass:[WFSSchema class]])
    {
        WFSSchema *schema = value;
        value = [schema createObjectWithContext:context error:outError];
    }
    else if ([value isKindOfClass:[NSArray class]])
    {
        NSMutableArray *newValues = [NSMutableArray array];
        for (id subValue in [value flattenedArray])
        {
            if ([subValue isKindOfClass:[WFSSchema class]])
            {
                WFSSchema *schema = subValue;
                id newValue = [schema createObjectWithContext:context error:outError];
                if (!newValue) return nil;
                [newValues addObject:newValue];
            }
        }
        value = [newValues flattenedArray];
    }
    
    return value;
}

- (BOOL)setSchemaParameterWithName:(NSString *)name value:(id)value context:(WFSContext *)context error:(NSError **)outError
{
    if ([self validateValue:&value forKeyPath:name error:outError])
    {
        if ([@[@"accessibilityLabel", @"accessibilityHint", @"accessibilityValue", @"accessibilityTraits"] containsObject:name])
        {
            self.isAccessibilityElement = YES;
        }
        
        [self setValue:value forKeyPath:name];
        return YES;
    }
    
    return NO;
}

- (BOOL)setParametersForSchema:(WFSSchema *)schema context:(WFSContext *)context error:(NSError **)outError
{
    __block NSError *error = nil;
    
    context = [self contextForSchemaParameters:context];
    NSDictionary *groupedParameters = [schema groupedParametersWithContext:context error:&error];
    
    if (!error)
    {
        NSMutableArray *remainingParameters = [[[self class] mandatorySchemaParameters] mutableCopy];
        
        for (NSString *name in groupedParameters.allKeys)
        {
            id value = groupedParameters[name];
            
            BOOL didSetParameter = [self setSchemaParameterWithName:name value:value context:context error:&error];
            
            if (didSetParameter)
            {
                [remainingParameters removeObject:name];
            }
            else
            {
                if (!error) error = WFSError(@"Failed to set parameter %@", name);
                break;
            }
        }
        
        if (!error && (remainingParameters.count > 0))
        {
            error = WFSError(@"Missing mandatory parameters: %@", remainingParameters);
        }
    }
    
    if (outError) *outError = error;
    return (error == nil);
}
@end
