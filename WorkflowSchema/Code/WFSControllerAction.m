//
//  WFSControllerAction.m
//  WorkflowSchema
//
//  Created by Simon Booth on 21/10/2012.
//  Copyright (c) 2012 CRedit360. All rights reserved.
//

#import "WFSControllerAction.h"
#import "WFSLoadSchemaAction.h"
#import "WFSParameterProxy.h"

@interface WFSControllerAction ()

@property (nonatomic, strong) id controller;

@end

@implementation WFSControllerAction

+ (NSArray *)lazilyCreatedSchemaParameters
{
    return [[super lazilyCreatedSchemaParameters] arrayByAddingObject:@"controller"];
}

+ (NSArray *)defaultSchemaParameters
{
    return [[super defaultSchemaParameters] arrayByPrependingObject:@[ [UIViewController class], @"controller" ]];
}

+ (NSDictionary *)schemaParameterTypes
{
    return [[super schemaParameterTypes] dictionaryByAddingEntriesFromDictionary:@{ @"controller" : [UIViewController class] }];
}

- (WFSResult *)performActionForController:(UIViewController *)controller context:(WFSContext *)context
{
    NSError *error = nil;
    UIViewController *controllerToShow = nil;
    
    if (self.controller)
    {
        controllerToShow = (UIViewController *)[self schemaParameterWithName:@"controller" context:context error:&error];
    }
    else
    {
        WFSSchema *schema = context.parameters[WFSLoadSchemaActionSchemaKey];
        controllerToShow = (UIViewController *)[schema createObjectWithContext:context error:&error];
    }
        
    if (![controllerToShow isKindOfClass:[UIViewController class]])
    {
        if (!error) error = WFSError(@"Parameter of type %@ is not a view controller", [controller class]);
        [context sendWorkflowError:error];
        return nil;
    }
    
    return [self showController:controllerToShow forController:controller context:context];
}

- (WFSResult *)showController:(UIViewController *)controllerToShow forController:(UIViewController *)controller context:(WFSContext *)context
{
    // abstract method
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

@end
