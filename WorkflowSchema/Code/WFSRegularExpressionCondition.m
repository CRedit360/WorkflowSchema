//
//  WFSRegularExpressionCondition.m
//  WFSWorkflow
//
//  Created by Simon Booth on 16/10/2012.
//  Copyright (c) 2012 CRedit360. All rights reserved.
//

#import "WFSRegularExpressionCondition.h"

@interface WFSRegularExpressionCondition ()

@end

@implementation WFSRegularExpressionCondition

+ (NSArray *)mandatorySchemaParameters
{
    return [[super mandatorySchemaParameters] arrayByAddingObject:@"pattern"];
}

+ (NSArray *)defaultSchemaParameters
{
    return [[super defaultSchemaParameters] arrayByPrependingObject:@[ [NSString class], @"pattern" ]];
}

+ (NSDictionary *)schemaParameterTypes
{
    return [[super schemaParameterTypes] dictionaryByAddingEntriesFromDictionary:@{ @"pattern" : [NSString class] }];
}

- (BOOL)setSchemaParameterWithName:(NSString *)name value:(id)value context:(WFSContext *)context error:(NSError *__autoreleasing *)outError
{
    if ([name isEqualToString:@"pattern"])
    {
        _pattern = value;
        _patternRegex = [NSRegularExpression regularExpressionWithPattern:_pattern options:NSRegularExpressionCaseInsensitive error:outError];
        return (_patternRegex != nil);
    }
    else return [super setSchemaParameterWithName:name value:value context:context error:outError];
}

- (BOOL)evaluateWithValue:(id)value context:(WFSContext *)context
{
    NSString *stringValue = nil;
    if ([value isKindOfClass:[NSString class]])
    {
        stringValue = value;
    }
    else if ([value respondsToSelector:@selector(stringValue)])
    {
        stringValue = [value stringValue];
    }
    if (!stringValue) stringValue = @"";
    
    NSArray *matches = [self.patternRegex matchesInString:stringValue options:0 range:NSMakeRange(0, stringValue.length)];
    
    return (matches.count > 0);
}

@end
