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
    @Environment(\.modelContext) private var modelContext

    @Binding public var selectedEmployeeID: Employee.ID?
    @State var employee: Employee?

    @State var clippingSelection: ClipShape = ClipShape.circle
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var department: String = ""
    @State private var imageData: Data? = nil

    var body: some View {
        var hasChanges: Bool {
            guard let employee else {
                return false
            }

            return firstName != employee.firstName
                || lastName != employee.lastName
                || department != employee.department
                || imageData != employee.imageData
        }

        ScrollView {
            VStack {
                HStack {
                    Text("\(firstName) \(lastName)")
                        .font(.title)
                        .foregroundStyle(.secondary)
                        .accessibilityIdentifier(
                            UIIdentifiers.EmployeeView.title
                        )
                }

                ImageDataPickerView(imageData: $imageData,
                                    clipShape: clippingShape(selection: clippingSelection), backgroundColor: .blue.opacity(0.3), foregroundColor: .white)
                    .padding(8)
                    .frame(width: 240, height: 240)
                    //.background(.blue.opacity(0.3), ignoresSafeAreaEdges: [])

                VStack(alignment: .center) {
                    Label("Employee Name", systemImage: "person.fill")
                        .font(.title)
                        //.foregroundColor(.secondary)
                        .multilineTextAlignment(.leading)
                    HStack {
                        TextField("Given Name", text: $firstName)
                            .disableAutocorrection(true)
                            .accessibilityLabel("Given Name")
                            .accessibilityIdentifier(
                                UIIdentifiers.EmployeeView.firstNameTextField
                            )
                        TextField("Family Name", text: $lastName)
                            .disableAutocorrection(true)
                            .accessibilityLabel("Family Name")
                            .accessibilityIdentifier(
                                UIIdentifiers.EmployeeView.lastNameTextField
                            )
                    }
                    Label("Department", systemImage: "person.3.fill")
                        .font(.title)
                        .padding(.top, 16)
                    //.foregroundColor(.primary)

                    TextField("Department", text: $department)
                        .disableAutocorrection(true)
                        .accessibilityIdentifier(
                            UIIdentifiers.EmployeeView.departmentTextField
                        )
                    HStack {
                        Button(role: .cancel) {
                            resetFormFields()
                            modelContext.rollback()
                        } label: {
                            Text("Cancel")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.bordered)
                        .accessibilityIdentifier(
                            UIIdentifiers.EmployeeView.cancelButton
                        )

                        Button {
                            saveEmployee()
                        } label: {
                            Text("Save")
                                .frame(maxWidth: .infinity)
                        }
                        .disabled(!hasChanges)
                        .buttonStyle(.bordered)
                        .accessibilityIdentifier(
                            UIIdentifiers.EmployeeView.saveButton
                        )
                    }
                    .padding(.top, 16)
                }
                .padding(24)
                .background(.gray.opacity(0.4))
                .cornerRadius(12)
                .textFieldStyle(.roundedBorder)
            }
            .padding(16)

            Picker("Clipping Shape:", selection: $clippingSelection) {
                Image(systemName: "circle.fill")
                    .tag(ClipShape.circle)
                Image(systemName: "square.fill")
                    .tag(ClipShape.roundedSquare)
                Image(systemName: "square")
                    .tag(ClipShape.square)
            }
            .pickerStyle(.segmented)
            .padding(24)
        }
        #if os(iOS)
            .background(Color(.tertiarySystemBackground))
        #endif

        .onAppear {
            syncSelectedEmployee()
        }
        .onChange(of: selectedEmployeeID) { oldValue, newValue in
            syncSelectedEmployee()
        }
    }

    func saveEmployee() {
        guard let employee else {
            Logger.appdata.error("Unable to save employee because no employee is selected.")
            return
        }

        employee.firstName = firstName
        employee.lastName = lastName
        employee.department = department
        employee.imageData = imageData

        do {
            try modelContext.save()
        } catch {
            Logger.appdata.error("Failed to save employee: \(error.localizedDescription)")
        }
    }

    private func syncSelectedEmployee() {
        guard let selectedEmployeeID else {
            Logger.appdata.debug("No employee selected.")
            employee = nil
            resetFormFields()
            return
        }

        employee = modelContext.registeredModel(for: selectedEmployeeID)

        guard let employee else {
            Logger.appdata.error("Unable to resolve selected employee.")
            self.selectedEmployeeID = nil
            resetFormFields()
            return
        }

        firstName = employee.firstName
        lastName = employee.lastName
        department = employee.department
        imageData = employee.imageData
    }

    private func resetFormFields() {
        firstName = employee?.firstName ?? ""
        lastName = employee?.lastName ?? ""
        department = employee?.department ?? ""
        imageData = employee?.imageData
    }
}

enum ClipShape {
    case circle
    case square
    case roundedSquare
}

func clippingShape(selection: ClipShape) -> AnyShape {
    switch selection {
    case .circle:
        return AnyShape(Circle())
    case  .square:
        return AnyShape(Rectangle())
    case .roundedSquare:
        return AnyShape(RoundedRectangle(cornerRadius: 12))
    }
}

#Preview {
    //TODO: Create a preview with an employee information and image rather than pass in nil.

    @Previewable @State var selectedEmployeeID: Employee.ID?
    @Previewable @State var selectedEmployee: Employee = Employee(
         firstName: "John",
         lastName: "Doe",
         department: "Test Department",
         imageData: UIImage(named: "Anne_Lee")?.pngData()
    )
    //DataController.previewContainer.mainContext.insert(selectedEmployee)
    
    //selectedEmployeeID = selectedEmployee.persistentModelID

    EmployeeView(selectedEmployeeID: $selectedEmployeeID, employee: selectedEmployee)
        .onAppear {
            //DataController.previewContainer.mainContext.insert(selectedEmployee)
            //selectedEmployeeID = selectedEmployee.persistentModelID
        }
        
}
