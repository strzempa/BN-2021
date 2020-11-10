Use Xcode Version 12.1

Project covering WWDC2020 sessions:

https://developer.apple.com/videos/play/wwdc2020/10221/

https://developer.apple.com/videos/play/wwdc2020/10220/

Research results:

# UI tests
## UI interruption
Since iOS 9 XCTest contains a method `addUIInterruptionMonitor` that handles the dismissal of system alerts. Apparently Apple decided this year is a good time to present it. Method in its closure passes the found XCUIElement (may be an alert or a banner). Developers can add a custom handler. Handlers should return true if they invoked an action on the UI, false if they did not. Method can be called in any spot in the test suite before execution of the next steps. Returns an opaque token that can be used to remove the monitor with `removeUIInterruptionMonitor` method.


Developers should use interruption handlers only when the test does not trigger the element's appearance and it does not know when it will appear.

Any other app alert that test case triggers and one knows when it will appear should be tested with standard queries and waitForExistence APIs.

Apple implemented the UI interruption handler that way it will always just dismiss the alert without thinking what button should be selected on the UI. It looks that it always will tap ‘OK’ or ‘Allow’ but developer may need a different action there.

We may think of creating a library to have the basic ones handled, ex: 'addUIInterruptionMonitor(_:interruptionTypes:)'. 
I added a draft concept of an Extension to XCTestCase into an example project.

https://github.com/strzempa/BN-2021/blob/master/BN-2021UITests/BN_2021UITests.swift 


## Reset the authorization status
Since iOS 13.4 developers can reset permissions for XCUIProtectedResource (contacts, calendar, reminders, photos, microphone, camera, mediaLibrary, homeKit, bluetooth, keyboardNetwork, location, health). Just call resetAuthorizationStatus method on your XCUIApplication instance. It may be a good practice to call it before launching the app as documentation says 'If the app is running, it might get terminated while the reset occurs for some protected resources.'.

https://github.com/strzempa/BN-2021/blob/master/BN-2021Tests/BN_2021Tests.swift 


# Unit tests
## Latest Apple's recommendations:

* Use Execution Time Allowances to ensure your tests always complete running

* Use spindumps for diagnosing application stalls and hangs

* Use Parallel Distributed Testing to speed up your tests

* Use Parallel Destination Testing to simultaneously run your tests on more OS versions and devices

## Execution Time Allowance
Execution Time Allowance is a new test plan option in Xcode 12. (works only in test plans so for older projects one must migrate).



When enabled in the test plan, developers can set the time allowance in a single test. 

To enable: Edit a test plan, go to Configurations, set Test Timeouts On.
`executionTimeAllowance` can be set for each test case and API rounds up the TimeInterval value to minutes. By default it's 10 min per test.

https://github.com/strzempa/BN-2021/blob/master/BN-2021Tests/BN_2021Tests.swift 



This setting enforces a time limit on each individual test.

When a test exceeds this limit Xcode:

Captures a spindump (shows which thread is occupied by what functions) 

Kills the hung test

Restarts the runner so next tests can execute

If a test fails because of exceeding the threshold the Assertion Failure will be thrown with the message 'Test exceeded execution time allowance of x minutes' and a spindump will be attached.



## Parallel Distributed Testing
Concept is not new. Tests get split by class into different instances of simulators. It works right now on physical devices of iOS and tvOS and Apple encourages us developers to use it for all the tests as it is faster. 

Go to Test Plan, select plan, select options and tick 'execute in parallel'. Xcode will run separate test suites on different device