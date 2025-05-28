//
//  EmployeeModel.swift
//  EmployeeFormExample
//
//  Part of the EmployeeFormExample application supplied with the
//  ImageDataPicker Framework.
//
//  Created by Michael Logothetis on 30/04/2025.
//
//  MIT License
//  Copyright (c) 2025 Michael Logothetis (Technistic Pty Ltd)
//

import Foundation
//import ImageDataPicker
import SwiftData
import SwiftUI

#if canImport(UIKit)
    import UIKit
#endif

/// The Employee model forms part of the ``EmployeeFormExampleApp``.
///
/// The  ``Employee`` model demonstrates how the  `ImageDataPickerView` is bound to a `Data?` attribute in a model. It stores an Employee's _name_ (non-unique), _department_ and _photo_.
///
/// The photo image data is stored in an ``imageData`` attribute. This ``imageData`` attribute  can be bound directly to an `ImageDataPickerView` from the `ImageDataPicker` framework.
///
/// The Employee class also shows how to create a computed variable ``photo`` that returns the ``imageData`` as an `Image`. If ``imageData`` is `nil`, ``photo`` returns a ``Constants/personPlaceholder`` Image.
@Model
final class Employee: Identifiable {
    var firstName: String
    var lastName: String
    var department: String
    var imageData: Data?

    /// Create an Employee with their name, department and (optional) photo.
    /// - Parameters:
    ///   - firstName: The given name of the Employee.
    ///   - lastName: The family name of the Employee.
    ///   - department: The department the Employee works in.
    ///   - imageData: An (optional) photo of the Employee.
    init(
        firstName: String,
        lastName: String,
        department: String,
        imageData: Data? = nil
    ) {
        self.firstName = firstName
        self.lastName = lastName
        self.department = department
        self.imageData = imageData
    }

    /// A representation of an Employee's photo from ``imageData`` as an  Image view.
    /// If ``imageData`` is nil, a ``Constants/personPlaceholder`` image is presented.
    var photo: Image {
        #if canImport(UIKit)
            if let imageData, let uiImage = UIImage(data: imageData) {
                return Image(uiImage: uiImage)
            } else {
                return Image(systemName: Constants.personPlaceholder)
            }
        #else
            if let imageData {
                return Image(nsImage: NSImage(data: imageData as Data)!)
            } else {
                return Image(systemName: Constants.personPlaceholder)
            }
        #endif
    }
}
