WorkflowSchema
==============

WorkflowSchema is an iOS framework which allows you to define app workflows in XML.

Setup
-----

The quickest way to add WorkflowSchema to your project is by using [CocoaPods](http://cocoapods.org).  Add the following to your podfile:

```ruby
pod 'WorkflowSchema', '~> 0.2.0'
```

and then 

```sh
$ pod install
```

To add WorkflowSchema to a project without using cocoapods, you need to install [https://github.com/kstenerud/iOS-Universal-Framework](iOS-Universal-Framework).  Then check out the source and then drag WorkflowSchema.xcodeproj into the project's frameworks group:

![WorkflowSchema.xcodeproj in the project's frameworks group](http://credit360.github.com/WorkflowSchema/readme_images/add_framework.png)

Under "Build Phases", add the framework to "Target Dependencies" and "Link Binary With Libraries":

![WorkflowSchema.xcodeproj in the project's frameworks group](http://credit360.github.com/WorkflowSchema/readme_images/build_phases.png)

Either way, you should now be able to access WorkflowSchema from your own source code.  In your app delegate (or wherever you want to use WorkflowSchema), load a schema:

```ObjC
#import <WorkflowSchema/WorkflowSchema.h>

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{   
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    NSError *error = nil;
    NSURL *xmlURL = [NSURL fileURLWithPath:@"/path/to/your/file.xml"];
    WFSSchema *schema = [[[WFSXMLParser alloc] initWithContentsOfURL:xmlURL] parse:&error];
```

Now create a context and create the schema's root object:

```ObjC
    WFSContext *context = [WFSContext contextWithDelegate:self];
    UIViewController *controller = (UIViewController *)[schema createObjectWithContext:context error:&error];
    
    self.window.rootViewController = controller;
    [self.window makeKeyAndVisible];
    
    return YES;
}
```

You'll have to implement WFSContextDelegate:

```ObjC
- (void)context:(WFSContext *)contect didReceiveWorkflowError:(NSError *)error
{
    [[[UIAlertView alloc] initWithTitle:@"Workflow error" 
                                message:error.localizedDescription
                               delegate:nil
                      cancelButtonTitle:@"OK" 
                      otherButtonTitles:nil] show];
}

- (BOOL)context:(WFSContext *)contect didReceiveWorkflowMessage:(WFSMessage *)message
{
    return NO;
}
```

You're now ready to go.

Schemata
--------

A workflow schema encapsulates a controller and its view, as well as actions that can be performed in response to user input.

A simple schema might look like this:

```xml
<workflow>
    <navigation>
        <screen>
            <title>Example</title>
            <view>
                <container>
                    <label>Example label</label>
                    <button>
                        <title>Example button</title>
                        <message>exampleButtonTapped</message>
                    </button>
                </container>
            </view>
            <actions>
                <showAlert name="exampleButtonTapped">Example button tapped!</showAlert>
            </actions>
        </screen>
    </navigation>
</workflow>
```

This represents a navigation controller and its contents, which might be shown to the user like this:

![Navigation controller containing screen with title, label and button](http://credit360.github.com/WorkflowSchema/readme_images/example1.png)

It also specifies that when the button is tapped, this happens:

![An alert has been show reading 'Example button tapped1'](http://credit360.github.com/WorkflowSchema/readme_images/example1-tapped.png)

Objects and parameters
----------------------

The basic structure of a schema is that object tags contain parameter tags, which contain object tags.  Object tags instruct the framework to create an object, and parameter tags instruct the framework to set a property on the object.

So, in our example, the `<screen>` tag represents a `WFSScreenController` object, which has three parameters: `title`, `view` and `actions`.  The title parameter contains a string ("Example")' the `view` contains a `WFSContainerView`, and the `actions` contains a `WFSShowAlertAction`.

In order to keep the files small, the framework supports *default parameters*.  This means that an object tag can appear inside another object tag, and the framework works out what parameter it belongs to.  In our example, this happens a few times: Firstly, the `<navigation>` tag represents a `WFSNavigationController` object, and as mentioned before the `<screen>` tag represents a `WFSScreenController` object.  `WFSNavigationController` has a parameter called `viewControllers`, which is the default for objects which inherit from `UIViewController`; `WFSScreenController` is a subclass of `UIViewController`, so the screen controller is assigned to the navigation controller's `viewControllers` property.  The same happens with the container's `views` property, the label's `text` property and the alert action's message property.  The example XML could have been equivalently written:


```xml
<workflow>
    <navigation>
        <viewControllers>
            <screen>
                <title>Example</title>
                <view>
                    <container>
                        <views>
                            <label>
                                <text>Example label</text>
                            </label>
                            <button>
                                <title>Example button</title>
                                <message>exampleButtonTapped</message>
                            </button>
                        </views>
                    </container>
                </view>
                <actions>
                    <showAlert name="exampleButtonTapped">
                        <message>Example button tapped!</message>
                    </showAlert>
                </actions>
            </screen>
        </viewControllers>
    </navigation>
</workflow>
```

Or, since `view` is the default for view objects, and `actions` is the default for action objects,


```xml
<workflow>
    <navigation>
        <screen>
            <title>Example</title>
            <container>
                <label>Example label</label>
                <button>
                    <title>Example button</title>
                    <message>exampleButtonTapped</message>
                </button>
            </container>
            <showAlert name="exampleButtonTapped">Example button tapped!</showAlert>
        </screen>
    </navigation>
</workflow>
```

Objects can have names. In our example, the `showAlert` tag has the name `exampleButtonTapped`.

Actions and Messages
--------------------

When the user interacts with a view, it can tell its controller to perform an action.  Looking again at our first example:

```xml
<workflow>
    <navigation>
        <screen>
            <title>Example</title>
            <view>
                <container>
                    <label>Example label</label>
                    <button>
                        <title>Example button</title>
                        <message>exampleButtonTapped</message>
                    </button>
                </container>
            </view>
            <actions>
                <showAlert name="exampleButtonTapped">Example button tapped!</showAlert>
            </actions>
        </screen>
    </navigation>
</workflow>
```

The button has a `message` property, which specifies the message that it sends to the controller when it is tapped.  When the controller to receives the message, it tries to perform the action with the same name as the message - in this case `exampleButtonTapped`, which shows an alert.

Different actions can do different things.  For example, we can push another screen onto the navigation stack:

```xml
<workflow>
    <navigation>
        <screen>
            <title>Example</title>
            <view>
                <container>
                    <label>Example label</label>
                    <button>
                        <title>Example button</title>
                        <message>exampleButtonTapped</message>
                    </button>
                </container>
            </view>
            <actions>
                <pushController name="exampleButtonTapped">
                    <screen>
                        <title>Example 2</title>
                        <view>
                            <container>
                                <label>This controller gets pushed!</label>
                            </container>
                        </view>
                    </screen>
                </pushController>
            </actions>
        </screen>
    </navigation>
</workflow>
```

When the user taps the button, they see this:

![An alert has been show reading 'Example button tapped1'](http://credit360.github.com/WorkflowSchema/readme_images/example2-pushed.png)

Suppose we modify our screen to add another button, and to add an action to the navigation controller:

```xml
<workflow>
    <navigation>
        <screen>
            <title>Example<title>
            <view>
                <container>
                    <label>Example label</label>
                    <button>
                        <title>Example button 1</title>
                        <message>exampleButton1Tapped</message>
                    </button>
                    <button>
                        <title>Example button 2</title>
                        <message>exampleButton2Tapped</message>
                    </button>
                </container>
            </view>
            <actions>
                <showAlert name="exampleButton1Tapped">Example button 1 tapped!</showAlert>
            </actions>
        </screen>
        <actions>
            <showAlert name="exampleButton2Tapped">Example button 2 tapped!</showAlert>
        </actions>
    </navigation>
</workflow>
```

Suppose also that the user taps the second button.  Nothing happens.  This is because the button tells the screen controller to perform the action named `exampleButton2Tapped`, but it has no such action.  The request isn't propagated to the navigation controller, so nothing happens.

If we want to wire the button up to the navigation controller's action, we need to send another message.  We do this with a special action called `<sendMessage>` or `WFSSendMessageAction`:

```xml
<workflow>
    <navigation>
        <screen>
            <title>Example<title>
            <view>
                <container>
                    <label>Example label</label>
                    <button>
                        <title>Example button 1</title>
                        <message>exampleButton1Tapped</message>
                    </button>
                    <button>
                        <title>Example button 2</title>
                        <message>exampleButton2Tapped</message>
                    </button>
                </container>
            </view>
            <actions>
                <showAlert name="exampleButton1Tapped">Example button 1 tapped!</showAlert>
                <sendMessage name="exampleButton2Tapped">
                    <message>exampleMessage</message>
                </sendMessage>
            </actions>
        </screen>
        <actions>
            <showAlert name="exampleMessage">Example button 2 tapped!</showAlert>
        </actions>
    </navigation>
</workflow>
```

Now when the user taps the second button, it tells the screen controller to perform the action named `exampleButton2Tapped`; that action then sends a message with  name `exampleMessage`.  The navigation controller receives this message and tries to perform an action with a matching name.  There is such an action, so it performs it.

By default, messages are passed on to the creator of the controller - in this case, the creator of the screen controller is the navigation controller - and do not get passed on.  It is possible to send them elsewhere by specifying a destination.  For example, you can use the 'self' destination type to fire other actions on the same controller:

```xml
<workflow>
    <navigation>
        <screen>
            <title>Example</title>
            <view>
                <container>
                    <label>Example label</label>
                    <button>
                        <title>Example button</title>
                        <message>exampleButtonTapped</message>
                    </button>
                </container>
            </view>
            <actions>
                <sendMessage name="exampleButtonTapped">
                    <message>
                        <name>exampleMessage</name>
                        <destinationType>self</destinationType>
                    </message>
                </sendMessage>
                <showAlert name="exampleMessage">Message received and understood!</showAlert>
            </actions>
        </screen>
    </navigation>
</workflow>
```

In this case, when the button is tapped, the screen controller receives the `exampleButtonTapped` message, and performs the matching action.  This sends the `exampleMessage` message to itself, and so it performs the matching action again, which in this case shows an alert.

You can use the 'descendant' destination type to send messages to descendant controllers.  For example:

```xml
<workflow>
    <navigation>
        <screen>
            <title>Example</title>
            <navigationItem>
                <rightBarButtonItem>
                    <barButtonItem>
                        <title>Submit</title>
                        <message>submitBarButtonTapped</message>
                    </barButtonItem>
                </rightBarButtonItem>
            </navigationItem>
            <form name="theForm">
                <container>
                    <label>Example text</label>
                    <textField name="exampleText"></textField>
                </container>
            </view>
            <actions>
                <sendMessage name="leftBarButtonTapped">
                    <message>
                        <name>submit</name>
                        <destinationType>descendant</destinationType>
                        <destinationName>theForm</destinationName>
                    </message>
                </sendMessage>
            </actions>
        </screen>
    </navigation>
</workflow>
```

In this case, when the bar button is tapped, the screen controller receives the `submitBarButtonTapped` message; it then sends the `submit` message to its descendant with the name `theForm`.

The fourth type of destination is `rootDelegate`.  Messages with this destination type get passed all the way out to your app delegate, where the `context:didReceiveWorkflowMessage:` delegate message will be called. This is how you implement things like API calls.

Note the difference between the name of the action, and the name of the message:

```xml
<sendMessage name="exampleButton2Tapped">
    <message>
        <name>exampleMessageName</name>
    </message>
</sendMessage>
```

The action is named `exampleButton2Tapped`, but it sends a message named `exampleMessageName`.

Contexts
--------

Earlier, we said "By default, messages are passed on to the creator of the controller".  To explain what's actually happening, it's necessary to introduce the concept of the workflow context.  We've seen one already, when we set up the workflow:

```ObjC
    WFSContext *context = [WFSContext contextWithDelegate:self];
```

The context wraps up the information that the framework needs in order to create objects from schemata, and to determine where messages should get sent.  Each context has a delegate object which implements `context:didReceiveWorkflowMessage:` in order to handle messages.  Any time an object is created or an action is performed, a context is passed to it.  When an object is created as a parameter to a controller, or when an action is performed by a controller, it makes a copy of the context that was used to create the controller and sets the new context's delegate to be itself.  It then implements `context:didReceiveWorkflowMessage:` to strip out messages for that controller and then to pass any others to its own context.  As a result, controllers have a chain of delegates which can respond to messages, all the way out to the delegate you provide when you create the first context.

Contexts also have a dictionary of userInfo which contains the results of actions.  This is used, among other things, to allow schemata to load other schemata.

Loading
-------

We've seen an example schema which pushes a new controller onto the navigation stack, but it would be nice if we could load that controller from another file.  We do this using the `loadSchema` action.

```xml
<workflow>
    <navigation>
        <screen>
            <title>Example</title>
            <view>
                <container>
                    <label>Example label</label>
                    <button>
                        <title>Example button</title>
                        <message>exampleButtonTapped</message>
                    </button>
                </container>
            </view>
            <actions>
                <loadSchema name="exampleButtonTapped">
                    <path>/path/to/other/schema.xml</path>
                    <successAction>
                        <pushController />
                    </successAction>
                    <failureAction>
                        <showAlert>Failed to load schema</showAlert>
                    </failureAction>
                </loadSchema>
            </actions>
        </screen>
    </navigation>
</workflow>
```

Now when the user taps the button, the `loadSchema` action is performed.  This sends a message with name "loadSchema" with "/path/to/other/schema.xml" in its context's userInfo along the delegate chain and waits for a response.  When the response is received, it looks to see whether it was successful, and if it was then it looks at the userInfo of the context coming back with the response.  If the value for the key "schema" contains a schema, it adds that to its original context and performs the success action.

In this case, the success action is a `pushController` action, which knows that if it has no parameters it should look at its context for a "schema" key, and if it finds one create that schema and check whether it is a `UIViewController`.  If it is, then it pushes the controller onto the stack.

One part is missing here: actually reading the file.  The framework makes no assumptions about how you want to store your workflow files; they might be on the device, or they might be on some remote server.  It's the responsibility of the delegate of the original context to do the actual loading and parsing.  One way you might do it would be to implement `context:didReceiveWorkflowMessage:` like this:

```ObjC
- (BOOL)context:(WFSContext *)contect didReceiveWorkflowMessage:(WFSMessage *)message
{
    if ([message.name isEqualToString:WFSLoadSchemaActionMessageName])
    {
        NSError *error = nil;
        WFSSchema *schema = nil;
        WFSResult *result = nil;

        NSString *path = message.context.userInfo[WFSLoadSchemaActionPathKey];
        if (path)
        {
            NSURL *xmlURL = [NSURL fileURLWithPath:message.name];
            schema = [[[WFSXMLParser alloc] initWithContentsOfURL:xmlURL] parse:&error];
        }

        if (schema)
        {
            WFSMutableContext *successContext = [message.context mutableCopy];
            successContext.userInfo = @{ WFSLoadSchemaActionSchemaKey : schema };
            result = [WFSResult successResultWithContext:successContext];
        }
        else
        {
            NSLog(@"Error loading schema at %@: %@", path, error);
            result = [WFSResult failureResultWithContext:message.context];
        }

        [message respondWithResult:result];
        return YES; // The message has been handled, whether successfully or not
    }

    return NO; // The message has not been handled
}
```

The result of all this is that, when the user taps on the button, a schema will be loaded from the given path and the controller that it represents will be pushed onto the navigation stack.

Parameter proxies
-----------------

Now that we can break our workflow up across multiple files, it would be nice if we could reuse those files in different ways.  It seems like it will be difficult, because we don't know whether we're writing a controller to be pushed into an existing navigation stack, or whether it will be presented modally and therefore need its own.  What we want is for the controller which is doing the presenting to be able to provide the navigation stack, and then we can write all our files except for the first without any outer controllers.

Happily, we can do this using parameter proxies.  A parameter proxy is an object that should be pulled out of the context's userInfo instead of created directly.  An object tag represents a parameter proxy if it uses the `keyPath` attribute, like this:

```xml
<workflow>
    <navigation>
        <screen>
            <title>Example</title>
            <view>
                <container>
                    <label>Example label</label>
                    <button>
                        <title>Example button</title>
                        <message>exampleButtonTapped</message>
                    </button>
                </container>
            </view>
            <actions>
                <loadSchema name="exampleButtonTapped">
                    <path>/path/to/other/schema.xml</path>
                    <successAction>
                        <presentController>
                            <navigation>
                                <screen keyPath="schema" />
                            </navigation>
                        </presentController>
                    </successAction>
                    <failureAction>
                        <showAlert>Failed to load schema</showAlert>
                    </failureAction>
                </loadSchema>
            </actions>
        </screen>
    </navigation>
</workflow>
```

This now tells the framework that when the button is pressed, it should load the given schema; that schema goes into the "schema" key of the userInfo of the context that is used for the success action, which modally presents a navigation controller.  That controller creates a screen controller, but instead of doing so based on the XML it looks in the "schema" key, and creates the object defined by the schema it finds there.

To put it another way, it loads the schema from the given file, wraps the controller it finds in a navigation controller, and then modally presents that.

View lifecycle events
---------------------

We can now write all our workflow schema files in isolation, except for the first one that the user sees.  What do we do if we want to use a reusable component there, too?  So far we've only been able to perform actions in response to user input.  However, it's also possible to perform actions in response to view lifecycle events.  When the controller's viewDidLoad, viewWillAppear, viewDidAppear, viewWillDisappear and viewDidDisappear methods are called for a tab bar, navigation or screen controller, the controller looks for a correspondingly-named action (The action name omits the colon in the method names, for those that have one).  We could therefore set up our first workflow file like this:

```xml
<workflow>
    <tabs>
        <navigation>
            <tabItem>
                <title>Tab 1</title>
                <image>tab1</image>
            </tabItem>
            <screen>
                <title>Loading...</title>
                <view>
                    <label>Loading....</label>
                </view>
            </screen>
            <loadSchema name="viewDidLoad">
                <path>/path/to/schema1.xml</path>
                <successAction>
                    <replaceRootController />
                </successAction>
                <failureAction>
                    <showAlert>Failed to load schema</showAlert>
                </failureAction>
            </loadSchema>
        </navigation>
        <navigation>
            <tabItem>
                <title>Tab 2</title>
                <image>tab2</image>
            </tabItem>
            <screen>
                <title>Loading...</title>
                <view>
                    <label>Loading....</label>
                </view>
            </screen>
            <loadSchema name="viewDidLoad">
                <path>/path/to/schema2.xml</path>
                <successAction>
                    <replaceRootController />
                </successAction>
                <failureAction>
                    <showAlert>Failed to load schema</showAlert>
                </failureAction>
            </loadSchema>
        </navigation>
    </tabs>
</workflow>
```

This will give us an initial window with a tab controller containing two navigation controllers, each containing a temporary screen with title "Loading..." and a label also saying "Loading...".  When the screen loads, a new schema is loaded and used to replace the temporary screen.

In this way, every screen in the application can be written as a top-level controller.


Styling
-------

Styling is handled by iOS's built-in UIAppearance protocol.  This can be set using code, or using the excellent [UISS project](https://github.com/robertwijas/UISS) which allows you to define styles in a centralised JSON file.

UIAppearance works class-by-class, but it's common to want different styles for different classes of object.  WorkflowSchema supports this to an extent by allowing the user to set a `class` attribute on object tags, which modifies the class of the object that is created.  For example:

```xml
<button>This is a normal button</button>
<button class="submit">This is a submit button</button>
<button class="cancel">This is a cancel button</button>
```

The first tag instructs the framework to create an object of class `WFSButton`.  The second instructs the framework to dynamically create a subclass of `WFSButton` named `WFSButton.submit` (if it has not already done so) and then to create an object of that class.  The third does the same for `WFSButton.cancel`.  This means that you can set up UISS rules like this:

```json
"WFSButton" : {
    "backgroundImage" : [["button_bg", 11, 4, 12, 4], "normal"],
    "contentEdgeInsets" : [[12, 4, 12, 4]],
},

"WFSButton.submit" : {
    "backgroundImage" : [["submit_button_bg", 11, 4, 12, 4], "normal"],
},

"WFSButton.cancel" : {
    "backgroundImage" : [["cancel_button_bg", 11, 4, 12, 4], "normal"],
},
```

...and it will correctly set the background images.

There are a few caveats to this: firstly, if you are using UISS (and you should be), then you'll need to call `configureWithDefaultJSONFile` after each time you load a schema, because the classes are created dynamically and UISS doesn't set styles for classes that don't exist yet.


Secondly, although it looks a lot like CSS classes, and behaves like CSS classes when you've only got one of them, it's not CSS classes.  You can't match on just the class attribute, and you can't have more than one.  So this won't work:


```xml
<button class="big cancel">This is a big cancel button</button>
<button class="big submit">This is a big submit button</button>
```

```json
"WFSButton.big" : {
    "contentEdgeInsets" : [[24, 8, 24, 8]],
},

"WFSButton.cancel" : {
    "backgroundImage" : [["cancel_button_bg", 11, 4, 12, 4], "normal"],
},

"WFSButton.big.submit" : {
    "backgroundImage" : [["big_submit_button_bg", 11, 4, 12, 4], "normal"],
},
```

...because you've created one class called `WFSButton.big cancel` which doesn't inherit from `WFSButton.big` or `WFSButton.cancel`, and another called `WFSButton.big submit` which doesn't inherit from `WFSButton.big.submit` (which doesn't exist).

This won't work either:


```xml
<button class="big">This is a big button</button>
<label class="big">This is a big label</button>
```

```json
".big" : {
    "font" : "Big-font",
},
```

...because you've created two classes called `WFSButton.big` and `WFSLabel.big`, neither of which inherit from `.big`, which doesn't exist.
