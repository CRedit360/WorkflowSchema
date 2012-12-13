//
//  WFSActionSheetAction.m
//  WFSWorkflow
//
//  Created by Simon Booth on 16/10/2012.
//  Copyright (c) 2012 CRedit360. All rights reserved.
//

#import "WFSShowActionSheetAction.h"
#import <objc/runtime.h>

@implementation WFSShowActionSheetAction

- (id)initWithSchema:(WFSSchema *)schema context:(WFSContext *)context error:(NSError **)outError
{
    self = [super initWithSchema:schema context:context error:outError];
    if (self)
    {
        NSInteger numberOfButtons = self.otherButtonItems.count;
        if (self.destructiveButtonItem) numberOfButtons++;
        if (self.cancelButtonItem) numberOfButtons++;
        
        if (numberOfButtons < 2)
        {
            if (outError) *outError = WFSError(@"Action sheets must have at least two buttons.");
            return nil;
        }
    }
    return self;
}

+ (NSArray *)arraySchemaParameters
{
    return [[super arraySchemaParameters] arrayByAddingObject:@"otherButtonItems"];
}

+ (NSArray *)lazilyCreatedSchemaParameters
{
    return [[super lazilyCreatedSchemaParameters] arrayByAddingObject:@"title"];
}

+ (NSArray *)defaultSchemaParameters
{
    return [[super arraySchemaParameters] arrayByAddingObjectsFromArray:@[
            
            @[[WFSCancelButtonItem class], @"cancelButtonItem"],
            @[[WFSDestructiveButtonItem class], @"destructiveButtonItem"],
            @[[WFSActionButtonItem class], @"otherButtonItems"]
            
    ]];
}

+ (NSDictionary *)schemaParameterTypes
{
    return [[super schemaParameterTypes] dictionaryByAddingEntriesFromDictionary:@{
    
            @"title" : [NSString class],
            @"cancelButtonItem" : [WFSActionButtonItem class],
            @"destructiveButtonItem" : [WFSActionButtonItem class],
            @"otherButtonItems" : [WFSActionButtonItem class],
    
    }];
}

- (UIActionSheet *)actionSheetWithContext:(WFSContext *)context error:(NSError **)outError
{
    NSError *error = nil;
    
    NSString *title = (NSString *)[self schemaParameterWithName:@"title" context:context error:&error];
    if (error)
    {
        if (outError) *outError = error;
        return nil;
    }
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:title delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
    objc_setAssociatedObject(actionSheet, _cmd, self, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    if (self.destructiveButtonItem)
    {
        self.destructiveButtonItem.index = actionSheet.destructiveButtonIndex = [actionSheet addButtonWithTitle:self.destructiveButtonItem.title];
    }
    
    for (WFSActionButtonItem *item in self.otherButtonItems)
    {
        item.index = [actionSheet addButtonWithTitle:item.title];
    }
    
    self.cancelButtonItem.index = actionSheet.cancelButtonIndex = [actionSheet addButtonWithTitle:self.cancelButtonItem.title];
    
    return actionSheet;
}

- (WFSResult *)performActionForController:(UIViewController *)controller context:(WFSContext *)context
{
    NSError *error = nil;
    UIActionSheet *actionSheet = [self actionSheetWithContext:context error:&error];
    
    if (actionSheet)
    {
        // TODO: on an iPad, look at the sender
        if (controller.tabBarController.tabBar)
        {
            [actionSheet showFromTabBar:controller.tabBarController.tabBar];
        }
        else
        {
            UIWindow *window = controller.view.window;
            [actionSheet showInView:window];
        }
        
        return [WFSResult successResultWithContext:context];
    }
    else
    {
        if (!error) error = WFSError(@"Failed to create action sheet");
        [context sendWorkflowError:error];
        return [WFSResult failureResultWithContext:context];
    }
}

#pragma mark - Action sheet deletage

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    WFSActionButtonItem *actionButtonItem = nil;
    
    if (buttonIndex == actionSheet.destructiveButtonIndex)
    {
        actionButtonItem = self.destructiveButtonItem;
    }
    else if (buttonIndex == actionSheet.cancelButtonIndex)
    {
        actionButtonItem = self.cancelButtonItem;
    }
    else
    {
        for (WFSActionButtonItem *item in self.otherButtonItems)
        {
            if (buttonIndex == item.index)
            {
                actionButtonItem = item;
                break;
            }
        }
    }
    
    if (actionButtonItem.message)
    {
        [actionButtonItem sendMessageFromParameterWithName:@"message" context:actionButtonItem.workflowContext];
    }
}

@end
