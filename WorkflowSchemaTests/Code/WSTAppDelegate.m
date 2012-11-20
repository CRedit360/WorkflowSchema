//
//  WSTAppDelegate.m
//  WorkflowSchemaTests
//
//  Created by Simon Booth on 22/10/2012.
//  Copyright (c) 2012 CRedit360. All rights reserved.
//

#import "WSTAppDelegate.h"
#import "WSTTestController.h"
#import "WSTTestAction.h"
#import <WorkflowSchema/WorkflowSchema.h>
#import <UISS/UISS.h>
#import <MBProgressHUD/MBProgressHUD.h>

@interface WSTAppDelegate () <WFSContextDelegate>

@end

@implementation WSTAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{   
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor blackColor];
    
    UIViewController *viewController = [[UIViewController alloc] init];
    UILabel *label = [[UILabel alloc] init];
    label.text = @"Tests will begin soon";
    label.textAlignment = UITextAlignmentCenter;
    viewController.view = label;
    
    self.window.rootViewController = viewController;
    [self.window makeKeyAndVisible];
    
    if ([[[[NSProcessInfo processInfo] environment] objectForKey:@"WST_WRITE_DTD"] boolValue])
    {
        [self writeDTD];
        exit(0);
    }
    
    if ([[[[NSProcessInfo processInfo] environment] objectForKey:@"WST_WRITE_XSD"] boolValue])
    {
        [self writeXSD];
        exit(0);
    }
    
    [WFSSchema registerClass:[WSTTestAction class] forTypeName:@"testAction"];
    
    [[WSTTestController sharedInstance] startTestingWithCompletionBlock:^{
        exit([[WSTTestController sharedInstance] failureCount]);
    }];
    
    return YES;
}

- (WFSSchema *)loadSchemaWithFile:(NSString *)fileName
{
    // Pretend this takes a while to emulate network lag
    sleep(1);
    
    NSString *path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:fileName];
    NSURL *xmlURL = [NSURL fileURLWithPath:path];
    
    NSError *error = nil;
    WFSSchema *schema = nil;
    
    @try
    {
        schema = [[[WFSXMLParser alloc] initWithContentsOfURL:xmlURL] parse:&error];
    }
    @catch (NSException *exception)
    {
        if (!error) error = WFSErrorFromException(exception);
        schema = nil;
    }
    
    if (error) [self context:nil didReceiveWorkflowError:error];
    return schema;
}

- (void)setupWindowWithWorkflowFile:(NSString *)fileName
{
    WFSSchema *schema = [self loadSchemaWithFile:fileName];
    WFSContext *context = [WFSContext contextWithDelegate:self];
    
    // New classes may have been registered, so we need to reconfigure UISS.
    [UISS configureWithDefaultJSONFile];
    
    NSError *error;
    UIViewController *controller = (UIViewController *)[schema createObjectWithContext:context error:&error];
    
    if ([controller isKindOfClass:[UIViewController class]])
    {
        self.window.hidden = YES;
        [self.window resignKeyWindow];
        
        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        self.window.backgroundColor = [UIColor blackColor];
        
        self.window.rootViewController = controller;
        [self.window makeKeyAndVisible];
    }
    else
    {
        [NSException raise:@"WSTAppDelegateException" format:@"Failed to load controller at %@: %@", fileName, error];
    }
}

#pragma mark - Workflow delegate

- (void)context:(WFSContext *)contect didReceiveWorkflowError:(NSError *)error
{
    [[[UIAlertView alloc] initWithTitle:@"Workflow error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
}

- (BOOL)context:(WFSContext *)context didReceiveWorkflowMessage:(WFSMessage *)message
{
    if ([message.name isEqualToString:WFSLoadSchemaActionMessageName])
    {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.window animated:YES];
        hud.labelText = @"Loading...";
        
        WFSResult *response = [WFSResult failureResultWithContext:message.context];
        
        NSString *path = message.context.parameters[WFSLoadSchemaActionPathKey];
        WFSSchema *schema = [self loadSchemaWithFile:path];
        
        if (schema)
        {
            WFSMutableContext *resultContext = [message.context mutableCopy];
            resultContext.parameters = @{ WFSLoadSchemaActionSchemaKey : schema };
            response = [WFSResult successResultWithContext:resultContext];
        }
        
        [MBProgressHUD hideAllHUDsForView:self.window animated:YES];
        [message respondWithResult:response];
        return YES;
    }
    else if ([[self.messageData objectForKey:message.destinationName] isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *data = self.messageData[message.destinationName][message.name];
        if ([data isKindOfClass:[NSDictionary class]])
        {
            WFSMutableContext *resultContext = [message.context mutableCopy];
            resultContext.parameters = data;
            WFSResult *response = [WFSResult successResultWithContext:resultContext];
            [message respondWithResult:response];
            return YES;
        }
    }
    
    return NO;
}

#pragma mark - Outputting documentation

- (void)writeDTD
{
    NSString *dtd = [WFSSchema documentTypeDescription];
    NSString *path = [NSTemporaryDirectory() stringByAppendingString:@"workflow.dtd"];
    NSError *error = nil;
    
    if ([dtd writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:&error])
    {
        NSLog(@"Wrote DTD to %@", path);
    }
    else
    {
        NSLog(@"Error writing DTD to %@: %@", path, error.localizedDescription);
    }
}

- (void)writeXSD
{
    NSString *xsd = [WFSSchema xmlSchemaDefinition];
    NSString *path = [NSTemporaryDirectory() stringByAppendingString:@"workflow.xsd"];
    NSError *error = nil;
    
    if ([xsd writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:&error])
    {
        NSLog(@"Wrote XSD to %@", path);
    }
    else
    {
        NSLog(@"Error writing XSD to %@: %@", path, error.localizedDescription);
    }
}

@end
