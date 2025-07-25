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
        // UI tests must launch the application that they test.
        //let app = XCUIApplication()
        //app.launch()
        
        XCTAssert(app.images.count == 4)
    }
        
    @MainActor
    func testEmployeeExists() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
        
        let aleshia = app.images["EmployeeList.Aleshia.Evans"]
        aleshia.tap()
        
        if app.textFields["Given Name"].waitForExistence(timeout: 5) {
            let firstName = app.textFields["Given Name"]
            XCTAssert(firstName.exists)
            XCTAssertEqual(firstName.value as! String, "Aleshia")
            #if os(iOS)
            firstName.tap(withNumberOfTaps: 2, numberOfTouches: 1)
            #else
            firstName.doubleClick()
            #endif
            firstName.typeText("\u{8}")
            firstName.typeText("A New Name")
            
            app.buttons[UIIdentifiers.EmployeeView.saveButton].tap()
            
            //print(app.navigationBars.firstMatch.buttons)
           // if app.navigationBars.firstMatch.buttons.count(@"'name' IN $NAME_LIST") > {
           //
            //}
            //if app.navigationBars.firstMatch.buttons.contains("Our Employees") {
            //    app.navigationBars.firstMatch.buttons["Our Employees"].tap()
            //}

            if app.staticTexts["Our Employees"].waitForExistence(timeout: 5) {
                XCTAssert(app.staticTexts["A New Name Evans"].exists)
            }
        }
    }
}
