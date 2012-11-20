//
//  WFSContext.m
//  WFSWorkflow
//
//  Created by Simon Booth on 15/10/2012.
//  Copyright (c) 2012 CRedit360. All rights reserved.
//

#import "WFSContext.h"
#import "WFSMessage.h"

NSString * const WFSContextException = @"WFSContextException";

@interface WFSContext ()

@property (nonatomic, strong, readwrite) NSDictionary *parameters;

@property (nonatomic, weak, readwrite) id actionSender;
@property (nonatomic, weak, readwrite) UIViewController *containerController;

@property (nonatomic, weak, readwrite) id<WFSSchemaDelegate> schemaDelegate;
@property (nonatomic, weak, readwrite) id<WFSContextDelegate> contextDelegate;

@end

@implementation WFSContext

+ (WFSContext *)contextWithDelegate:(id<WFSContextDelegate>)delegate
{
    return [[self alloc] initWithDelegate:delegate];
}

- (id)init
{
    self = [super init];
    if (self)
    {
        _parameters = @{};
    }
    return self;
}

- (id)initWithDelegate:(id<WFSContextDelegate>)delegate
{
    self = [super init];
    if (self)
    {
        if (!delegate) [NSException raise:WFSContextException format:@"WFSContext must have a delegate"];
        _contextDelegate = delegate;
        _parameters = @{};
    }
    return self;
}

#pragma mark - Forwarding messages

- (void)sendWorkflowError:(NSError *)error
{
    return [self.contextDelegate context:self didReceiveWorkflowError:error];
}

- (BOOL)sendWorkflowMessage:(WFSMessage *)message
{
    return [self.contextDelegate context:self didReceiveWorkflowMessage:message];
}

#pragma mark - Copying and equating

- (id)copyWithZone:(NSZone *)zone
{
    return [self mutableCopyWithZone:zone];
}

- (id)mutableCopyWithZone:(NSZone *)zone
{
    WFSMutableContext *otherContext = [[WFSMutableContext allocWithZone:zone] init];
    
    otherContext.parameters = self.parameters;
    otherContext.actionSender = self.actionSender;
    otherContext.containerController = self.containerController;
    otherContext.contextDelegate = self.contextDelegate;
    otherContext.schemaDelegate = self.schemaDelegate;
    
    return otherContext;
}

- (BOOL)isEqual:(id)object
{
    WFSContext *otherContext = (WFSContext *)object;
    if (![otherContext isKindOfClass:[WFSContext class]]) return NO;
    
    return [otherContext.parameters isEqual:self.parameters] &&
            otherContext.actionSender == self.actionSender &&
            otherContext.containerController == self.containerController &&
            otherContext.contextDelegate == self.contextDelegate &&
            otherContext.schemaDelegate == self.schemaDelegate;
}

@end

@implementation WFSMutableContext

@end