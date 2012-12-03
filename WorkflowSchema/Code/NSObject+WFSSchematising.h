//
//  NSObject+WFSSchematising.h
//  WFSWorkflow
//
//  Created by Simon Booth on 17/10/2012.
//  Copyright (c) 2012 CRedit360. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WFSSchema.h"
#import "WFSSchemaParameter.h"
#import "WFSContext.h"
#import "WFSError.h"
#import "NSObject+WorkflowSchema.h"
#import "NSArray+WorkflowSchema.h"
#import "NSDictionary+WorkflowSchema.h"

typedef BOOL(^WFSParameterCallback)(NSString *name, id value, NSError **outError);

@interface NSObject (WFSSchematising)

/*
 *  This is the initialiser that will be used when creating the object
 */
- (id)initWithSchema:(WFSSchema *)schema context:(WFSContext *)context error:(NSError **)outError;

/*
 *  This is the schema that the object was created with
 */
@property (nonatomic, strong) WFSSchema *workflowSchema;

/*
 *  This is the context that the object was created with
 */

@property (nonatomic, strong) WFSContext *workflowContext;

/*
 *  This is a name that can be used to identify the element, e.g. in forms.
 */
@property (nonatomic, copy) NSString *workflowName;

/*
 *  If YES, then registering this class allows objects of this class to be created as part
 *  of a workflow schema.  If NO, then the class will be treated as abstract and only available
 *  for use in parameter proxies.
 */
+ (BOOL)isSchematisableClass;

/*
 *  A dictionary specifying all possible parameter names for the object as its keys, with the values
 *  being a class or array of classes which specify the allowed types of value for the parameter.
 */
+ (NSDictionary *)schemaParameterTypes;

/*
 *  If YES, then the accessibility parameters will be included in the schemaParameterTypes.
 */
+ (BOOL)includeAccessibilitySchemaParameters;

/*
 *  An array specifying the default parameter name for each type of value.  The contents are also arrays,
 *  with the first member being the type and the second being the parameter name.  For example:
 *
 *  @[
 *      @[ [NSString class], @"title" ],
 *      @[ [WFSAction class], @"action" ]
 *  ]
 *
 *  This specifies that the default parameter name for strings is "title" and the default for actions is "action".
 *
 */
+ (NSArray *)defaultSchemaParameters;

/*
 *  Any object which is lacking one of these will fail to initialise.
 */
+ (NSArray *)mandatorySchemaParameters;

/*
 *  Parameters which appear here can have multiple values. They will be passed to the object as an array, even if there is only one value.
 *  Parameters which do not appear here must only appear once, or else the object will fail to initialise.
 */
+ (NSArray *)arraySchemaParameters;

/*
 *  For parameters which appear here as keys, if the value is a string, it will be looked up in the key which should be a dictionary.
 */
+ (NSDictionary *)enumeratedSchemaParameters;

/*
 *  For parameters which appear here as keys, if the value is a string, it will be split up into its alphanumeric components.
 *  These will be looked up in the key which should be a dictionary, and the values will be ORed together.
 */
+ (NSDictionary *)bitmaskSchemaParameters;

/*
 *  Parameters which appear here will be passed to the object as a schema.
 *  Parameters that don't will be created from their schema before being passed to the object.
 */
+ (NSArray *)lazilyCreatedSchemaParameters;

/*
 *  Provides the context used when creating eagerly-loaded parameters.  This allows objects to insert
 *  themselves in the message delegate chain.
 */
- (WFSMutableContext *)contextForSchemaParameters:(WFSContext *)context;

/*
 *  Called to get the value of a parameter on an object.   The default implementation uses KVC to get the
 *  value on the named property, and then creates it if it finds another schema.  (You only need to use this
 *  if you have a lazily created string parameter)
 */
- (id)schemaParameterWithName:(NSString *)name context:(WFSContext *)context error:(NSError **)outError;

/*
 *  Called to set the value of a parameter on an object.  By this time the value has been eagerly loaded if appropriate,
 *  and the context is the one given by -[contextForSchemaParameters:].  The default implementation uses KVC to set the
 *  value on the named property, which is usually what you want.
 */
- (BOOL)setSchemaParameterWithName:(NSString *)name value:(id)value context:(WFSContext *)context error:(NSError **)outError;

/*
 *  This groups together the parameters of the schema, assigning them to defaults, wrapping them in arrays and eagerly 
 *  loading as appropriate, sets the values on the object and then outputs an error if any mandatory parameters were missing.
 *  It is used in the standard initialiser and it's unlikely you'll need to override it.
 */
- (BOOL)setParametersForSchema:(WFSSchema *)schema context:(WFSContext *)context error:(NSError **)outError;

@end
