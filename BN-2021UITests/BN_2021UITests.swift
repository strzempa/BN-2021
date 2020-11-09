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
        addUIInterruptionMonitor(app, interruptionTypes: [InterruptionType(.contacts, .allow)])
        
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
        addUIInterruptionMonitor(app, interruptionType: InterruptionType(.contacts, .deny))
        
        // WHEN:
        app
            /*@START_MENU_TOKEN@*/.staticTexts["Action"]/*[[".buttons[\"Action\"].staticTexts[\"Action\"]",".staticTexts[\"Action\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
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
    public let action: Action
    public let alert: Alert
    
    public init(_ alert: Alert,
                _ action: Action) {
        self.alert = alert
        self.action = action
    }
    
    /// Possible actions on Interruption
    public enum Action {
        case allow
        case deny
    }
    
    /// Interruption alerts
    public enum Alert: String {
        case contacts
        
        /// Name of the alert based on case and app instance name
        /// - Parameter app: Test app reference
        /// - Returns: Name on alert
        func name(app: XCUIApplication) -> String {
            switch self {
            case .contacts:
                return "“\(app.label)” Would Like to Access Your Contacts"
            }
        }
        
        /// Text on UI that allows permissions
        func allowText() -> String {
            switch self {
            case .contacts:
                return "OK"
            }
        }
        
        /// Text on UI that denies permissions
        func denyText() -> String {
            switch self {
            case .contacts:
                return "Don’t Allow"
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
            withDescription: "System Alert \(interruptionType.alert.rawValue)"
        ) { (alert) -> Bool in
            
            let permissionsAlert
                = alert
                .staticTexts[interruptionType.alert.name(app: app)]
                .firstMatch
            
            guard permissionsAlert.exists else {
                return false
            }
            
            switch interruptionType.action {
            case .allow:
                alert
                    .buttons[interruptionType.alert.allowText()].tap()
            case .deny:
                alert
                    .buttons[interruptionType.alert.denyText()].tap()
            }
            
            return true
        }
    }
}
