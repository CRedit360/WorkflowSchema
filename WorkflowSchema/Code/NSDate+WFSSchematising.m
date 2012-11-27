//
//  NSDate+WFSSchematising.m
//  WorkflowSchema
//
//  Created by Simon Booth on 27/11/2012.
//  Copyright (c) 2012 CRedit360. All rights reserved.
//

#import "NSDate+WFSSchematising.h"
#import "WFSSchema+WFSGroupedParameters.h"

@implementation NSDate (WFSSchematising)

+ (NSDate *)dateWithString:(NSString *)string format:(NSString *)format locale:(NSLocale *)locale error:(NSError **)outError
{
    NSDate *date = nil;
    
    if (format)
    {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = format;
        dateFormatter.lenient = YES;
        dateFormatter.locale = locale;
        
        date = [dateFormatter dateFromString:string];
    }
    else
    {
        NSDataDetector *detector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypeDate error:outError];
        NSArray *matches = [detector matchesInString:string options:0 range:NSMakeRange(0, string.length)];
        NSTextCheckingResult *match = [matches lastObject];
        
        date = match.date;
    }
    
    if (!date)
    {
        if (outError) *outError = WFSError(@"Could not parse date %@ with format %@", string, format);
    }
    
    return date;
}

- (id)initWithSchema:(WFSSchema *)schema context:(WFSContext *)context error:(NSError **)outError
{
    NSDictionary *groupedParameters = [schema groupedParametersWithContext:context error:outError];
    if (!groupedParameters) return nil;
    
    id value = groupedParameters[@"value"];
    
    if ([value isKindOfClass:[NSDate class]])
    {
        self = value;
    }
    else if ([value isKindOfClass:[NSNumber class]])
    {
        self = [self initWithTimeIntervalSince1970:[value doubleValue]];
    }
    else if ([value isKindOfClass:[NSString class]])
    {
        NSString *valueString = value;
        NSString *format = groupedParameters[@"format"];
        NSString *template = groupedParameters[@"template"];
        
        if (template && !format)
        {
            format = [NSDateFormatter dateFormatFromTemplate:template options:0 locale:schema.locale];
        }
        
        self = [NSDate dateWithString:valueString format:format locale:schema.locale error:outError];
    }
    
    return self;
}

+ (NSArray *)mandatorySchemaParameters
{
    return [[super mandatorySchemaParameters] arrayByAddingObject:@"value"];
}

+ (NSArray *)defaultSchemaParameters
{
    return [[super defaultSchemaParameters] arrayByAddingObject:@[ [NSString class], @"value" ]];
}

+ (NSDictionary *)schemaParameterTypes
{
    return [[super schemaParameterTypes] dictionaryByAddingEntriesFromDictionary:@{
            
            @"value"    : @[ [NSDate class], [NSNumber class], [NSString class] ],
            @"format"   : [NSString class],
            @"template" : [NSString class]
            
    }];
}

@end
