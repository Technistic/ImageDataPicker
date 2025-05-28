//
//  EmployeeFormExampleApp.swift
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

import OSLog
import SwiftData
import SwiftUI

/// An application to showcase the ImageDataPicker Framework.
///
/// This application demonstrates how to bind an Image directly to a SwiftData model and
/// update the Image automatically using the ImageDataPickerView from the ImageDataPicker framework.
///
/// It presents an ``EmployeeListView`` with a photo of each ``Employee`` in each row of the list.
/// Selecting an ``Employee`` from the list presents an ``EmployeeView`` that enables you to update
/// or delete the employee's photo using the ImageDataPickerView.
@main
struct EmployeeFormExampleApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Employee.self
        ])
        let modelConfiguration = ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: false
        )

        do {
            return try ModelContainer(
                for: schema,
                configurations: [modelConfiguration]
            )
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    // Always start by deleting any sample data.
                    //SampleDataManager(
                    //    modelContext: sharedModelContainer.mainContext
                    //).deleteSampleData()

                    // Load sample data if the database is empty.
                    let descriptor = FetchDescriptor<Employee>(
                        predicate: #Predicate { $0 == $0 }
                    )
                    if (try? sharedModelContainer.mainContext.fetchCount(
                        descriptor
                    )) == 0 {
                        SampleDataManager(
                            modelContext: sharedModelContainer.mainContext
                        ).insertSampleData()
                        try! sharedModelContainer.mainContext.save()
                    }
                    sharedModelContainer.mainContext.autosaveEnabled = false
                }
        }
        .modelContainer(sharedModelContainer)
    }
}
