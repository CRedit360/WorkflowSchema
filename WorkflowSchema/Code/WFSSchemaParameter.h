//
//  WFSSchemaParameter.h
//  WFSWorkflow
//
//  Created by Simon Booth on 19/10/2012.
//  Copyright (c) 2012 CRedit360. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WFSSchemaParameter : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) id value;

- (id)initWithName:(NSString *)name;
- (id)initWithName:(NSString *)name value:(id)value;

- (void)addValue:(id)value;

@end
