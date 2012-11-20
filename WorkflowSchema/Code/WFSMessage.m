//
//  WFSMessage.m
//  WorkflowSchema
//
//  Created by Simon Booth on 29/10/2012.
//  Copyright (c) 2012 CRedit360. All rights reserved.
//

#import "WFSMessage.h"
#import "WFSSchema+WFSGroupedParameters.h"

@implementation WFSMessage

+ (WFSMessage *)messageWithName:(NSString *)name context:(WFSContext *)context responseHandler:(WFSMessageResponseHandler)responseHandler
{
    return [[self alloc] initWithName:name context:context responseHandler:responseHandler];
}

+ (WFSMessage *)messageWithName:(NSString *)name destinationType:(WFSMessageDestinationType)destinationType destinationName:(NSString *)destinationName context:(WFSContext *)context responseHandler:(WFSMessageResponseHandler)responseHandler
{
    return [[self alloc] initWithName:name destinationType:destinationType destinationName:destinationName context:context responseHandler:responseHandler];
}

#pragma mark - Direct initialisation

- (id)initWithName:(NSString *)name context:(WFSContext *)context responseHandler:(WFSMessageResponseHandler)responseHandler
{
    return [self initWithName:name destinationType:WFSMessageDestinationDelegate destinationName:nil context:context responseHandler:responseHandler];
}

- (id)initWithName:(NSString *)name destinationType:(WFSMessageDestinationType)destinationType destinationName:(NSString *)destinationName context:(WFSContext *)context responseHandler:(WFSMessageResponseHandler)responseHandler
{
    self = [super init];
    if (self)
    {
        _name = [name copy];
        _destinationType = destinationType;
        _destinationName = [destinationName copy];
        _responseHandler = [responseHandler copy];
        
        self.workflowContext = context;
    }
    return self;
}

#pragma mark - Schema initialisation

+ (NSArray *)mandatorySchemaParameters
{
    return [[super mandatorySchemaParameters] arrayByAddingObject:@"name"];
}

+ (NSArray *)defaultSchemaParameters
{
    return [[super defaultSchemaParameters] arrayByPrependingObject:@[ [NSString class], @"name" ]];
}

+ (NSDictionary *)enumeratedSchemaParameters
{
    return [[super enumeratedSchemaParameters] dictionaryByAddingEntriesFromDictionary:@{
            
            @"destinationType" : @{
            
                    @"delegate"     : @(WFSMessageDestinationDelegate),
                    @"rootDelegate" : @(WFSMessageDestinationRootDelegate),
                    @"self"         : @(WFSMessageDestinationSelf),
                    @"descendant"   : @(WFSMessageDestinationDescendant)
            
            }
            
    }];
}

+ (NSDictionary *)schemaParameterTypes
{
    return [[super schemaParameterTypes] dictionaryByAddingEntriesFromDictionary:@{
    
            @"name" :            [NSString class],
            @"destinationType" : @[ [NSString class], [NSNumber class] ],
            @"destinationName" : [NSString class]
            
    }];
}

- (id)initWithSchema:(WFSSchema *)schema context:(WFSContext *)context error:(NSError **)outError
{
    NSDictionary *groupedParameters = [schema groupedParametersWithContext:context error:outError];
    
    NSString *name = groupedParameters[@"name"];
    WFSMessageDestinationType destinationType = [groupedParameters[@"destinationType"] integerValue];
    NSString *destinationName = groupedParameters[@"destinationName"];
    
    self = [self initWithName:name destinationType:destinationType destinationName:destinationName context:context responseHandler:nil];
    if (self)
    {
        WFS_SCHEMATISING_INITIALISATION
    }
    return self;
}

- (BOOL)setSchemaParameterWithName:(NSString *)name value:(id)value context:(WFSContext *)context error:(NSError *__autoreleasing *)outError
{
    if ([@[@"name", @"destinationType", @"destinationName"] containsObject:name]) return YES; // These were done before initialising
    return [super setSchemaParameterWithName:name value:value context:context error:outError];
}

#pragma mark - Context shorthand

- (WFSContext *)context
{
    return self.workflowContext;
}

- (void)setContext:(WFSContext *)context
{
    self.workflowContext = context;
}

#pragma mark - Responding

- (void)respondWithResult:(WFSResult *)result
{
    __block WFSMessageResponseHandler handler = self.responseHandler;
    if (!handler) return;
    
    dispatch_queue_t main_queue = dispatch_get_main_queue();
    dispatch_queue_t this_queue = dispatch_get_current_queue();
    
    if (this_queue == main_queue)
    {
        handler(result);
    }
    else
    {
        dispatch_async(main_queue, ^{
            handler(result);
        });
    }
}

@end
