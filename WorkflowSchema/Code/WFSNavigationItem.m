//
//  WFSNavigationItem.m
//  WFSWorkflow
//
//  Created by Simon Booth on 18/10/2012.
//  Copyright (c) 2012 CRedit360. All rights reserved.
//

#import "WFSNavigationItem.h"
#import "WFSNavigationItemHelper.h"

@implementation WFSNavigationItem

- (id)initWithSchema:(WFSSchema *)schema context:(WFSContext *)context error:(NSError **)outError
{
    if (outError) *outError = WFSError(@"WFSNavigationItem is a placeholder which should not be initialised.");
    return nil;
}

+ (NSArray *)mandatorySchemaParameters
{
    return [WFSNavigationItemHelper mandatorySchemaParameters];
}

+ (NSArray *)arraySchemaParameters
{
    return [WFSNavigationItemHelper arraySchemaParameters];
}

+ (NSDictionary *)schemaParameterTypes
{
    return [WFSNavigationItemHelper schemaParameterTypes];
}

@end
