//
//  HomeScreenRobot.swift
//  BN-2021UITests
//
//  Created by Patryk Strzemiecki on 24/11/2020.
//

import XCTest

public func homeScreen(closure: (HomeScreenRobot) -> Void) {
    closure(homeScreen)
}

public var homeScreen: HomeScreenRobot {
    HomeScreenRobot(query: HomeScreenRobot.defaultQuery)
}

public class HomeScreenRobot {
    static var defaultQuery = XCUIApplication().otherElements
    private let query: XCUIElementQuery
    
    public init(query: XCUIElementQuery) {
        self.query = query
        XCTAssertTrue(query.element.exists,
                      "Robot screen not visible, but it should be")
    }
    
    public func checkIfButtonExists(file: StaticString = #file, line: UInt = #line) {
        let matching
            = query.buttons.matching(
                identifier: AccessibilityIdentifiers.HomeScreen.mainButton
            )
        XCTAssertTrue(matching.element.exists,
                      "element not exists, but it should")
    }
    
    public func tapMainButton(file: StaticString = #file, line: UInt = #line) {
        let matching
            = query.buttons.matching(
                identifier: AccessibilityIdentifiers.HomeScreen.mainButton
            )
        matching.element.tap()
    }
}

public extension XCUIElement {
    @discardableResult
    func wait(timeout: TimeInterval = 1) -> Bool {
        let _expectation = XCTKVOExpectation(keyPath: "exists", object: self,
                                             expectedValue: true)
        let result = XCTWaiter().wait(for: [_expectation], timeout: timeout)
        return result == .completed
    }
}

public struct AccessibilityIdentifiers {
    struct HomeScreen {
        static var mainButton = "actionButton"
    }
}

public func detailsScreen(closure: (DetailsScreenRobot) -> Void) {
    closure(detailsScreen)
}

public var detailsScreen: DetailsScreenRobot {
    DetailsScreenRobot(query: DetailsScreenRobot.defaultQuery)
}

#warning("Ugly below, refactor to use AccessibilityIdentifiers")
public class DetailsScreenRobot {
    static var defaultQuery = XCUIApplication().otherElements
    private let query: XCUIElementQuery
    
    public init(query: XCUIElementQuery) {
        self.query = query
        XCTAssertTrue(query.element.exists,
                      "Robot screen not visible, but it should be")
    }
    
    public func checkIfLabelExists(file: StaticString = #file, line: UInt = #line) {
        XCTAssertTrue(query.navigationBars["Contacts Permissions Allowed, yay!"].exists, "element not exists, but it should")
    }
    
    public func tapBackButton(file: StaticString = #file, line: UInt = #line) {
        query.navigationBars["Contacts Permissions Allowed, yay!"].buttons["Back"].tap()
    }
}
