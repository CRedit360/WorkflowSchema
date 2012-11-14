//
//  WFSSchematising.h
//  WFSWorkflow
//
//  Created by Simon Booth on 16/10/2012.
//  Copyright (c) 2012 CRedit360. All rights reserved.
//

#import "WFSSchema.h"
#import "WFSContext.h"
#import "NSObject+WFSSchematising.h"

/*
 *  Defines the initialiser used when creating objects from a schema.
 *
 *  See also the NSObject(WFSSchematising) category for the methods that an object should
 *  override in order to tell the schema how to create it.
 */
@protocol WFSSchematising <NSObject>

- (id)initWithSchema:(WFSSchema *)schema context:(WFSContext *)context error:(NSError **)outError;

// these are implemented by NSObject(WFSSchematising) so there's no need to synthesize them.
- (WFSSchema *)workflowSchema;
- (WFSContext *)workflowContext;
- (NSString *)workflowName;

@end

#define WFS_SCHEMATISING_PROPERTY_INITITIALISATION \
self.workflowSchema = schema; \
self.workflowContext = context; \
self.workflowName = schema.workflowName;

#define WFS_SCHEMATISING_PARAMETER_INITIALISATION \
if (![self setParametersForSchema:schema context:context error:outError]) return nil;

#define WFS_SCHEMATISING_INITIALISATION \
WFS_SCHEMATISING_PROPERTY_INITITIALISATION \
WFS_SCHEMATISING_PARAMETER_INITIALISATION