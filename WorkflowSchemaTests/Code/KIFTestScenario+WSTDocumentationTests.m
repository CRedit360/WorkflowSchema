//
//  KIFTestScenario+WSTDocumentationTests.m
//  WorkflowSchemaTests
//
//  Created by Simon Booth on 30/10/2012.
//  Copyright (c) 2012 CRedit360. All rights reserved.
//

#import "KIFTestScenario+WSTDocumentationTests.h"
#import "KIFTestStep+WSTShared.h"
#import "WSTAssert.h"
#import "WSTTestAction.h"
#import "WSTTestContext.h"
#import <WorkflowSchema/WorkflowSchema.h>

@implementation KIFTestScenario (WSTDocumentationTests)

+ (id)scenarioUnitTestDTD
{
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Test that we can create a valid DTD and that it validates the example XML (This may take some time)"];
    
    [scenario addStep:[KIFTestStep stepWithDescription:scenario.description executionBlock:^KIFTestStepResult(KIFTestStep *step, NSError **outError) {
        
        NSString *dtd = [WFSSchema documentTypeDescription];
        NSString *dtdPath = @"/var/tmp/workflow.dtd";
        NSString *logPath = @"/var/tmp/workflow.dtd.log";
        NSError *error = nil;
        
        BOOL didWriteDTD = [dtd writeToFile:dtdPath atomically:YES encoding:NSUTF8StringEncoding error:&error];
        WSTFailOnError(error);
        WSTAssert(didWriteDTD);
        
        NSArray *xmlPaths = [[NSBundle bundleForClass:[self class]] pathsForResourcesOfType:@"xml" inDirectory:nil];
        WSTAssert(xmlPaths.count > 0)
        
        for (NSString *xmlPath in xmlPaths)
        {
            NSString *command = [NSString stringWithFormat:@"xmllint --dtdvalid \"%@\" \"%@\" > \"%@\" 2>&1 || (cat %@; false)", dtdPath, xmlPath, logPath, logPath];
            int retval = system([command UTF8String]);
            WSTAssert(retval == 0);
        }
        
        return KIFTestStepResultSuccess;
        
    }]];
    
    return scenario;
}

+ (id)scenarioUnitTestXSD
{
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Test that we can create a valid XSD and that it validates the example XML (This may take some time)"];
    
    [scenario addStep:[KIFTestStep stepWithDescription:scenario.description executionBlock:^KIFTestStepResult(KIFTestStep *step, NSError **outError) {
        
        NSString *xsd = [WFSSchema xmlSchemaDefinition];
        NSString *xsdPath = @"/var/tmp/workflow.xsd";
        NSString *logPath = @"/var/tmp/workflow.xsd.log";
        NSError *error = nil;
        
        BOOL didWriteXSD = [xsd writeToFile:xsdPath atomically:YES encoding:NSUTF8StringEncoding error:&error];
        WSTFailOnError(error);
        WSTAssert(didWriteXSD);
        
        NSArray *xmlPaths = [[NSBundle bundleForClass:[self class]] pathsForResourcesOfType:@"xml" inDirectory:nil];
        WSTAssert(xmlPaths.count > 0)
        
        for (NSString *xmlPath in xmlPaths)
        {
            NSString *command = [NSString stringWithFormat:@"xmllint --schema \"%@\" \"%@\" > \"%@\" 2>&1 || (cat %@; false)", xsdPath, xmlPath, logPath, logPath];
            int retval = system([command UTF8String]);
            WSTAssert(retval == 0);
        }
        
        return KIFTestStepResultSuccess;
        
    }]];
    
    return scenario;
}

@end
