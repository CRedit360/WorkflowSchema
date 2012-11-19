//
//  WFSSearchBar.m
//  WorkflowSchema
//
//  Created by Simon Booth on 15/11/2012.
//  Copyright (c) 2012 CRedit360. All rights reserved.
//

#import "WFSSearchBar.h"
#import "WFSActionButtonItem.h"
#import "WFSCondition.h"

NSString * WFSSearchBarTextKey = @"scope";
NSString * WFSSearchBarScopeKey = @"scope";

@interface WFSSearchBarDelegate : NSObject <UISearchBarDelegate>; @end

@interface WFSSearchBar ()

@property (nonatomic, strong) WFSSearchBarDelegate *searchBarDelegate;

@end

@implementation WFSSearchBar

- (id)initWithSchema:(WFSSchema *)schema context:(WFSContext *)context error:(NSError **)outError
{
    self = [super init];
    if (self)
    {
        _searchBarDelegate = [[WFSSearchBarDelegate alloc] init];
        self.delegate = _searchBarDelegate;
        
        WFS_SCHEMATISING_INITIALISATION
        
        if (self.accessibilityLabel.length == 0)
        {
            if (self.placeholder) self.accessibilityLabel = self.placeholder;
        }
        
        if (self.accessibilityLabel.length == 0)
        {
            if (outError) *outError = WFSError(@"Search bars must have a placeholder or an accessibilityLabel");
            return nil;
        }
    }
    return self;
}

+ (NSArray *)arraySchemaParameters
{
    return [[super arraySchemaParameters] arrayByPrependingObjectsFromArray:@[
            
            @"scopeButtonItems",
            @"validations"
            
    ]];
}

+ (NSArray *)defaultSchemaParameters
{
    return [[super defaultSchemaParameters] arrayByPrependingObject:@[ [WFSCondition class], @"validations" ]];
}

+ (NSDictionary *)enumeratedSchemaParameters
{
    return [[super enumeratedSchemaParameters] dictionaryByAddingEntriesFromDictionary:@{
            
            @"barStyle" : @{
            
                    @"default" : @(UIBarStyleDefault),
                    @"black"   : @(UIBarStyleBlack)
            
            }
            
    }];
}

+ (NSDictionary *)schemaParameterTypes
{
    return [[super schemaParameterTypes] dictionaryByAddingEntriesFromDictionary:@{
            
            @"barStyle"                 : @[ [NSString class], [NSNumber class] ],
            @"placeholder"              : [NSString class],
            @"prompt"                   : [NSString class],
            @"scopeButtonItems"         : [WFSActionButtonItem class],
            @"showsBookmarkButton"      : @[ [NSString class], [NSNumber class] ],
            @"showsCancelButton"        : @[ [NSString class], [NSNumber class] ],
            @"showsSearchResultsButton" : @[ [NSString class], [NSNumber class] ],
            @"text"                     : [NSString class],
            @"translucent"              : @[ [NSString class], [NSNumber class] ],
            @"validations"              : [WFSCondition class],
            
            @"searchActionName"         : [NSString class],
            @"cancelActionName"         : [NSString class],
            @"bookmarkActionName"       : [NSString class],
            @"resultsListActionName"    : [NSString class]
            
    }];
}

- (BOOL)setSchemaParameterWithName:(NSString *)name value:(id)value context:(WFSContext *)context error:(NSError **)outError
{
    if ([name isEqualToString:@"scopeButtonItems"])
    {
        NSMutableArray *buttonTitles = [NSMutableArray array];

        self.scopeButtonItems = value;
        for (int i = 0; i < self.scopeButtonItems.count; i++)
        {
            WFSActionButtonItem *item = self.scopeButtonItems[i];
            
            item.index = i;
            [buttonTitles addObject:item.title];
        }
        
        self.showsScopeBar = YES;
        self.scopeButtonTitles = buttonTitles;
        return YES;
    }
    
    return [super setSchemaParameterWithName:name value:value context:context error:outError];
}

- (WFSMutableContext *)contextForSchemaParameters:(WFSContext *)context
{
    return [self contextWithTextAndScope:context];
}

- (WFSMutableContext *)contextWithTextAndScope:(WFSContext *)context
{
    WFSMutableContext *subContext = [super contextForSchemaParameters:context];
    
    if (self.showsScopeBar)
    {
        NSMutableDictionary *parameters = [subContext.parameters mutableCopy];
        NSString *scope = [self.scopeButtonItems[self.selectedScopeButtonIndex] workflowName];
        
        if (scope)
        {
            [parameters setObject:scope forKey:WFSSearchBarScopeKey];
        }
        else
        {
            [parameters removeObjectForKey:WFSSearchBarScopeKey];
        }
    }
    
    return subContext;
}

- (id)formValue
{
    return (self.text ? self.text : @"");
}

@end

@implementation WFSSearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar;
{
    WFSSearchBar *workflowSearchBar = (WFSSearchBar *)searchBar;
    
    if (workflowSearchBar.searchActionName)
    {
        WFSContext *actionContext = [workflowSearchBar contextWithTextAndScope:workflowSearchBar.workflowContext];
        WFSMessage *actionMessage = [WFSMessage actionMessageWithName:workflowSearchBar.searchActionName context:actionContext];
        [actionContext sendWorkflowMessage:actionMessage];
    }
    
    [[workflowSearchBar formInputDelegate] formInputShouldReturn:workflowSearchBar];
}

- (void)searchBarBookmarkButtonClicked:(UISearchBar *)searchBar
{
    WFSSearchBar *workflowSearchBar = (WFSSearchBar *)searchBar;
    
    if (workflowSearchBar.bookmarkActionName)
    {
        WFSContext *actionContext = [workflowSearchBar contextWithTextAndScope:workflowSearchBar.workflowContext];
        WFSMessage *actionMessage = [WFSMessage actionMessageWithName:workflowSearchBar.bookmarkActionName context:actionContext];
        [actionContext sendWorkflowMessage:actionMessage];
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    WFSSearchBar *workflowSearchBar = (WFSSearchBar *)searchBar;
    
    if (workflowSearchBar.cancelActionName)
    {
        WFSContext *actionContext = [workflowSearchBar contextWithTextAndScope:workflowSearchBar.workflowContext];
        WFSMessage *actionMessage = [WFSMessage actionMessageWithName:workflowSearchBar.cancelActionName context:actionContext];
        [actionContext sendWorkflowMessage:actionMessage];
    }
}

- (void)searchBarResultsListButtonClicked:(UISearchBar *)searchBar
{
    WFSSearchBar *workflowSearchBar = (WFSSearchBar *)searchBar;
    
    if (workflowSearchBar.resultsListActionName)
    {
        WFSContext *actionContext = [workflowSearchBar contextWithTextAndScope:workflowSearchBar.workflowContext];
        WFSMessage *actionMessage = [WFSMessage actionMessageWithName:workflowSearchBar.resultsListActionName context:actionContext];
        [actionContext sendWorkflowMessage:actionMessage];
    }
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    WFSSearchBar *workflowSearchBar = (WFSSearchBar *)searchBar;
    [[workflowSearchBar formInputDelegate] formInputDidEndEditing:workflowSearchBar];
}

- (void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope
{
    WFSSearchBar *workflowSearchBar = (WFSSearchBar *)searchBar;
    WFSActionButtonItem *item = workflowSearchBar.scopeButtonItems[selectedScope];
    
    if (item.actionName)
    {
        WFSContext *actionContext = [workflowSearchBar contextWithTextAndScope:item.workflowContext];
        WFSMessage *actionMessage = [WFSMessage actionMessageWithName:item.actionName context:actionContext];
        [actionContext sendWorkflowMessage:actionMessage];
    }
}

@end

