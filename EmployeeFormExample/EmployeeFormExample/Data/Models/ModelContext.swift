//
//  ModelContext.swift
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
import SwiftData


/// The ``sqliteCommand`` is an extension of `ModelContext`, allowing you to retrieve the path of the sqlite database.
extension ModelContext {
    /// The path to the sqlite3 database.
    var sqliteCommand: String {
        if let url = container.configurations.first?.url.path(
            percentEncoded: false
        ) {
            "sqlite3 \"\(url)\""
        } else {
            "No SQLite database found."
        }
    }
}
