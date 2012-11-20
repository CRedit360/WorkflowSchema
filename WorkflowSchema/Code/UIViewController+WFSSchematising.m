//
//  UIViewController+WFSSchematising.m
//  WorkflowSchema
//
//  Created by Simon Booth on 29/10/2012.
//  Copyright (c) 2012 CRedit360. All rights reserved.
//

#import "UIViewController+WFSSchematising.h"
#import "WFSBarButtonItem.h"
#import "WFSNavigationItem.h"
#import "WFSNavigationItemHelper.h"
#import "WFSTabBarItem.h"
#import "WFSSendMessageAction.h"

#import <objc/runtime.h>

static char * const WFSUIViewControllerSchematisingActionsKey = "actions";
static char * const WFSUIViewControllerSchematisingStoredValuesKey = "storedValues";

@implementation UIViewController (WFSSchematising)

+ (NSArray *)lazilyCreatedSchemaParameters
{
    return [[super lazilyCreatedSchemaParameters] arrayByPrependingObject:@"navigationItem"];
}

+ (NSArray *)arraySchemaParameters
{
    return [[super arraySchemaParameters] arrayByPrependingObjectsFromArray:@[
            
            @"actions",
            @"toolbarItems"
            
    ]];
}

+ (NSArray *)defaultSchemaParameters
{
    return [[super defaultSchemaParameters] arrayByPrependingObjectsFromArray:@[
            
            @[ [WFSNavigationItem class], @"navigationItem" ],
            @[ [WFSTabBarItem class], @"tabBarItem" ],
            @[ [WFSAction class], @"actions" ],
            
    ]];
}

+ (NSDictionary *)schemaParameterTypes
{
    return [[super schemaParameterTypes] dictionaryByAddingEntriesFromDictionary:@{
            
            @"title" : [NSString class],
            @"hidesBottomBarWhenPushed" : [NSString class],
            @"navigationItem" : [WFSNavigationItem class],
            @"tabBarItem" : [WFSTabBarItem class],
            @"toolbarItems" : [WFSBarButtonItem class],
            @"actions" : [WFSAction class]
            
    }];
}

- (WFSMutableContext *)contextForSchemaParameters:(WFSContext *)context
{
    WFSMutableContext *subContext = [super contextForSchemaParameters:context];
    subContext.contextDelegate = self;
    subContext.parameters = [subContext.parameters dictionaryByAddingEntriesFromDictionary:self.storedValues];
    return subContext;
}

- (BOOL)setSchemaParameterWithName:(NSString *)name value:(id)value context:(WFSContext *)context error:(NSError **)outError
{
    if ([name isEqualToString:@"navigationItem"])
    {
        WFSNavigationItemHelper *navigationItemHelper = [[WFSNavigationItemHelper alloc] initWithNavigationItem:self.navigationItem];
        return [navigationItemHelper setupNavigationItemForSchema:value context:context value:value error:outError];
    }
    
    return [super setSchemaParameterWithName:name value:value context:context error:outError];
}

#pragma mark - Stored values

- (NSDictionary *)storedValues
{
    NSDictionary *variables = objc_getAssociatedObject(self, WFSUIViewControllerSchematisingStoredValuesKey);
    if (!variables) variables = @{};
    return variables;
}

- (void)setStoredValues:(NSDictionary *)variables
{
    objc_setAssociatedObject(self, WFSUIViewControllerSchematisingStoredValuesKey, variables, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)storeValues:(NSDictionary *)valuesToStore
{
    [self clearCachedContextValues];
    self.storedValues = [self.storedValues dictionaryByAddingEntriesFromDictionary:valuesToStore];
}

- (void)clearCachedContextValues
{
    // do nothing
}

#pragma mark - Workflow message delegate

- (void)context:(WFSContext *)contect didReceiveWorkflowError:(NSError *)error
{
    return [self.workflowContext sendWorkflowError:error];
}

- (BOOL)context:(WFSContext *)contect didReceiveWorkflowMessage:(WFSMessage *)message
{
    if (message.destinationType != WFSMessageDestinationRootDelegate)
    {
        WFSResult *response = [self performActionName:message.name context:message.context];;
        [message respondWithResult:response];
        return YES;
    }
    
    return [self.workflowContext sendWorkflowMessage:message];
}

#pragma mark - Shared action methods

- (NSArray *)actions
{
    return objc_getAssociatedObject(self, WFSUIViewControllerSchematisingActionsKey);
}

- (void)setActions:(NSArray *)actions
{
    objc_setAssociatedObject(self, WFSUIViewControllerSchematisingActionsKey, actions, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)actionNameForSelector:(SEL)selector
{
    return [NSStringFromSelector(selector) stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@":"]];
}

- (WFSMutableContext *)contextForPerformingActions:(WFSContext *)context
{
    WFSMutableContext *subContext = [context mutableCopy];
    subContext.contextDelegate = self;
    subContext.parameters = [subContext.parameters dictionaryByAddingEntriesFromDictionary:self.storedValues];
    return subContext;
}

- (WFSResult *)performActionName:(NSString *)name context:(WFSContext *)context
{
    WFSMutableContext *actionContext = [self contextForPerformingActions:context];
    
    for (WFSAction *action in self.actions)
    {
        if ([action shouldPerformActionForResultName:name])
        {
            return [action performActionForController:self context:actionContext];
        }
    }
    
    return nil;
}


@end
