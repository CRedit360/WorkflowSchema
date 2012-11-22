//
// RUIRemoteController.m.h
// 
// Created on 2012-10-11 using NibFree
// 

#import "WFSScreenController.h"
#import "UIViewController+WFSSchematising.h"

#import "WFSAction.h"
#import "WFSBarButtonItem.h"
#import "WFSTabBarItem.h"
#import "WFSMacros.h"

@interface WFSScreenController ()

@property (nonatomic, strong) WFSSchema *viewSchema;
@property (nonatomic, strong) WFSContext *viewContext;

@end

@implementation WFSScreenController

- (id)initWithSchema:(WFSSchema *)schema context:(WFSContext *)context error:(NSError **)outError
{
    self = [super init];
    if (self)
    {
        WFS_SCHEMATISING_INITIALISATION
    }
    return self;
}

+ (NSArray *)lazilyCreatedSchemaParameters
{
    return [[super lazilyCreatedSchemaParameters] arrayByAddingObject:@"view"];
}

+ (NSArray *)defaultSchemaParameters
{
    return [[super defaultSchemaParameters] arrayByPrependingObjectsFromArray:@[

            @[ [UIToolbar class], @"toolbar" ],
            @[ [UIView class], @"view"],
            @[ [UIViewController class], @"view"],
    
    ]];
}

+ (NSDictionary *)schemaParameterTypes
{
    return [[super schemaParameterTypes] dictionaryByAddingEntriesFromDictionary:@{
    
            @"view"    : @[ [UIView class], [UIViewController class] ],
            @"toolbar" : [UIToolbar class]

    }];
}

- (WFSMutableContext *)contextForSchemaParameters:(WFSContext *)context
{
    WFSMutableContext *subContext = [super contextForSchemaParameters:context];
    subContext.containerController = self;
    return subContext;
}

- (BOOL)setSchemaParameterWithName:(NSString *)name value:(id)value context:(WFSContext *)context error:(NSError *__autoreleasing *)outError
{
    if ([name isEqual:@"view"])
    {
        self.viewSchema = value;
        self.viewContext = context;
        
        return YES;
    }
    
    return [super setSchemaParameterWithName:name value:value context:context error:outError];
}

#pragma mark - View lifecycle

- (WFSScreenView *)screenView
{
    return WFSCastOrNil(self.view, WFSScreenView);
}

- (void)loadView
{
    NSError *error = nil;
    WFSScreenView *screenView = [[WFSScreenView alloc] initWithSchema:self.viewSchema context:self.viewContext error:&error];
    if (screenView)
    {
        screenView.toolbar = self.toolbar;
        self.view = screenView;
    }
    else
    {
        if (!error) error = WFSError(@"Failed to load view for screen controller");
        [self.workflowContext sendWorkflowError:error];
        [super loadView];
    }
}

#pragma mark - Actions

WFS_UIVIEWCONTROLLER_LIFECYCLE

@end

