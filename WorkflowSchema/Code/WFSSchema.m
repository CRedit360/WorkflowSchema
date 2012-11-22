//
//  WFSSchema.m
//  WFSWorkflow
//
//  Created by Simon Booth on 15/10/2012.
//  Copyright (c) 2012 CRedit360. All rights reserved.
//

#import "WFSSchema.h"
#import "WFSSchema+WFSGroupedParameters.h"
#import "WorkflowSchema.h"
#import <objc/runtime.h>

NSString * const WFSClassDoesNotMatchSchemaTypeException = @"WFSClassDoesNotMatchSchemaTypeException";
NSString * const WFSSchemaInvalidException = @"WFSSchemaInvalidException";
NSString * const WFSSchemaInvalidExceptionSchemaKey = @"schema";

@interface WFSSchema ()

@property (nonatomic, copy, readwrite) NSString *typeName;
@property (nonatomic, strong, readwrite) NSArray *parameters;

@property (nonatomic, strong) NSDictionary *groupedParameters;
@property (nonatomic, strong) WFSContext *groupedParametersContext;

@end

@implementation WFSSchema

+ (void)initialize
{
    [self registerClass:[NSString class] forTypeName:@"string"];
    [self registerClass:[UIImage class] forTypeName:@"image"];
    
    [self registerClass:[WFSMessage class] forTypeName:@"message"];
    
    [self registerClass:[WFSTabBarController class] forTypeName:@"tabs"];
    [self registerClass:[WFSNavigationController class] forTypeName:@"navigation"];
    [self registerClass:[WFSScreenController class] forTypeName:@"screen"];
    [self registerClass:[WFSFormController class] forTypeName:@"form"];
    [self registerClass:[WFSTableController class] forTypeName:@"table"];
    
    [self registerClass:[WFSButton class] forTypeName:@"button"];
    [self registerClass:[WFSContainerView class] forTypeName:@"container"];
    [self registerClass:[WFSImageView class] forTypeName:@"imageView"];
    [self registerClass:[WFSLabel class] forTypeName:@"label"];
    [self registerClass:[WFSSearchBar class] forTypeName:@"searchBar"];
    [self registerClass:[WFSTextField class] forTypeName:@"textField"];
    [self registerClass:[WFSTableCell class] forTypeName:@"tableCell"];
    
    [self registerClass:[WFSTapGestureRecognizer class] forTypeName:@"tapGesture"];
    [self registerClass:[WFSLongPressGestureRecognizer class] forTypeName:@"longPressGesture"];
    [self registerClass:[WFSSwipeGestureRecognizer class] forTypeName:@"swipeGesture"];
    
    [self registerClass:[WFSConditionalAction class] forTypeName:@"conditionalAction"];
    [self registerClass:[WFSMultipleAction class] forTypeName:@"multipleActions"];
    [self registerClass:[WFSSendMessageAction class] forTypeName:@"sendMessage"];
    [self registerClass:[WFSShowAlertAction class] forTypeName:@"showAlert"];
    [self registerClass:[WFSShowActionSheetAction class] forTypeName:@"showActionSheet"];
    [self registerClass:[WFSLoadSchemaAction class] forTypeName:@"loadSchema"];
    [self registerClass:[WFSPushControllerAction class] forTypeName:@"pushController"];
    [self registerClass:[WFSPresentControllerAction class] forTypeName:@"presentController"];
    [self registerClass:[WFSPopControllerAction class] forTypeName:@"popController"];
    [self registerClass:[WFSDismissControllerAction class] forTypeName:@"dismissController"];
    [self registerClass:[WFSReplaceRootControllerAction class] forTypeName:@"replaceRootController"];
    [self registerClass:[WFSShowViewsAction class] forTypeName:@"showViews"];
    [self registerClass:[WFSHideViewsAction class] forTypeName:@"hideViews"];
    [self registerClass:[WFSUpdateViewsAction class] forTypeName:@"updateViews"];
    [self registerClass:[WFSStoreValuesAction class] forTypeName:@"storeValues"];
    
    [self registerClass:[WFSFormTrigger class] forTypeName:@"trigger"];
    
    [self registerClass:[WFSEqualityCondition class] forTypeName:@"isEqual"];
    [self registerClass:[WFSMultipleCondition class] forTypeName:@"multipleConditions"];
    [self registerClass:[WFSEqualityCondition class] forTypeName:@"isEqual"];
    [self registerClass:[WFSPresenceCondition class] forTypeName:@"isPresent"];
    [self registerClass:[WFSRegularExpressionCondition class] forTypeName:@"doesMatchRegularExpression"];
    
    [self registerClass:[WFSActionButtonItem class] forTypeName:@"actionButtonItem"];
    [self registerClass:[WFSCancelButtonItem class] forTypeName:@"cancelButtonItem"];
    [self registerClass:[WFSDestructiveButtonItem class] forTypeName:@"destructiveButtonItem"];
    [self registerClass:[WFSBarButtonItem class] forTypeName:@"barButtonItem"];
    [self registerClass:[WFSTabBarItem class] forTypeName:@"tabBarItem"];
    [self registerClass:[WFSNavigationItem class] forTypeName:@"navigationItem"];
    
    [self registerClass:[WFSTableSection class] forTypeName:@"tableSection"];
}

- (id)initWithTypeName:(NSString *)typeName attributes:(NSDictionary *)attributes parameters:(NSArray *)parameters
{
    self = [super init];
    if (self)
    {
        _typeName = [typeName copy];
        _attributes = attributes;
        _parameters = parameters;
        
        Class schemaClass = [self schemaClass];
        if (!schemaClass) return nil;
    }
    return self;
}

+ (NSMutableDictionary *)registeredClasses
{
    static NSMutableDictionary *registeredTypes = nil;
    if (!registeredTypes)
    {
        registeredTypes = [NSMutableDictionary dictionary];
    }
    
    return registeredTypes;
}

+ (void)registerClass:(Class<WFSSchematising>)schemaClass forTypeName:(NSString *)typeName
{
    [self registeredClasses][typeName] = schemaClass;
}

+ (Class<WFSSchematising>)registeredClassForTypeName:(NSString *)typeName
{
    return [self registeredClasses][typeName];
}

- (NSString *)styleName
{
    return self.attributes[@"class"];
}

- (NSString *)workflowName
{
    return self.attributes[@"name"];
}

- (Class<WFSSchematising>)schemaClass
{
    Class baseClass = [WFSSchema registeredClassForTypeName:self.typeName];
    NSString *className = NSStringFromClass(baseClass);
    
    if (self.styleName)
    {
        className = [NSString stringWithFormat:@"%@.%@", className, self.styleName];
    }
    
    Class subClass = NSClassFromString(className);
    
    if (!subClass)
    {
        subClass = (Class)objc_allocateClassPair(baseClass, [className UTF8String], 0);
        if (subClass)
        {
            objc_registerClassPair(subClass);
        }
    }
    
    return subClass;
}

- (id<WFSSchematising>)createObjectWithContext:(WFSContext *)context error:(NSError **)outError
{
    NSError *error = nil;
    id<WFSSchematising> object = nil;
    
    @try
    {
        Class schemaClass = [self schemaClass];
        
        if (!schemaClass)
        {
            error = WFSError(@"Failed to create class for object");
        }
        else
        {
            object = [[schemaClass alloc] initWithSchema:self context:context error:&error];
            if (object)
            {
                [context.schemaDelegate schema:self didCreateObject:object withContext:context];
            }
            else
            {
                if (!error) error = WFSError(@"Failed to create object");
            }
        }
    }
    @catch (NSException *exception)
    {
        if (!error) error = WFSErrorFromException(exception);
        object = nil;
    }
    
    if (outError) { *outError = error; }
    return object;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@ typeName:%@ attributes:%@ parameters:%@", [super description], self.typeName, self.attributes, self.parameters];
}

@end

@implementation WFSMutableSchema

- (id)initWithTypeName:(NSString *)typeName attributes:(NSDictionary *)attributes
{
    return [super initWithTypeName:typeName attributes:attributes parameters:nil];
}

- (void)addParameter:(id)parameter
{
    if (!self.parameters) self.parameters = [NSArray array];
    self.parameters = [self.parameters arrayByAddingObject:parameter];
}

@end
