//
//  EmployeeListView.swift
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
import ImageDataPicker

/// The ``EmployeeListView`` displays a list of employees, allowing the user to select an ``Employee`` to view their details.
///
/// This is a multi-platform view based on a NavigationSplitView that presents a list of
/// employees along with their photo, name and department.
struct EmployeeListView: View {
    @Environment(\.editMode) private var editMode

    @Environment(\.modelContext) private var modelContext
    @Query private var employees: [Employee]

    @State private var selectedEmployeeID: Employee.ID? = nil
    @State private var columnVisibility =
        NavigationSplitViewVisibility.doubleColumn
    
    private let employeeListTestID = UIIdentifiers.EmployeeList.self

    var body: some View {
        NavigationSplitView(columnVisibility: $columnVisibility) {
            List(selection: $selectedEmployeeID) {
                ForEach(employees) { employee in
                    EmployeeListRowView(employee: employee)
                        .accessibilityIdentifier(
                            employeeListTestID.employeeFullName(firstName: employee.firstName, lastName: employee.lastName)
                        )
                }
                .onDelete(perform: deleteEmployees)
                //.navigationTitle("Our Employees")
            }
            .navigationTitle("Our Employees")
            .listRowSeparator(.automatic)

            .environment(\.defaultMinListRowHeight, 100)

            .toolbar {
                #if os(iOS)
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                    .accessibilityIdentifier(
                        UIIdentifiers.EmployeeList.deleteEmployeeButton
                    )
                }
                #endif
                
                ToolbarItem {
                    Button(action: addEmployee) {
                        Label("Add Employee", systemImage: "plus")
                    }
                    .accessibilityIdentifier(
                        UIIdentifiers.EmployeeList.addEmployeeButton
                    )
                }
            }
            #if os(macOS)
            .navigationSplitViewColumnWidth(min: 180, ideal: 200)
            #endif
        }
        detail: {
            if let selection = selectedEmployeeID {
                EmployeeView(
                    selectedEmployeeID: $selectedEmployeeID
                )
            } else {
                Text("Please select an employee")
            }
        }
        .navigationSplitViewStyle(.balanced)
        .accentColor(.blue)
    }

    /// Add a new ``Employee`` with default data.
    private func addEmployee() {
        withAnimation {
            let newEmployee = Employee(
                firstName: "New",
                lastName: "Employee",
                department: "",
            )
            modelContext.insert(newEmployee)
            selectedEmployeeID = newEmployee.persistentModelID
        }
    }

    /// Delete the selected Employee.
    /// - Parameter offsets: The index(es) of the rows to delete.
    private func deleteEmployees(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                let deletedEmployee = employees[index]
                if deletedEmployee.persistentModelID == selectedEmployeeID {
                    selectedEmployeeID = nil
                }
                modelContext.delete(deletedEmployee)
                try! modelContext.save()
            }
        }
    }
}

/// A view that presents an employee's details in a row in the list.
struct EmployeeListRowView: View {
    var employee: Employee?
    
    private let employeeListTestID = UIIdentifiers.EmployeeList.self

    var body: some View {
        @State var img: Data? = employee?.imageData
        @State var state: ImageDataModel = ImageDataModel(imageData: img)
        HStack {
            VStack {
                ClippedImageStateView(
                    imageState: state.imageState
                )
                .clippedImageShape(.round)
                .accessibilityIdentifier(
                    employeeListTestID.employeeFullName(
                        firstName: employee!.firstName,
                        lastName: employee!.lastName
                    )
                )
            }
            VStack {
                HStack {
                    Text("\(employee?.firstName ?? "")")
                        .font(.headline)
                        .accessibilityIdentifier(
                            employeeListTestID.firstName(
                                employeeID: employee!.persistentModelID,
                                firstName: employee!.firstName
                            )
                        )

                    Text("\(employee?.lastName ?? "")")
                        .font(.headline)
                        .accessibilityIdentifier(
                            employeeListTestID.lastName(
                                employeeID: employee!.persistentModelID,
                                lastName: employee!.lastName)
                        )
                }

                Text("\(employee?.department ?? "")")
                    .font(.subheadline)
                    .accessibilityIdentifier(
                        employeeListTestID.department(
                            employeeID: employee!.persistentModelID,
                            department: employee!.department
                        )
                    )
            }
        }
    }
}

#Preview {
    EmployeeListView()
        .modelContainer(DataController.previewContainer)
}
