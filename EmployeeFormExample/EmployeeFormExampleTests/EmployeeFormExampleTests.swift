//
//  EmployeeFormExampleTests.swift
//  EmployeeFormExampleTests
//
//  Part of the EmployeeFormExample application supplied with the
//  ImageDataPicker Framework.
//
//  Created by Michael Logothetis on 30/04/2025.
//
//  MIT License
//  Copyright (c) 2025 Michael Logothetis (Technistic Pty Ltd)
//

import Testing
import SwiftData

@testable import EmployeeFormExample

struct EmployeeFormExampleTests {

    @Test(.tags(.model)) func testEmployeeInitialization() {
        let employee = Employee(
            firstName: "Arnold",
            lastName: "Zephyr",
            department: "Engineering",
            imageData: nil)
        #expect(employee.firstName == "Arnold")
        #expect(employee.lastName == "Zephyr")
        #expect(employee.department == "Engineering")
    }
    
    @MainActor
    @Test(.tags(.data)) func testSampleDataManager() async throws {
        let sharedModelContainer: ModelContainer = {
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
        
        #expect(sharedModelContainer.configurations.count == 1)
        
        let sampleDataManager = SampleDataManager(
            modelContext: sharedModelContainer.mainContext
        )
        
        let descriptor = FetchDescriptor<Employee>()
        
        sampleDataManager.deleteSampleData()
        try! sharedModelContainer.mainContext.save()
        
        sampleDataManager.insertSampleData()
        try! sharedModelContainer.mainContext.save()
        
        let initialEmployeeCount = try? sharedModelContainer.mainContext.fetchCount(descriptor)
        
        #expect(initialEmployeeCount == 4)
        
        sampleDataManager.deleteSampleData()
        try! sharedModelContainer.mainContext.save()
        
        let deletedEmployeeCount = try? sharedModelContainer.mainContext.fetch(descriptor)
        #expect(deletedEmployeeCount?.count == 0)
    }
}
