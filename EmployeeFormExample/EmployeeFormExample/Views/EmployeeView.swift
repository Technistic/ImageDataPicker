//
//  EmployeeView.swift
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

import ImageDataPicker
import OSLog
import SwiftData
import SwiftUI

///The ``EmployeeView`` is a SwiftUI view that displays and edits an ``Employee``'s details, including their name, department, and photo.
struct EmployeeView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    @Binding public var selectedEmployeeID: Employee.ID?
    @State var employee: Employee?

    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var department: String = ""
    @State private var imageData: Data? = nil

    var body: some View {
        var hasChanges: Bool {
            //TODO: use a better way to check for changes
            if employee == nil {
                return false
            } else {
                return firstName != employee!.firstName
                    || lastName != employee!.lastName
                    || department != employee!.department
                    || imageData != employee!.imageData
            }
        }

        ScrollView {
            VStack {
                Spacer()
                HStack {
                    Text("\(firstName) \(lastName)")
                        .font(.title)
                }
                Spacer()
                ImageDataPickerView(imageData: $imageData)
                    .clippedImageShape(.round)
                    .padding(4)
                    .frame(minHeight: 180)
                VStack(alignment: .center) {
                    Label("Employee Name", systemImage: "person.fill")
                        .font(.title)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.leading)
                    HStack {
                        TextField("Given Name", text: $firstName)
                            .disableAutocorrection(true)
                            .accessibilityLabel("Given Name")
                        TextField("Family Name", text: $lastName)
                            .disableAutocorrection(true)
                            .accessibilityLabel("Family Name")
                    }
                    Label("Department", systemImage: "person.3.fill")
                        .font(.title)
                        .foregroundColor(.white)
                    TextField("Department", text: $department)
                        .disableAutocorrection(true)

                }
                .padding(24)
                .background(.blue)
                .cornerRadius(12)
                .textFieldStyle(.roundedBorder)
                Spacer()
                HStack {
                    Button(role: .cancel) {
                        firstName = employee!.firstName
                        lastName = employee!.lastName
                        department = employee!.department
                        imageData = employee!.imageData
                        modelContext.rollback()
                    } label: {
                        Text("Cancel")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                    Spacer()
                    Button {
                        saveEmployee()
                    } label: {
                        Text("Save")
                            .frame(maxWidth: .infinity)
                    }
                    .disabled(!hasChanges)
                    .buttonStyle(.bordered)
                }
                Spacer()
            }
            .padding(16)
        }
        .background(.white)
        .onAppear {
            if selectedEmployeeID == nil {
                Logger.appdata.debug("No employee selected.")
            } else {
                employee = modelContext.registeredModel(
                    for: selectedEmployeeID!
                )
                if let employee = employee {
                    firstName = employee.firstName
                    lastName = employee.lastName
                    department = employee.department
                    imageData = employee.imageData
                }

                firstName = employee!.firstName
                lastName = employee!.lastName
                department = employee!.department
                imageData = employee!.imageData
            }
        }
        .onChange(of: selectedEmployeeID) { oldValue, newValue in
            employee = modelContext.registeredModel(for: selectedEmployeeID!)
            if let employee = employee {
                firstName = employee.firstName
                lastName = employee.lastName
                department = employee.department
                imageData = employee.imageData
            }

            firstName = employee!.firstName
            lastName = employee!.lastName
            department = employee!.department
            imageData = employee!.imageData
        }
    }

    func saveEmployee() {
        employee!.firstName = firstName
        employee!.lastName = lastName
        employee!.department = department
        employee!.imageData = imageData
        try! modelContext.save()
    }
}

#Preview {
    //TODO: Create a preview with an employee information and image rather than pass in nil.

    /* @Previewable @State var selectedEmployee: Employee = Employee(
         firstName: "John",
         lastName: "Doe",
         department: "Test Department",
         imageData: UIImage(named: "Anne_Lee")?.pngData()
     ) */

    @Previewable @State var selectedEmployee: Employee? = try! DataController
        .previewContainer.mainContext.fetch(
            FetchDescriptor<Employee>(predicate: #Predicate { $0 == $0 })
        ).first!

    @Previewable @State var selectedEmployeeID: Employee.ID? = nil

    EmployeeView(selectedEmployeeID: $selectedEmployeeID)
}
