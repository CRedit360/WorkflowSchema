//
//  WFSSchema.h
//  WFSWorkflow
//
//  Created by Simon Booth on 15/10/2012.
//  Copyright (c) 2012 CRedit360. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WFSContext;
@protocol WFSSchematising;

@interface WFSSchema : NSObject

- (id)initWithTypeName:(NSString *)typeName attributes:(NSDictionary *)attributes parameters:(NSArray *)parameters;

@property (nonatomic, copy, readonly) NSString *typeName;
@property (nonatomic, copy, readonly) NSDictionary *attributes;
@property (nonatomic, strong, readonly) NSArray *parameters;

@property (nonatomic, readonly) Class<WFSSchematising> schemaClass;

@property (nonatomic, retain, readonly) NSLocale *locale;
@property (nonatomic, readonly) NSString *localeIdentifier;
@property (nonatomic, readonly) NSString *styleName;
@property (nonatomic, readonly) NSString *workflowName;

+ (void)registerClass:(Class<WFSSchematising>)schemaClass forTypeName:(NSString *)typeName;
+ (Class<WFSSchematising>)registeredClassForTypeName:(NSString *)typeName;
- (id<WFSSchematising>)createObjectWithContext:(WFSContext *)context error:(NSError **)outError;

@end

@interface WFSMutableSchema : WFSSchema

- (id)initWithTypeName:(NSString *)typeName attributes:(NSDictionary *)attributes;
- (void)addParameter:(id)parameter;

@end

@protocol WFSSchemaDelegate <NSObject>

- (void)schema:(WFSSchema *)schema didCreateObject:(id<WFSSchematising>)object withContext:(WFSContext *)context;

@end