//
//  KIFTestScenario+WSTSearchBarUnitTests.m
//  WorkflowSchemaTests
//
//  Created by Simon Booth on 26/10/2012.
//  Copyright (c) 2012 CRedit360. All rights reserved.
//

#import "KIFTestScenario+WSTSearchBarUnitTests.h"
#import "KIFTestStep+WSTShared.h"
#import "WSTAssert.h"
#import "WSTTestAction.h"
#import "WSTTestContext.h"
#import <WorkflowSchema/WorkflowSchema.h>

@implementation KIFTestScenario (WSTSearchBarUnitTests)

+ (id)scenarioUnitTestCreateSearchBarWithoutScopeBarIems
{
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Test search bar creation without scope button items"];
    
    [scenario addStep:[KIFTestStep stepWithDescription:scenario.description executionBlock:^KIFTestStepResult(KIFTestStep *step, NSError **outError) {
        
        NSError *error = nil;
        
        WFSSchema *searchBarSchema = [[WFSSchema alloc] initWithTypeName:@"searchBar" attributes:@{@"name":@"foo"} parameters:@[
                                          [[WFSSchemaParameter alloc] initWithName:@"text" value:@"bar"],
                                          [[WFSSchemaParameter alloc] initWithName:@"placeholder" value:@"fum"]
                                     ]];
        
        WSTTestContext *context = [[WSTTestContext alloc] init];
        
        WFSSearchBar *searchBar = (WFSSearchBar *)[searchBarSchema createObjectWithContext:context error:&error];
        WSTFailOnError(error);
        WSTAssert([searchBar isKindOfClass:[WFSSearchBar class]]);
        
        WSTAssert([searchBar.workflowName isEqual:@"foo"]);
        WSTAssert([searchBar.text isEqual:@"bar"]);
        WSTAssert([searchBar.placeholder isEqual:@"fum"]);
        WSTAssert(!searchBar.showsScopeBar);
        
        return KIFTestStepResultSuccess;
        
    }]];
    
    return scenario;
}

+ (id)scenarioUnitTestCreateSearchBarWithScopeBarItems
{
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Test search bar creation with scope button items"];
    
    [scenario addStep:[KIFTestStep stepWithDescription:scenario.description executionBlock:^KIFTestStepResult(KIFTestStep *step, NSError **outError) {
        
        NSError *error = nil;
        
        WFSSchema *searchBarSchema = [[WFSSchema alloc] initWithTypeName:@"searchBar" attributes:nil parameters:@[
                                          [[WFSSchemaParameter alloc] initWithName:@"placeholder" value:@"Please enter a value"],
                                          [[WFSSchemaParameter alloc] initWithName:@"scopeButtonItems" value:@[
                                               [[WFSSchema alloc] initWithTypeName:@"actionButtonItem" attributes:nil parameters:@[
                                                    [[WFSSchemaParameter alloc] initWithName:@"title" value:@"Red"],
                                                    [[WFSSchemaParameter alloc] initWithName:@"message" value:@"didSelectRed"]
                                                ]],
                                               [[WFSSchema alloc] initWithTypeName:@"actionButtonItem" attributes:nil parameters:@[
                                                    [[WFSSchemaParameter alloc] initWithName:@"title" value:@"Green"],
                                                    [[WFSSchemaParameter alloc] initWithName:@"message" value:@"didSelectGreen"]
                                               ]],
                                               [[WFSSchema alloc] initWithTypeName:@"actionButtonItem" attributes:nil parameters:@[
                                                    [[WFSSchemaParameter alloc] initWithName:@"title" value:@"Blue"],
                                                    [[WFSSchemaParameter alloc] initWithName:@"message" value:@"didSelectBlue"]
                                               ]]
                                          ]]
                                     ]];
        
        WSTTestContext *context = [[WSTTestContext alloc] init];
        
        WFSSearchBar *searchBar = (WFSSearchBar *)[searchBarSchema createObjectWithContext:context error:&error];
        WSTFailOnError(error);
        WSTAssert([searchBar isKindOfClass:[WFSSearchBar class]]);
        
        WSTAssert(searchBar.scopeButtonItems.count == 3);
        WSTAssert(searchBar.scopeButtonTitles.count == 3);
        WSTAssert(searchBar.showsScopeBar);
        
        WFSActionButtonItem *firstActionButtonItem = searchBar.scopeButtonItems[0];
        WSTAssert([firstActionButtonItem.title isEqualToString:@"Red"]);
        WSTAssert([firstActionButtonItem.message isEqualToString:@"didSelectRed"]);
        WFSActionButtonItem *secondActionButtonItem = searchBar.scopeButtonItems[1];
        WSTAssert([secondActionButtonItem.title isEqualToString:@"Green"]);
        WSTAssert([secondActionButtonItem.message isEqualToString:@"didSelectGreen"]);
        WFSActionButtonItem *thirdActionButtonItem = searchBar.scopeButtonItems[2];
        WSTAssert([thirdActionButtonItem.title isEqualToString:@"Blue"]);
        WSTAssert([thirdActionButtonItem.message isEqualToString:@"didSelectBlue"]);
        
        WSTAssert(context.messages.count == 0);
        
        [searchBar.delegate searchBar:searchBar selectedScopeButtonIndexDidChange:0];
        WSTAssert(context.messages.count == 1);
        WSTAssert([[context.messages[0] name] isEqualToString:@"didSelectRed"]);
        
        [searchBar.delegate searchBar:searchBar selectedScopeButtonIndexDidChange:1];
        WSTAssert(context.messages.count == 2);
        WSTAssert([[context.messages[1] name] isEqualToString:@"didSelectGreen"]);
        
        [searchBar.delegate searchBar:searchBar selectedScopeButtonIndexDidChange:2];
        WSTAssert(context.messages.count == 3);
        WSTAssert([[context.messages[2] name] isEqualToString:@"didSelectBlue"]);
        
        return KIFTestStepResultSuccess;
        
    }]];
    
    return scenario;
}

+ (id)scenarioUnitTestCreateSearchBarWithNonScopeParameters
{
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Test search bar creation with non-scope parameters"];
    
    [scenario addStep:[KIFTestStep stepWithDescription:scenario.description executionBlock:^KIFTestStepResult(KIFTestStep *step, NSError **outError) {
        
        NSError *error = nil;
        
        WFSSchema *searchBarSchema = [[WFSSchema alloc] initWithTypeName:@"searchBar" attributes:@{@"name":@"test"} parameters:@[
                                      
                                          [[WFSSchemaParameter alloc] initWithName:@"accessibilityLabel" value:@"test accessibilityLabel"],
                                          [[WFSSchemaParameter alloc] initWithName:@"barStyle" value:@"black"],
                                          [[WFSSchemaParameter alloc] initWithName:@"placeholder" value:@"test placeholder"],
                                          [[WFSSchemaParameter alloc] initWithName:@"prompt" value:@"test prompt"],
                                          [[WFSSchemaParameter alloc] initWithName:@"showsBookmarkButton" value:@"YES"],
                                          [[WFSSchemaParameter alloc] initWithName:@"showsCancelButton" value:@"YES"],
                                          [[WFSSchemaParameter alloc] initWithName:@"showsSearchResultsButton" value:@"YES"],
                                          [[WFSSchemaParameter alloc] initWithName:@"text" value:@"test text"],
                                          [[WFSSchemaParameter alloc] initWithName:@"translucent" value:@"YES"],
                                      
                                          [[WFSSchemaParameter alloc] initWithName:@"bookmarkMessage" value:@"didTapBookmarks"],
                                          [[WFSSchemaParameter alloc] initWithName:@"cancelMessage" value:@"didTapCancel"],
                                          [[WFSSchemaParameter alloc] initWithName:@"searchMessage" value:@"didTapSearch"],
                                          [[WFSSchemaParameter alloc] initWithName:@"resultsListMessage" value:@"didTapResultsList"]
                                      
                                     ]];
        
        WSTTestContext *context = [[WSTTestContext alloc] init];
        
        WFSSearchBar *searchBar = (WFSSearchBar *)[searchBarSchema createObjectWithContext:context error:&error];
        WSTFailOnError(error);
        WSTAssert([searchBar isKindOfClass:[WFSSearchBar class]]);
        
        WSTAssert([searchBar.workflowName isEqual:@"test"]);
        WSTAssert([searchBar.accessibilityLabel isEqual:@"test accessibilityLabel"]);
        WSTAssert(searchBar.barStyle == UIBarStyleBlack);
        WSTAssert([searchBar.placeholder isEqual:@"test placeholder"]);
        WSTAssert([searchBar.prompt isEqual:@"test prompt"]);
        WSTAssert(searchBar.showsBookmarkButton);
        WSTAssert(searchBar.showsCancelButton);
        WSTAssert(searchBar.showsSearchResultsButton);
        WSTAssert(searchBar.showsSearchResultsButton);
        WSTAssert([searchBar.text isEqual:@"test text"]);
        WSTAssert(searchBar.translucent);
        
        WSTAssert([searchBar.bookmarkMessage isEqualToString:@"didTapBookmarks"]);
        WSTAssert([searchBar.cancelMessage isEqualToString:@"didTapCancel"]);
        WSTAssert([searchBar.searchMessage isEqualToString:@"didTapSearch"]);
        WSTAssert([searchBar.resultsListMessage isEqualToString:@"didTapResultsList"]);
        
        WSTAssert(context.messages.count == 0);
        
        [searchBar.delegate searchBarBookmarkButtonClicked:searchBar];
        WSTAssert(context.messages.count == 1);
        WSTAssert([[context.messages[0] name] isEqualToString:@"didTapBookmarks"]);
        
        [searchBar.delegate searchBarCancelButtonClicked:searchBar];
        WSTAssert(context.messages.count == 2);
        WSTAssert([[context.messages[1] name] isEqualToString:@"didTapCancel"]);
        
        [searchBar.delegate searchBarSearchButtonClicked:searchBar];
        WSTAssert(context.messages.count == 3);
        WSTAssert([[context.messages[2] name] isEqualToString:@"didTapSearch"]);
        
        [searchBar.delegate searchBarResultsListButtonClicked:searchBar];
        WSTAssert(context.messages.count == 4);
        WSTAssert([[context.messages[3] name] isEqualToString:@"didTapResultsList"]);
        
        return KIFTestStepResultSuccess;
        
    }]];
    
    return scenario;
}

+ (id)scenarioUnitTestCreateSearchBarWithAccessibilityLabel
{
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Test search bar creation with accessibility label"];
    
    [scenario addStep:[KIFTestStep stepWithDescription:scenario.description executionBlock:^KIFTestStepResult(KIFTestStep *step, NSError **outError) {
        
        NSError *error = nil;
        
        WFSSchema *searchBarSchema = [[WFSSchema alloc] initWithTypeName:@"searchBar" attributes:@{@"name":@"foo"} parameters:@[
                                          [[WFSSchemaParameter alloc] initWithName:@"accessibilityLabel" value:@"fum"]
                                     ]];
        
        WSTTestContext *context = [[WSTTestContext alloc] init];
        
        WFSSearchBar *searchBar = (WFSSearchBar *)[searchBarSchema createObjectWithContext:context error:&error];
        WSTFailOnError(error);
        WSTAssert([searchBar isKindOfClass:[WFSSearchBar class]]);
        
        WSTAssert(searchBar.validations.count == 0);
        WSTAssert([searchBar.workflowName isEqual:@"foo"]);
        WSTAssert([searchBar.accessibilityLabel isEqual:@"fum"]);
        
        return KIFTestStepResultSuccess;
        
    }]];
    
    return scenario;
}

+ (id)scenarioUnitTestCreateSearchBarWithoutPlaceholderOrAccessibilityLabel
{
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Test search bar creation without placeholder or accessibility label"];
    
    [scenario addStep:[KIFTestStep stepWithDescription:scenario.description executionBlock:^KIFTestStepResult(KIFTestStep *step, NSError **outError) {
        
        NSError *error = nil;
        
        WFSSchema *searchBarSchema = [[WFSSchema alloc] initWithTypeName:@"searchBar" attributes:@{@"name":@"foo"} parameters:@[
                                          [[WFSSchemaParameter alloc] initWithName:@"text" value:@"bar"]
                                     ]];
        
        WSTTestContext *context = [[WSTTestContext alloc] init];
        
        WFSSearchBar *searchBar = (WFSSearchBar *)[searchBarSchema createObjectWithContext:context error:&error];
        WSTAssert(searchBar == nil);
        WSTAssert(error);
        
        return KIFTestStepResultSuccess;
        
    }]];
    
    return scenario;
}

@end
