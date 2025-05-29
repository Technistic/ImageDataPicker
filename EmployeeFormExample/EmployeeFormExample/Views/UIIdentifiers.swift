//
//  UIIdentifiers.swift
//  EmployeeFormExampleUITests
//
//  Created by Michael Logothetis on 29/5/2025.
//

import Foundation
import SwiftData

enum UIIdentifiers {
    enum EmployeeList {
        static let addEmployeeButton = "EmployeeList.btn.add"
        static let deleteEmployeeButton = "EmployeeList.btn.delete"
        
        static func employeeID(_ employeeID: PersistentIdentifier) -> String {
            "EmployeeList.employeeID.\(employeeID)"
        }
        static func employeeFullName(firstName: String, lastName: String) -> String {
            "EmployeeList.\(firstName).\(lastName)"
        }
        static func firstName(employeeID: PersistentIdentifier, firstName: String) -> String {
            "EmployeeList.\(employeeID).firstName.\(firstName)"
        }
        static func lastName(employeeID: PersistentIdentifier, lastName: String) -> String {
            "EmployeeList.\(employeeID).lastName.\(lastName)"
        }
        static func department(employeeID: PersistentIdentifier, department: String) -> String {
            "EmployeeList.\(employeeID).department.\(department)"
        }
    }
    
    enum EmployeeView {
        static let title = "EmployeeView.label.fullName"
        static let firstNameTextField = "EmployeeView.textField.firstName"
        static let lastNameTextField = "EmployeeView.textField.lastName"
        static let departmentTextField = "EmployeeView.textField.department"
        static let navigationBack = "EmployeeView.navigation.Our Employees"
        static let saveButton = "EmployeeView.btn.save"
        static let cancelButton = "EmployeeView.btn.cancel"
        static let changePhotoButton = "ImageDataPicker.btn.changePhoto"
        static let deletePhotoButton = "ImageDataPicker.btn.deletePhoto"
    }
}
