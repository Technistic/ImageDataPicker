//
//  SampleData.swift
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
import OSLog
import SwiftData

#if os(macOS)
import AppKit
typealias UIImage = NSImage
#else
import UIKit
#endif

/// The ``SampleDataManager`` allows you to ``insertSampleData()``, ``deleteSampleData()`` and ``reloadSampleData()`` using the application's `ModelContext`.
class SampleDataManager {
    private var modelContext: ModelContext?
    
    static var shared: SampleDataManager = {
        let instance = SampleDataManager(modelContext: nil)
        return instance
    }()
    
    public init(modelContext: ModelContext?) {
        self.modelContext = modelContext
    }
    
    /// Converts an asset to png data.
    /// - Parameter assetname: The name of the image in the Assets catalogue.
    /// - Returns: Returns the image as [png](https://www.w3.org/TR/REC-png-961001) data.
    func pngData(assetname: String) -> Data? {
        if let uiimage = UIImage(named: assetname) {
            return uiimage.pngData()
        } else {
            return nil
        }
    }
    
    /// Inserts sample data consisting of ``Employee`` details and their associated photo. The ``Employee/imageData`` for each employee is generated from images in the Assets catalogue.
    func insertSampleData() {
        Logger.appdata.info("Inserting sample data.")
        
        let aleshia_evans = Employee(
            firstName: "Aleshia",
            lastName: "Evans",
            department: "Engineering",
            imageData: pngData(assetname: "Aleshia_Evans")
        )
        
        let peter_jones = Employee(
            firstName: "Peter",
            lastName: "Jones",
            department: "Sales",
            imageData: pngData(assetname: "Peter_Jones")
        )
        
        let craig_birch = Employee(
            firstName: "Craig",
            lastName: "Birch",
            department: "Engineering",
            imageData: pngData(assetname: "Craig_Birch")
        )
        
        let anne_lee = Employee(
            firstName: "Anne",
            lastName: "Lee",
            department: "Finance",
            imageData: pngData(assetname: "Anne_Lee")
        )
        
        if let modelContext {
            modelContext.insert(aleshia_evans)
            modelContext.insert(peter_jones)
            modelContext.insert(craig_birch)
            modelContext.insert(anne_lee)
        }
    }
    
    /// Delete all sample data.
    func deleteSampleData() {
        Logger.appdata.info("Deleting sample data.")
        do {
            if let modelContext {
                try? modelContext.delete(model: Employee.self)
            }
        }
    }
    
    /// Reload sample data by first deleting all existing data and then inserting sample data.
    func reloadSampleData() async {
        Logger.appdata.info("Reloading sample data.")
        deleteSampleData()
        insertSampleData()
    }
}

/// The ``DataController`` class is used to create an _in-memory_ _ModelContainer_ that can be used use with the ``SampleDataManager`` and then attached to a SwiftUI #Preview.
@MainActor
class DataController {
    static public let previewContainer: ModelContainer = {
        do {
            let schema = Schema([
                Employee.self
            ])
            let previewModelConfiguration = ModelConfiguration(
                schema: schema,
                isStoredInMemoryOnly: true
            )
            let myContainer = try ModelContainer(
                for: schema,
                configurations: previewModelConfiguration
            )
            
            SampleDataManager(modelContext: myContainer.mainContext)
                .insertSampleData()
            
            return myContainer
        } catch {
            fatalError(
                "Failed to create model container for previewing: \(error.localizedDescription)"
            )
        }
    }()
}
