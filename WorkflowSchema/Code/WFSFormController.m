//
// WFSFormController.m
// 
// Created on 2012-10-15 using NibFree
// 

#import "WFSFormController.h"
#import "WFSTextField.h"
#import "WFSCondition.h"
#import "WFSFormTrigger.h"
#import "WFSMacros.h"

#import "UIView+WorkflowSchema.h"

NSString * const WFSFormSubmitMessageName = @"submit";
NSString * const WFSFormDidSubmitActionName = @"didSubmit";
NSString * const WFSFormDidNotSubmitActionName = @"didNotSubmit";

@interface WFSFormController () <WFSSchemaDelegate, WFSFormInputDelegate>

@property (nonatomic, strong) WFSSchema *viewSchema;
@property (nonatomic, strong) WFSContext *viewContext;

@property (nonatomic, strong, readwrite) NSArray *allInputs;
@property (nonatomic, strong, readwrite) NSArray *responsiveInputs;
@property (nonatomic, strong, readwrite) NSDictionary *namedInputs;

@end

@implementation WFSFormController

- (id)initWithSchema:(WFSSchema *)schema context:(WFSContext *)context error:(NSError **)outError
{
    self = [super init];
    if (self)
    {
        _allInputs = [NSArray array];
        _responsiveInputs = [NSArray array];
        _namedInputs = [NSDictionary dictionary];
        
        WFS_SCHEMATISING_INITIALISATION
    }
    return self;
}

+ (NSArray *)mandatorySchemaParameters
{
    return [[super mandatorySchemaParameters] arrayByPrependingObject:@"view"];
}

+ (NSArray *)lazilyCreatedSchemaParameters
{
    return [[super lazilyCreatedSchemaParameters] arrayByPrependingObject:@"view"];
}

+ (NSArray *)arraySchemaParameters
{
    return [[super arraySchemaParameters] arrayByPrependingObjectsFromArray:@[ @"actions", @"triggers" ]];
}

+ (NSArray *)defaultSchemaParameters
{
    return [[super defaultSchemaParameters] arrayByPrependingObjectsFromArray:@[
    
            @[ [UIView class], @"view" ],
            @[ [UIViewController class], @"view" ],
            @[ [WFSFormTrigger class], @"triggers" ],
    
    ]];
}

+ (NSDictionary *)schemaParameterTypes
{
    return [[super schemaParameterTypes] dictionaryByAddingEntriesFromDictionary:@{
            
            @"view"          : @[ [UIView class], [UIViewController class] ],
            @"triggers"      : [WFSFormTrigger class]
    
    }];
}

- (WFSMutableContext *)contextForSchemaParameters:(WFSContext *)context
{
    WFSMutableContext *subContext = [super contextForSchemaParameters:context];
    subContext.containerController = self;
    subContext.schemaDelegate = self;
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

- (WFSFormView *)formView
{
    return WFSCastOrNil(self.view, WFSFormView);
}

- (void)loadView
{
    NSError *error = nil;
    WFSFormView *formView = [[WFSFormView alloc] initWithSchema:self.viewSchema context:self.viewContext error:&error];
    if (formView)
    {
        self.view = formView;
    }
    else
    {
        if (!error) error = WFSError(@"Failed to load view for form controller");
        [self.workflowContext sendWorkflowError:error];
        [super loadView];
    }
    
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    if (self.triggers.count > 0)
    {
        [WFSAction performWithActionAnimationsDisabled:^{
            
            [self runTriggers];
            
        }];
    }
}

#pragma mark - Object creation delegate

- (void)schema:(WFSSchema *)schema didCreateObject:(id<WFSSchematising>)object withContext:(WFSContext *)context
{
    if ([object conformsToProtocol:@protocol(WFSFormInput)])
    {
        id<WFSFormInput> formInput = (id<WFSFormInput>)object;
        
        self.allInputs = [self.allInputs arrayByAddingObject:formInput];
        
        NSString *name = formInput.workflowName;
        if (name)
        {
            id inputs = self.namedInputs[name];
            if (inputs)
            {
                inputs = [inputs flattenedArray];
                inputs = [inputs arrayByAddingObject:formInput];
                self.namedInputs = [self.namedInputs dictionaryByAddingEntriesFromDictionary:@{ name:inputs }];
            }
            else
            {
                self.namedInputs = [self.namedInputs dictionaryByAddingEntriesFromDictionary:@{ name:formInput }];
            }
        }
        
        if ([object isKindOfClass:[UIResponder class]])
        {
            self.responsiveInputs = [self.responsiveInputs arrayByAddingObject:object];
        }
        
        formInput.formInputDelegate = self;
    }
}

#pragma mark - Form and form input delegates

- (WFSMutableContext *)contextForPerformingActions:(WFSContext *)context
{
    NSMutableDictionary *formValues = [NSMutableDictionary dictionary];
    
    for (NSString *name in self.namedInputs.allKeys)
    {
        id input = self.namedInputs[name];
        formValues[name] = [input valueForKey:@"formValue"];
    }
    
    WFSMutableContext *subContext = [super contextForPerformingActions:context];
    subContext.parameters = [subContext.parameters dictionaryByAddingEntriesFromDictionary:formValues];
    return subContext;
}

- (BOOL)validateFormInput:(id<WFSFormInput>)formInput context:(WFSContext *)context
{
    WFSMutableContext *conditionContext = [context mutableCopy];
    conditionContext.actionSender = formInput;
    
    for (WFSCondition *condition in formInput.validations)
    {
        BOOL valid = [condition evaluateWithValue:formInput.formValue context:conditionContext];
        if (!valid)
        {
            if (condition.failureMessage)
            {
                conditionContext.parameters = [conditionContext.parameters dictionaryByAddingEntriesFromDictionary:@{ @"failureMessage" : condition.failureMessage }];
            }
            
            [self performActionName:WFSFormDidNotSubmitActionName context:conditionContext];
            return NO;
        }
    }
    
    return YES;
}

- (WFSResult *)submitForm
{
    WFSContext *context = [self contextForPerformingActions:self.workflowContext];
    
    for (id<WFSFormInput> formInput in self.allInputs)
    {
        if (![self validateFormInput:formInput context:context])
        {
            if ([formInput isKindOfClass:[UIResponder class]])
            {
                UIResponder *responsiveInput = formInput;
                if ([responsiveInput canBecomeFirstResponder])
                {
                    [responsiveInput becomeFirstResponder];
                }
            }

            return [WFSResult failureResultWithContext:context];
        }
    }
    
    [self.formView endEditing:YES];
    return [self performActionName:WFSFormDidSubmitActionName context:context];
}

- (BOOL)formInputShouldReturn:(id<WFSFormInput>)formInput
{
    if ([self canFocusNextInput:formInput])
    {
        return [self focusNextInput:formInput];
    }
    else
    {
        WFSResult *result = [self submitForm];
        return result.isSuccess;
    }
}

- (void)formInputDidEndEditing:(id<WFSFormInput>)formInput
{
    [self runTriggers];
}

- (BOOL)canFocusPreviousInput:(id<WFSFormInput>)currentInput
{
    if ([self.responsiveInputs containsObject:currentInput])
    {
        NSInteger index = [self.responsiveInputs indexOfObject:currentInput];
        for (NSInteger i = index-1; i >= 0; i--)
        {
            UIResponder *input = self.responsiveInputs[i];
            if ([input canBecomeFirstResponder])
            {
                return YES;
            }
        }
    }
    
    return NO;
}

- (BOOL)focusPreviousInput:(id<WFSFormInput>)currentInput
{
    WFSContext *context = [self contextForPerformingActions:self.workflowContext];
    [self runTriggersInContext:context];
    
    if (![self validateFormInput:currentInput context:context])
    {
        return NO;
    }
    
    if ([self.responsiveInputs containsObject:currentInput])
    {
        UIResponder *previousInput = nil;
        
        NSInteger index = [self.responsiveInputs indexOfObject:currentInput];
        for (NSInteger i = index-1; i >= 0; i--)
        {
            UIResponder *input = self.responsiveInputs[i];
            if ([input canBecomeFirstResponder])
            {
                previousInput = input;
                break;
            }
        }
        
        if (previousInput)
        {
            [previousInput becomeFirstResponder];
            return YES;
        }
    }
    
    return NO;
}

- (BOOL)canFocusNextInput:(id<WFSFormInput>)currentInput
{
    if ([self.responsiveInputs containsObject:currentInput])
    {
        NSInteger index = [self.responsiveInputs indexOfObject:currentInput];
        for (NSInteger i = index+1; i < self.responsiveInputs.count; i++)
        {
            UIResponder *input = self.responsiveInputs[i];
            if ([input canBecomeFirstResponder])
            {
                return YES;
            }
        }
    }
    
    return NO;
}

- (BOOL)focusNextInput:(id<WFSFormInput>)currentInput
{
    WFSContext *context = [self contextForPerformingActions:self.workflowContext];
    [self runTriggersInContext:context];
    
    if (![self validateFormInput:currentInput context:context])
    {
        return NO;
    }
    
    if ([self.responsiveInputs containsObject:currentInput])
    {
        UIResponder *nextInput = nil;
        
        NSInteger index = [self.responsiveInputs indexOfObject:currentInput];
        for (NSInteger i = index+1; i < self.responsiveInputs.count; i++)
        {
            UIResponder *input = self.responsiveInputs[i];
            if ([input canBecomeFirstResponder])
            {
                nextInput = input;
                break;
            }
        }
        
        if (nextInput)
        {
            [nextInput becomeFirstResponder];
            return YES;
        }
    }
    
    return NO;
}

- (void)runTriggers
{
    WFSContext *context = [self contextForPerformingActions:self.workflowContext];
    [self runTriggersInContext:context];
}

- (void)runTriggersInContext:(WFSContext *)context
{
    for (WFSFormTrigger *trigger in self.triggers)
    {
        [trigger fireWithContext:context];
    }
}

#pragma mark - Actions

- (WFSResult *)performActionName:(NSString *)name context:(WFSContext *)context
{
    if ([name isEqualToString:WFSFormSubmitMessageName])
    {
        return [self submitForm];
    }
    else
    {
        return [super performActionName:name context:context];
    }
}

@end

