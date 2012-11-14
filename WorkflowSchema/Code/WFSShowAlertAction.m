//
//  WFSAlertAction.m
//  WFSWorkflow
//
//  Created by Simon Booth on 16/10/2012.
//  Copyright (c) 2012 CRedit360. All rights reserved.
//

#import "WFSShowAlertAction.h"

@interface WFSShowAlertAction ()

@end

@implementation WFSShowAlertAction

- (id)initWithSchema:(WFSSchema *)schema context:(WFSContext *)context error:(NSError **)outError
{
    self = [super initWithSchema:schema context:context error:outError];
    if (self)
    {
        if (!self.cancelButtonItem)
        {
            self.cancelButtonItem = [[WFSCancelButtonItem alloc] initWithSchema:nil context:context error:outError];
            if (!self.cancelButtonItem) return nil;
        }
    }
    return self;
}

+ (NSArray *)mandatorySchemaParameters
{
    return [[super mandatorySchemaParameters] arrayByAddingObject:@"message"];
}

+ (NSArray *)arraySchemaParameters
{
    return [[super arraySchemaParameters] arrayByAddingObject:@"otherButtonItems"];
}

+ (NSArray *)defaultSchemaParameters
{
    return [[super defaultSchemaParameters] arrayByPrependingObjectsFromArray:@[ @[ [NSString class], @"message"], @[ [WFSCancelButtonItem class], @"cancelButtonItem" ], @[ [WFSActionButtonItem class], @"otherButtonItems" ] ]];
}

+ (NSArray *)lazilyCreatedSchemaParameters
{
    return [[super lazilyCreatedSchemaParameters] arrayByAddingObjectsFromArray:@[ @"message", @"title" ]];
}

+ (NSDictionary *)schemaParameterTypes
{
    return [[super schemaParameterTypes] dictionaryByAddingEntriesFromDictionary:@{
            
            @"title" : [NSString class],
            @"message" : [NSString class],
            @"cancelButtonItem" : [WFSActionButtonItem class],
            @"otherButtonItems" : [WFSActionButtonItem class]
    
    }];
}

- (UIAlertView *)alertViewWithContext:(WFSContext *)context error:(NSError **)outError
{
    NSError *error = nil;
    
    NSString *title = (NSString *)[self schemaParameterWithName:@"title" context:context error:&error];
    if (error)
    {
        if (outError) *outError = error;
        return nil;
    }
    
    NSString *message = (NSString *)[self schemaParameterWithName:@"message" context:context error:&error];
    if (error)
    {
        if (outError) *outError = error;
        return nil;
    }
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
    
    for (WFSActionButtonItem *item in self.otherButtonItems)
    {
        item.index = [alertView addButtonWithTitle:item.title];
    }
    
    self.cancelButtonItem.index = alertView.cancelButtonIndex = [alertView addButtonWithTitle:self.cancelButtonItem.title];
    
    return alertView;
}

- (WFSResult *)performActionForController:(UIViewController *)controller context:(WFSContext *)context
{
    NSError *error = nil;
    UIAlertView *alertView = [self alertViewWithContext:context error:&error];
    
    if (alertView)
    {
        [alertView show];
        return [WFSResult successResultWithContext:context];
    }
    else
    {
        if (!error) error = WFSError(@"Failed to create alert view");
        [context sendWorkflowError:error];
        return [WFSResult failureResultWithContext:context];
    }
}

#pragma mark - Alert view delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    WFSActionButtonItem *actionButtonItem = nil;
    
    if (buttonIndex == alertView.cancelButtonIndex)
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
    
    if (actionButtonItem.actionName)
    {
        WFSMessage *message = [WFSMessage actionMessageWithName:actionButtonItem.actionName context:self.workflowContext];
        [self.workflowContext sendWorkflowMessage:message];
    }
}

@end
