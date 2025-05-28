//
//  Logger+Extension.swift
//  A SwiftUI Image Picker that supporting SwiftData binding.
//
//  Created by Michael Logothetis on 30/04/2025.
//
//  MIT License
//  Copyright (c) 2025 Michael Logothetis (Technistic Pty Ltd)
//

import Foundation
import OSLog

/// These extensions to OSLog, simplify logging.
///
/// The Swift Authors app uses three categories of logging.
///
extension Logger {
    /// Using your bundle identifier is a great way to ensure a unique identifier.
    private static let subsystem = Bundle.main.bundleIdentifier!

    /// Logs application information.
    static let application = Logger(
        subsystem: subsystem,
        category: "application"
    )

    /// Logs data information.
    static let appdata = Logger(
        subsystem: subsystem,
        category: "data"
    )

    /// Logs the view cycles like a view that appeared.
    static let viewCycle = Logger(
        subsystem: subsystem,
        category: "viewcycle"
    )

    /// All logs related to tracking and analytics.
    static let statistics = Logger(
        subsystem: subsystem,
        category: "statistics"
    )

    /// All logs related to unit test cases.
    static let tests = Logger(
        subsystem: subsystem,
        category: "tests"
    )
}
