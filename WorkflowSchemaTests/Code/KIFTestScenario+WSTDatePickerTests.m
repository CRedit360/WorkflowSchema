//
//  KIFTestScenario+WSTDatePickerTests.m
//  WorkflowSchemaTests
//
//  Created by Simon Booth on 27/11/2012.
//  Copyright (c) 2012 CRedit360. All rights reserved.
//

#import "KIFTestScenario+WSTDatePickerTests.h"
#import "KIFTestStep+WSTShared.h"
#import "WSTAssert.h"
#import "WSTTestAction.h"
#import "WSTTestContext.h"
#import <WorkflowSchema/WorkflowSchema.h>

@implementation KIFTestScenario (WSTDatePickerTests)

+ (id)scenarioUnitTestCreateDatePicker
{
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Test date picker creation"];
    
    [scenario addStep:[KIFTestStep stepWithDescription:scenario.description executionBlock:^KIFTestStepResult(KIFTestStep *step, NSError **outError) {
        
        NSError *error = nil;
        
        WFSSchema *pickerSchema = [[WFSSchema alloc] initWithTypeName:@"datePicker" attributes:nil parameters:@[
                                       [[WFSSchemaParameter alloc] initWithName:@"date" value:@"2012/11/10"],
                                       [[WFSSchemaParameter alloc] initWithName:@"minimumDate" value:@"2011/11/10"],
                                       [[WFSSchemaParameter alloc] initWithName:@"maximumDate" value:@"2013/11/10"],
                                       [[WFSSchema alloc] initWithTypeName:@"message" attributes:nil parameters:@[ @"didPickDate" ]]
                                  ]];
        
        WSTTestContext *context = [[WSTTestContext alloc] init];
        
        WFSDatePicker *picker = (WFSDatePicker *)[pickerSchema createObjectWithContext:context error:&error];
        WSTFailOnError(error);
        
        [picker sendActionsForControlEvents:UIControlEventValueChanged];
        WSTAssert([[[context.messages lastObject] name] isEqual:@"didPickDate"]);
        
        return KIFTestStepResultSuccess;
        
    }]];
    
    return scenario;
}

@end
