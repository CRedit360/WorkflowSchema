//
//  WSTTestController.m
//  WorkflowSchemaTests
//
//  Created by Simon Booth on 22/10/2012.
//  Copyright (c) 2012 CRedit360. All rights reserved.
//

#import "WSTTestController.h"

@implementation WSTTestController

- (void)initializeScenarios
{
    NSString *prefix = [[[NSProcessInfo processInfo] environment] objectForKey:@"WST_TEST_PREFIX"];
    
    if (prefix)
    {
        [self addAllScenariosWithSelectorPrefix:prefix fromClass:[KIFTestScenario class]];
    }
    else
    {
        [self addAllScenarios];
    }
}

@end
