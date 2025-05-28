//
//  ContentView.swift
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

/// The ``ContentView`` defines the view hierarchy for the ``EmployeeFormExampleApp``.
struct ContentView: View {

    var body: some View {
        EmployeeListView()
    }
}

#Preview {
    ContentView()
        .modelContainer(DataController.previewContainer)
}
