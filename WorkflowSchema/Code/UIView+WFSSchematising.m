//
//  UIView+WFSSchematising.m
//  WorkflowSchema
//
//  Created by Simon Booth on 29/10/2012.
//  Copyright (c) 2012 CRedit360. All rights reserved.
//

#import "UIView+WFSSchematising.h"

@implementation UIView (WFSSchematising)

+ (NSArray *)defaultSchemaParameters
{
    return [[super defaultSchemaParameters] arrayByPrependingObjectsFromArray:@[
            
    @[ [UIGestureRecognizer class], @"gestures" ]

    ]];
}

+ (NSDictionary *)schemaParameterTypes
{
    NSDictionary *schemaParameterTypes = [[super schemaParameterTypes] dictionaryByAddingEntriesFromDictionary:@{
            
            @"gestures"            : [UIGestureRecognizer class],
            @"hidden"              : @[ [NSString class], [NSValue class] ]

    }];
    
    if ([self instancesRespondToSelector:@selector(setBarStyle:)] && [self instancesRespondToSelector:@selector(setTranslucent:)])
    {
        schemaParameterTypes = [schemaParameterTypes dictionaryByAddingEntriesFromDictionary:@{
                                
            @"barStyle"    : @[ [NSString class], [NSValue class] ],
            @"translucent" : @[ [NSString class], [NSNumber class] ]
                                
        }];
    }
    
    if ([self conformsToProtocol:@protocol(UITextInput)])
    {
        schemaParameterTypes = [schemaParameterTypes dictionaryByAddingEntriesFromDictionary:@{
           
            @"autocapitalizationType"        : @[ [NSString class], [NSValue class] ],
            @"autocorrectionType"            : @[ [NSString class], [NSValue class] ],
            @"spellCheckingType"             : @[ [NSString class], [NSValue class] ],
            @"keyboardType"                  : @[ [NSString class], [NSValue class] ],
            @"keyboardAppearance"            : @[ [NSString class], [NSValue class] ],
            @"returnKeyType"                 : @[ [NSString class], [NSValue class] ],
            @"enablesReturnKeyAutomatically" : @[ [NSString class], [NSValue class] ],
            @"secureTextEntry"               : @[ [NSString class], [NSValue class] ]
                                
        }];
    }
    
    return schemaParameterTypes;
}

+ (NSArray *)arraySchemaParameters
{
    return [[super arraySchemaParameters] arrayByPrependingObject:@"gestures"];
}

+ (NSDictionary *)enumeratedSchemaParameters
{
    return [[super enumeratedSchemaParameters] dictionaryByAddingEntriesFromDictionary:@{
    
            @"autocapitalizationType" : @{
            
                    @"none"          : @(UITextAutocapitalizationTypeNone),
                    @"words"         : @(UITextAutocapitalizationTypeWords),
                    @"sentences"     : @(UITextAutocapitalizationTypeSentences),
                    @"allCharacters" : @(UITextAutocapitalizationTypeAllCharacters)
            
            },
            
            @"autocorrectionType" : @{
            
                    @"default" : @(UITextAutocorrectionTypeDefault),
                    @"no"      : @(UITextAutocorrectionTypeNo),
                    @"yes"     : @(UITextAutocorrectionTypeYes)
            
            },
            
            @"barStyle" : @{
            
                    @"default" : @(UIBarStyleDefault),
                    @"black"   : @(UIBarStyleBlack)
            
            },
            
            @"spellCheckingType" : @{
            
                    @"default" : @(UITextSpellCheckingTypeDefault),
                    @"no"      : @(UITextSpellCheckingTypeNo),
                    @"yes"     : @(UITextSpellCheckingTypeYes)
        
            },
            
            @"keyboardType" : @{
            
                    @"default"               : @(UIKeyboardTypeDefault),
                    @"asciiCapable"          : @(UIKeyboardTypeASCIICapable),
                    @"numbersAndPunctuation" : @(UIKeyboardTypeNumbersAndPunctuation),
                    @"url"                   : @(UIKeyboardTypeURL),
                    @"numberPad"             : @(UIKeyboardTypeNumberPad),
                    @"phonePad"              : @(UIKeyboardTypePhonePad),
                    @"namePhonePad"          : @(UIKeyboardTypeNamePhonePad),
                    @"emailAddress"          : @(UIKeyboardTypeEmailAddress),
                    @"decimalPad"            : @(UIKeyboardTypeDecimalPad),
                    @"twitter"               : @(UIKeyboardTypeTwitter)
            
            },
            
            @"keyboardAppearance" : @{
            
                    @"default" : @(UIKeyboardAppearanceDefault),
                    @"alert"   : @(UIKeyboardAppearanceAlert)
            
            },
            
            @"returnKeyType" : @{
            
                    @"default"       : @(UIReturnKeyDefault),
                    @"go"            : @(UIReturnKeyGo),
                    @"google"        : @(UIReturnKeyGoogle),
                    @"join"          : @(UIReturnKeyJoin),
                    @"next"          : @(UIReturnKeyNext),
                    @"route"         : @(UIReturnKeyRoute),
                    @"search"        : @(UIReturnKeySearch),
                    @"send"          : @(UIReturnKeySend),
                    @"yahoo"         : @(UIReturnKeyYahoo),
                    @"done"          : @(UIReturnKeyDone),
                    @"emergencyCall" : @(UIReturnKeyEmergencyCall)
            
            }
            
    }];
}

- (BOOL)setSchemaParameterWithName:(NSString *)name value:(id)value context:(WFSContext *)context error:(NSError **)outError
{
    if ([name isEqualToString:@"gestures"])
    {
        NSArray *gestures = value;
        if ([gestures isKindOfClass:[NSArray class]] && (gestures.count > 0))
        {
            self.userInteractionEnabled = YES; // otherwise there's not much point adding gestures
            
            for (UIGestureRecognizer *gestureRecognizer in gestures)
            {
                for (UIGestureRecognizer *otherGestureRecognizer in self.gestureRecognizers)
                {
                    [gestureRecognizer requireGestureRecognizerToFail:otherGestureRecognizer];
                }
                
                [self addGestureRecognizer:gestureRecognizer];
            }
            
            return YES;
        }
        return NO;
    }
    else if ([name isEqualToString:@"autocapitalizationType"])
    {
        [(id<UITextInput>)self setAutocapitalizationType:[value integerValue]];
        return YES;
    }
    else if ([name isEqualToString:@"autocorrectionType"])
    {
        [(id<UITextInput>)self setAutocorrectionType:[value integerValue]];
        return YES;
    }
    else if ([name isEqualToString:@"spellCheckingType"])
    {
        [(id<UITextInput>)self setSpellCheckingType:[value integerValue]];
        return YES;
    }
    else if ([name isEqualToString:@"keyboardType"])
    {
        [(id<UITextInput>)self setKeyboardType:[value integerValue]];
        return YES;
    }
    else if ([name isEqualToString:@"keyboardAppearance"])
    {
        [(id<UITextInput>)self setKeyboardAppearance:[value integerValue]];
        return YES;
    }
    else if ([name isEqualToString:@"returnKeyType"])
    {
        [(id<UITextInput>)self setReturnKeyType:[value integerValue]];
        return YES;
    }
    
    
    return [super setSchemaParameterWithName:name value:value context:context error:outError];
}

@end
