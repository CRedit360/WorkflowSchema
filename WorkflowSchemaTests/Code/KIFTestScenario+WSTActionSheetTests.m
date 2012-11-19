//
//  KIFTestScenario+WSTAlertViewTests.m
//  WorkflowSchemaTests
//
//  Created by Simon Booth on 29/10/2012.
//  Copyright (c) 2012 CRedit360. All rights reserved.
//

#import "KIFTestScenario+WSTAlertViewTests.h"
#import "KIFTestStep+WSTShared.h"
#import "WSTAssert.h"
#import "WSTTestAction.h"
#import "WSTTestContext.h"

@implementation KIFTestScenario (WSTAlertViewTests)

+ (id)scenarioUnitTestActionSheetWithExplicitProperties
{
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Test showing an action sheet with explicit properties"];
    
    [scenario addStep:[KIFTestStep stepWithDescription:scenario.description executionBlock:^KIFTestStepResult(KIFTestStep *step, NSError **outError) {
        
        NSError *error = nil;
        
        WFSSchema *actionSchema = [[WFSSchema alloc] initWithTypeName:@"showActionSheet" attributes:nil parameters:@[
                                       [[WFSSchemaParameter alloc] initWithName:@"title" value:@"Test title"],
                                       [[WFSSchema alloc] initWithTypeName:@"cancelButtonItem" attributes:nil parameters:@[
                                            [[WFSSchemaParameter alloc] initWithName:@"title" value:@"Cancel"],
                                            [[WFSSchemaParameter alloc] initWithName:@"message" value:@"didCancel"]
                                       ]],
                                       [[WFSSchema alloc] initWithTypeName:@"actionButtonItem" attributes:nil parameters:@[
                                            [[WFSSchemaParameter alloc] initWithName:@"title" value:@"Salute"],
                                            [[WFSSchemaParameter alloc] initWithName:@"message" value:@"didSalute"]
                                       ]],
                                       [[WFSSchema alloc] initWithTypeName:@"actionButtonItem" attributes:nil parameters:@[
                                            [[WFSSchemaParameter alloc] initWithName:@"title" value:@"Paint"],
                                            [[WFSSchemaParameter alloc] initWithName:@"message" value:@"didPaint"]
                                       ]],
                                       [[WFSSchema alloc] initWithTypeName:@"destructiveButtonItem" attributes:nil parameters:@[
                                            [[WFSSchemaParameter alloc] initWithName:@"title" value:@"Destroy"],
                                            [[WFSSchemaParameter alloc] initWithName:@"message" value:@"didDestroy"]
                                       ]],
                                  ]];
        
        WSTTestContext *context = [[WSTTestContext alloc] init];
        
        WFSShowActionSheetAction *showActionSheetAction = (WFSShowActionSheetAction *)[actionSchema createObjectWithContext:context error:&error];
        WSTFailOnError(error);
        WSTAssert([showActionSheetAction isKindOfClass:[WFSShowActionSheetAction class]]);
        
        UIActionSheet *actionSheet = [showActionSheetAction actionSheetWithContext:context error:&error];
        WSTFailOnError(error);
        
        WSTAssert([actionSheet isKindOfClass:[UIActionSheet class]]);
        WSTAssert([actionSheet.title isEqual:@"Test title"]);
        
        // The destructive button comes first and the cancel button comes last; order of others is preserved.
        WSTAssert(actionSheet.numberOfButtons == 4);
        WSTAssert([[actionSheet buttonTitleAtIndex:0] isEqual:@"Destroy"]);
        WSTAssert([[actionSheet buttonTitleAtIndex:1] isEqual:@"Salute"]);
        WSTAssert([[actionSheet buttonTitleAtIndex:2] isEqual:@"Paint"]);
        WSTAssert([[actionSheet buttonTitleAtIndex:3] isEqual:@"Cancel"]);
        WSTAssert(actionSheet.destructiveButtonIndex == 0);
        WSTAssert(actionSheet.cancelButtonIndex == 3);
        
        // Clicking the button should perform the action
        WSTAssert(actionSheet.delegate == showActionSheetAction);
        [showActionSheetAction actionSheet:actionSheet clickedButtonAtIndex:0];
        WSTAssert([[[context.messages lastObject] name] isEqual:@"didDestroy"]);
        [showActionSheetAction actionSheet:actionSheet clickedButtonAtIndex:1];
        WSTAssert([[[context.messages lastObject] name] isEqual:@"didSalute"]);
        [showActionSheetAction actionSheet:actionSheet clickedButtonAtIndex:2];
        WSTAssert([[[context.messages lastObject] name] isEqual:@"didPaint"]);
        [showActionSheetAction actionSheet:actionSheet clickedButtonAtIndex:3];
        WSTAssert([[[context.messages lastObject] name] isEqual:@"didCancel"]);
        
        return KIFTestStepResultSuccess;
        
    }]];
    
    return scenario;
}

+ (id)scenarioUnitTestActionSheetWithOnlyOneButton
{
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Test showing an action sheet with only one button"];
    
    [scenario addStep:[KIFTestStep stepWithDescription:scenario.description executionBlock:^KIFTestStepResult(KIFTestStep *step, NSError **outError) {
        
        NSError *error = nil;
        
        WFSSchema *actionSchema = [[WFSSchema alloc] initWithTypeName:@"showActionSheet" attributes:nil parameters:@[
                                       [[WFSSchemaParameter alloc] initWithName:@"title" value:@"Test title"],
                                       [[WFSSchema alloc] initWithTypeName:@"cancelButtonItem" attributes:nil parameters:@[
                                            [[WFSSchemaParameter alloc] initWithName:@"title" value:@"Cancel"],
                                            [[WFSSchema alloc] initWithTypeName:@"testAction" attributes:nil parameters:nil]
                                       ]]
                                  ]];
        
        WSTTestContext *context = [[WSTTestContext alloc] init];
        
        WFSShowActionSheetAction *showActionSheetAction = (WFSShowActionSheetAction *)[actionSchema createObjectWithContext:context error:&error];
        WSTAssert(showActionSheetAction == nil);
        WSTAssert(error != nil);
        
        return KIFTestStepResultSuccess;
        
    }]];
    
    return scenario;
}
@end
