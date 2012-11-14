//
//  WFSSchema+WFSGroupedParameters.h
//  WFSWorkflow
//
//  Created by Simon Booth on 19/10/2012.
//  Copyright (c) 2012 CRedit360. All rights reserved.
//

#import "WFSSchema.h"

@interface WFSSchema (WFSGroupedParameters)

- (Class)classForGroupedParameters;
- (NSDictionary *)groupedParametersWithContext:(WFSContext *)context error:(NSError **)outError;

@end
