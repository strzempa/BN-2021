//
//  BN_2021UITests.swift
//  BN-2021UITests
//
//  Created by Patryk Strzemiecki on 05/11/2020.
//

import XCTest

final class BN_2021UITests: XCTestCase {
    private var app: XCUIApplication!
    
    func testContactsPermissionsAllowed() throws {
        // GIVEN:
        launchAppWithCleanContactsPermissions()
        addUIInterruptionMonitor(app, interruptionTypes: [InterruptionType(.contacts(.allow))])
        
        // WHEN:
        app
            .staticTexts["Action"]
            .tap()
        
        // THEN:
        app
            .navigationBars["Contacts Permissions Allowed, yay!"]
            .buttons["Back"]
            .tap()
    }
    
    func testContactsPermissionsDisallowed() throws {
        // GIVEN:
        launchAppWithCleanContactsPermissions()
        addUIInterruptionMonitor(app, interruptionType: InterruptionType(.contacts(.deny)))
        
        // WHEN:
        app
            .staticTexts["Action"]
            .tap()
        
        // THEN:
        app
            .navigationBars["Disallowed :("]
            .buttons["Back"]
            .tap()
    }
}

private extension BN_2021UITests {
    /// App Launch with clean contacts authorization
    func launchAppWithCleanContactsPermissions() {
        app = XCUIApplication()
        app.resetAuthorizationStatus(for: .contacts)
        app.launch()
    }
}

// LIB DRAFT

/// Type of interruption alert with assigned action
public struct InterruptionType {
    public let alert: Alert
    
    public init(_ alert: Alert) {
        self.alert = alert
    }
    
    /// Possible actions on Interruption
    public enum Action {
        case allow
        case deny
    }
    
    /// Interruption alerts
    public enum Alert {
        case contacts(Action)
        
        /// Name of the alert based on case and app instance name
        /// - Parameter app: Test app reference
        /// - Returns: Name on alert
        func name(app: XCUIApplication) -> String {
            switch self {
            case .contacts:
                return "“\(app.label)” Would Like to Access Your Contacts"
            }
        }
        
        /// Text on UI that makes an action
        func actionText() -> String {
            switch self {
            case .contacts(let action):
                switch action {
                case .allow:
                    return "OK"
                case .deny:
                    return "Don’t Allow"
                }
            }
        }
    }
}

public extension XCTestCase {
    /// Sets multiple interruption monitors
    /// - Parameters:
    ///   - app: Test app reference
    ///   - interruptionTypes: Types of interruption alerts with assigned actions
    func addUIInterruptionMonitor(_ app: XCUIApplication,
                                  interruptionTypes: [InterruptionType]) {
        interruptionTypes.forEach {
            addUIInterruptionMonitor(app, interruptionType: $0)
        }
    }
    
    /// Sets a single interruption monitor
    /// - Parameters:
    ///   - app: Test app reference
    ///   - interruptionType: Type of interruption alert with assigned action
    func addUIInterruptionMonitor(_ app: XCUIApplication,
                                  interruptionType: InterruptionType) {
        addUIInterruptionMonitor(
            withDescription: "System Alert \(interruptionType.alert)"
        ) { (alert) -> Bool in
            
            let permissionsAlert
                = alert
                .staticTexts[interruptionType.alert.name(app: app)]
                .firstMatch
            
            guard permissionsAlert.exists else {
                return false
            }
            
            alert
                .buttons[interruptionType.alert.actionText()].tap()
            
            return true
        }
    }
}
