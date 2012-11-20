//
//  WFSTableViewController.m
//  WFSWorkflow
//
//  Created by Simon Booth on 17/10/2012.
//  Copyright (c) 2012 CRedit360. All rights reserved.
//

#import "WFSTableController.h"
#import "WFSTableSection.h"
#import "WFSTableCell.h"

#import "WFSSchema+WFSGroupedParameters.h"
#import "UIViewController+WFSSchematising.h"

NSString * const WFSTableDidSelectCellActionName = @"didSelectCell";

@interface WFSTableController () <WFSContextDelegate>

@property (nonatomic, strong) NSArray *cachedSections;
@end

@implementation WFSTableController

- (id)initWithSchema:(WFSSchema *)schema context:(WFSContext *)context error:(NSError **)outError
{
    NSDictionary *groupedParameters = [schema groupedParametersWithContext:context error:outError];
    if (!groupedParameters) return nil;
    
    UITableViewStyle style = UITableViewStylePlain;
    id styleParameter = groupedParameters[@"style"];
    if (styleParameter)
    {
        NSNumber *styleNumber = nil;
        
        if ([styleParameter isKindOfClass:[NSNumber class]])
        {
            styleNumber = styleParameter;
        }
        else if ([styleParameter isKindOfClass:[NSString class]])
        {
            styleNumber = @{ @"plain":@(UITableViewStylePlain), @"grouped":@(UITableViewStyleGrouped) }[styleParameter];
        }
        
        style = [styleNumber integerValue];
    }
    
    self = [super initWithStyle:style];
    if (self)
    {
        WFS_SCHEMATISING_INITIALISATION
    }
    return self;
}

+ (NSArray *)lazilyCreatedSchemaParameters
{
    return [[super lazilyCreatedSchemaParameters] arrayByAddingObjectsFromArray:@[
            
            @"sections",
            @"tableHeaderView",
            @"tableFooterView"
            
    ]];
}

+ (NSArray *)mandatorySchemaParameters
{
    return [[super mandatorySchemaParameters] arrayByAddingObject:@"sections"];
}

+ (NSArray *)arraySchemaParameters
{
    return [[super arraySchemaParameters] arrayByAddingObjectsFromArray:@[ @"sections" ]];
}

+ (NSArray *)defaultSchemaParameters
{
    return [[super defaultSchemaParameters] arrayByPrependingObjectsFromArray:@[
    
            @[ [WFSTableSection class], @"sections" ]
            
    ]];
}

+ (NSDictionary *)schemaParameterTypes
{
    return [[super schemaParameterTypes] dictionaryByAddingEntriesFromDictionary:@{
    
            @"style" : @[ [NSString class], [NSNumber class] ],
            @"sections" : [WFSTableSection class],
            @"tableHeaderView" : [UIView class],
            @"tableFooterView" : [UIView class],

    }];
}

- (BOOL)setSchemaParameterWithName:(NSString *)name value:(id)value context:(WFSContext *)context error:(NSError *__autoreleasing *)outError
{
    if ([name isEqualToString:@"style"])
    {
        return YES;
    }
        
    return [super setSchemaParameterWithName:name value:value context:context error:outError];
}

#pragma mark - Section cache

- (void)clearCachedContextValues
{
    [super clearCachedContextValues];
    _cachedSections = nil;
}

- (NSArray *)cachedSections
{
    if (!_cachedSections)
    {
        NSError *error = nil;
        
        WFSContext *context = [self contextForSchemaParameters:self.workflowContext];
        _cachedSections = [self schemaParameterWithName:@"sections" context:context error:&error];
        
        if (error)
        {
            [context sendWorkflowError:error];
            _cachedSections = nil;
        }
    }
    
    return _cachedSections;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    WFSContext *context = [self contextForSchemaParameters:self.workflowContext];
    NSError *error = nil;
    
    UIView *tableHeaderView = [self schemaParameterWithName:@"tableHeaderView" context:context error:&error];
    if (tableHeaderView)
    {
        [tableHeaderView sizeToFit];
        self.tableView.tableHeaderView = tableHeaderView;
    }
    
    UIView *tableFooterView = [self schemaParameterWithName:@"tableFooterView" context:context error:&error];
    if (tableFooterView)
    {
        [tableFooterView sizeToFit];
        self.tableView.tableFooterView = tableFooterView;
    }
    
    if (error) [context sendWorkflowError:error];
}

- (void)reloadData
{
    [self.tableView reloadData];
}

#pragma mark - Table view delegate and data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.cachedSections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ((WFSTableSection *)self.cachedSections[section]).cells.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = ((WFSTableSection *)self.cachedSections[indexPath.section]).cells[indexPath.row];
    
    if (!cell)
    {
        [self.workflowContext sendWorkflowError:WFSError(@"Failed to create cell")];
        cell = [[UITableViewCell alloc] init];
    }
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return ((WFSTableSection *)self.cachedSections[section]).headerTitle;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    return ((WFSTableSection *)self.cachedSections[section]).footerTitle;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell<WFSTableCellSchematising> *cell = (UITableViewCell<WFSTableCellSchematising> *)[tableView cellForRowAtIndexPath:indexPath];
    if (cell.message) [cell sendMessageFromParameterWithName:@"message" context:cell.workflowContext];
    else [self performActionName:WFSTableDidSelectCellActionName context:cell.workflowContext];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell<WFSTableCellSchematising> *cell = (UITableViewCell<WFSTableCellSchematising> *)[tableView cellForRowAtIndexPath:indexPath];
    if (cell.detailDisclosureMessage) [cell sendMessageFromParameterWithName:@"detailDisclosureMessage" context:cell.workflowContext];
}

@end
