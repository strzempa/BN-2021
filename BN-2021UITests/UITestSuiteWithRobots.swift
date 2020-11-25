//
//  UITestSuiteWithRobots.swift
//  BN-2021UITests
//
//  Created by Patryk Strzemiecki on 24/11/2020.
//

import XCTest

final class UITestSuiteWithRobots: XCTestCase {
    private var app: XCUIApplication!
    
    override func setUp() {
        super.setUp()
        app = XCUIApplication()
        app.launch()
    }
    
    func test_appNavigatesBetweenScreens() {
        homeScreen {
            $0.checkIfButtonExists()
            $0.tapMainButton()
        }
        detailsScreen {
            $0.checkIfLabelExists()
            $0.tapBackButton()
        }
    }
}
