//
//  BN_2021Tests.swift
//  BN-2021Tests
//
//  Created by Patryk Strzemiecki on 05/11/2020.
//

import XCTest
@testable import BN_2021

class BN_2021Tests_1: XCTestCase {
    private var sut: FirstViewController!
    
    override func setUp() {
        
        self.sut = FirstViewController()
    }
    
    func test_givenFirstVC_whenCalledNeverEndingMethod_thenFails_andExecutionTimeAllowanceSkipsTest() {
        executionTimeAllowance = 10
                
        XCTAssertEqual(sut.neverEndingMethod(), 1)
    }
}

class BN_2021Tests_2: XCTestCase {
    private var sut: FirstViewController!
    
    override func setUp() {
        
        self.sut = FirstViewController()
    }
    
    func test_givenFirstVC_whenButtonEnabled_thenProperTitleIsReturned() {
        
        sut.setButton(enabled: true)
        
        XCTAssertEqual(sut.buttonTitle(), "Action")
    }
    
    func test_givenFirstVC_whenButtonDisabled_thenProperTitleIsReturned() {
        
        sut.setButton(enabled: false)
        
        XCTAssertEqual(sut.buttonTitle(), "🐴")
    }
}
