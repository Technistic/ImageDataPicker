//
//  EmployeeFormExampleUITests.swift
//  EmployeeFormExampleUITests
//
//  Part of the EmployeeFormExample application supplied with the
//  ImageDataPicker Framework.
//
//  Created by Michael Logothetis on 30/04/2025.
//
//  MIT License
//  Copyright (c) 2025 Michael Logothetis (Technistic Pty Ltd)
//

import XCTest

import SwiftData

//@testable import EmployeeFormExample

final class EmployeeFormExampleUITests: XCTestCase {
    
    var app: XCUIApplication!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
#if os(iOS)
        XCUIDevice.shared.orientation = .portrait
#endif
        app = XCUIApplication()
        app.launch()

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        app.terminate()
    }
    
    @MainActor
    func testInitialList() throws {
        XCTAssertTrue(
            app.images["EmployeeList.Aleshia.Evans"].waitForExistence(timeout: 5)
        )
        XCTAssertTrue(app.images["EmployeeList.Peter.Jones"].exists)
        XCTAssertTrue(app.images["EmployeeList.Craig.Birch"].exists)
        XCTAssertTrue(app.images["EmployeeList.Anne.Lee"].exists)
    }
        
    @MainActor
    func testEmployeeExists() throws {
        let aleshia = app.images["EmployeeList.Aleshia.Evans"]
        XCTAssertTrue(aleshia.waitForExistence(timeout: 5))
        aleshia.tap()

        let firstName = app.textFields["Given Name"]
        XCTAssertTrue(firstName.waitForExistence(timeout: 5))
        XCTAssertEqual(firstName.value as? String, "Aleshia")

        #if os(iOS)
        firstName.doubleTap()
        #else
        firstName.doubleClick()
        #endif

        firstName.typeText("\u{8}")
        firstName.typeText("A New Name")

        app.buttons[UIIdentifiers.EmployeeView.saveButton].tap()

        XCTAssertTrue(app.staticTexts["A New Name Evans"].waitForExistence(timeout: 5))
    }
}
