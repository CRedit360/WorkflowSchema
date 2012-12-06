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
#import "WFSTabBarItem.h"
#import "WFSSendMessageAction.h"

#import <objc/runtime.h>

static char * const WFSUIViewControllerSchematisingShouldForwardAllMessagesKey = "shouldForwardAllMessages";
static char * const WFSUIViewControllerSchematisingActionsKey = "actions";
static char * const WFSUIViewControllerSchematisingStoredValuesKey = "storedValues";

@implementation UIViewController (WFSSchematising)

+ (BOOL)isSchematisableClass
{
    return (self != [UIViewController class]);
}

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
            
            @"title"                    : [NSString class],
            @"hidesBottomBarWhenPushed" : [NSString class],
            @"navigationItem"           : [WFSNavigationItem class],
            @"tabBarItem"               : [WFSTabBarItem class],
            @"toolbarItems"             : [WFSBarButtonItem class],
            @"actions"                  : [WFSAction class],
            @"shouldForwardAllMessages"    : @[ [NSString class], [NSNumber class] ]
            
    }];
}

- (WFSMutableContext *)contextForSchemaParameters:(WFSContext *)context
{
    WFSMutableContext *subContext = [super contextForSchemaParameters:context];
    subContext.contextDelegate = self;
    
    // when creating a schema parameter, the stored values should win, or else what's the point of them?
    subContext.userInfo = [context.userInfo dictionaryByAddingEntriesFromDictionary:self.storedValues];
    
    return subContext;
}

- (BOOL)setSchemaParameterWithName:(NSString *)name value:(id)value context:(WFSContext *)context error:(NSError **)outError
{
    if ([name isEqualToString:@"navigationItem"])
    {
        WFSSchema *schema = value;
        return [self.navigationItem setParametersForSchema:schema context:context error:outError];
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

- (BOOL)shouldForwardAllMessages
{
    NSNumber *shouldForwardAllMessages = objc_getAssociatedObject(self, WFSUIViewControllerSchematisingShouldForwardAllMessagesKey);
    return [shouldForwardAllMessages boolValue];
}

- (void)setShouldForwardAllMessages:(BOOL)shouldForwardAllMessages
{
    objc_setAssociatedObject(self, WFSUIViewControllerSchematisingShouldForwardAllMessagesKey, @(shouldForwardAllMessages), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)context:(WFSContext *)contect didReceiveWorkflowError:(NSError *)error
{
    return [self.workflowContext sendWorkflowError:error];
}

- (BOOL)context:(WFSContext *)contect didReceiveWorkflowMessage:(WFSMessage *)message
{
    if ((message.destinationType == WFSMessageDestinationRootDelegate) || self.shouldForwardAllMessages)
    {
        return [self.workflowContext sendWorkflowMessage:message];
    }

    WFSResult *response = [self performActionName:message.name context:message.context];;
    [message respondWithResult:response];
    return YES;
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
    
    // when performing an action, the context's values should win, or else how could we store values?
    subContext.userInfo = [self.storedValues dictionaryByAddingEntriesFromDictionary:context.userInfo];
    
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
