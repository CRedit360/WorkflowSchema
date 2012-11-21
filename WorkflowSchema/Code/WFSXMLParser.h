//
//  WFSXMLParser.h
//  WFSWorkflow
//
//  Created by Simon Booth on 15/10/2012.
//  Copyright (c) 2012 CRedit360. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WFSSchema.h"

extern NSString * const WFSXMLParserException;
extern NSString * const WFSXMLParserStackKey;

@interface WFSXMLParser : NSObject

- (id)initWithParser:(NSXMLParser *)parser;
- (id)initWithContentsOfURL:(NSURL *)url;
- (id)initWithString:(NSString *)string;

- (WFSSchema *)parse:(NSError **)outError;

@end
