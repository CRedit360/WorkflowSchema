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

NSString * WFSSearchBarTextKey = @"text";
NSString * WFSSearchBarScopeKey = @"scope";

@interface WFSSearchBarDelegate : NSObject <UISearchBarDelegate>; @end

@interface WFSSearchBar ()

@property (nonatomic, strong) WFSSearchBarDelegate *searchBarDelegate;

@end

@implementation WFSSearchBar

- (id)initWithSchema:(WFSSchema *)schema context:(WFSContext *)context error:(NSError **)outError
{
    self = [super initWithSchema:schema context:context error:outError];
    if (self)
    {
        _searchBarDelegate = [[WFSSearchBarDelegate alloc] init];
        self.delegate = _searchBarDelegate;
        
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

+ (NSArray *)lazilyCreatedSchemaParameters
{
    return [[super lazilyCreatedSchemaParameters] arrayByPrependingObjectsFromArray:@[
            
            @"searchMessage",
            @"cancelMessage",
            @"bookmarkMessage",
            @"resultsListMessage"
            
    ]];
}

+ (NSDictionary *)schemaParameterTypes
{
    return [[super schemaParameterTypes] dictionaryByAddingEntriesFromDictionary:@{
            
            @"placeholder"              : [NSString class],
            @"prompt"                   : [NSString class],
            @"scopeButtonItems"         : [WFSActionButtonItem class],
            @"showsBookmarkButton"      : @[ [NSString class], [NSNumber class] ],
            @"showsCancelButton"        : @[ [NSString class], [NSNumber class] ],
            @"showsSearchResultsButton" : @[ [NSString class], [NSNumber class] ],
            @"text"                     : [NSString class],
            @"validations"              : [WFSCondition class],
            
            @"searchMessage"            : @[ [WFSMessage class], [NSString class] ],
            @"cancelMessage"            : @[ [WFSMessage class], [NSString class] ],
            @"bookmarkMessage"          : @[ [WFSMessage class], [NSString class] ],
            @"resultsListMessage"       : @[ [WFSMessage class], [NSString class] ],
            @"textDidChangeMessage"     : @[ [WFSMessage class], [NSString class] ]
            
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
    NSMutableDictionary *parameters = [subContext.parameters mutableCopy];
    
    if (self.text)
    {
        [parameters setObject:self.text forKey:WFSSearchBarTextKey];
    }
    
    if (self.showsScopeBar)
    {
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
    
    subContext.parameters = parameters;
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
    
    if (workflowSearchBar.searchMessage)
    {
        WFSContext *actionContext = [workflowSearchBar contextWithTextAndScope:workflowSearchBar.workflowContext];
        [workflowSearchBar sendMessageFromParameterWithName:@"searchMessage" context:actionContext];
    }
    
    [[workflowSearchBar formInputDelegate] formInputShouldReturn:workflowSearchBar];
}

- (void)searchBarBookmarkButtonClicked:(UISearchBar *)searchBar
{
    WFSSearchBar *workflowSearchBar = (WFSSearchBar *)searchBar;
    
    if (workflowSearchBar.bookmarkMessage)
    {
        WFSContext *actionContext = [workflowSearchBar contextWithTextAndScope:workflowSearchBar.workflowContext];
        [workflowSearchBar sendMessageFromParameterWithName:@"bookmarkMessage" context:actionContext];
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    WFSSearchBar *workflowSearchBar = (WFSSearchBar *)searchBar;
    
    if (workflowSearchBar.cancelMessage)
    {
        WFSContext *actionContext = [workflowSearchBar contextWithTextAndScope:workflowSearchBar.workflowContext];
        [workflowSearchBar sendMessageFromParameterWithName:@"cancelMessage" context:actionContext];
    }
}

- (void)searchBarResultsListButtonClicked:(UISearchBar *)searchBar
{
    WFSSearchBar *workflowSearchBar = (WFSSearchBar *)searchBar;
    
    if (workflowSearchBar.resultsListMessage)
    {
        WFSContext *actionContext = [workflowSearchBar contextWithTextAndScope:workflowSearchBar.workflowContext];
        [workflowSearchBar sendMessageFromParameterWithName:@"resultsListMessage" context:actionContext];
    }
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    WFSSearchBar *workflowSearchBar = (WFSSearchBar *)searchBar;
    
    if (workflowSearchBar.textDidChangeMessage)
    {
        WFSContext *actionContext = [workflowSearchBar contextWithTextAndScope:workflowSearchBar.workflowContext];
        [workflowSearchBar sendMessageFromParameterWithName:@"textDidChangeMessage" context:actionContext];
    }
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    WFSSearchBar *workflowSearchBar = (WFSSearchBar *)searchBar;
    [[workflowSearchBar formInputDelegate] formInputWillBeginEditing:workflowSearchBar];
    return YES;
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
    
    if (item.message)
    {
        WFSContext *actionContext = [workflowSearchBar contextWithTextAndScope:item.workflowContext];
        [item sendMessageFromParameterWithName:@"message" context:actionContext];
    }
}

@end

