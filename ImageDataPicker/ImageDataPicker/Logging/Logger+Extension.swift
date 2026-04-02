//
//  Logger+Extension.swift
//  Logging helpers for the ImageDataPicker framework.
//
//  Created by Michael Logothetis on 30/04/2025.
//
//  MIT License
//  Copyright (c) 2025 Michael Logothetis (Technistic Pty Ltd)
//

import Foundation
import OSLog

/// Convenience loggers used by the framework.
///
/// The predefined categories are:
/// - application
/// - data
/// - viewCycle
/// - statistics
/// - tests
extension Logger {
    /// Prefer the framework bundle identifier, then the host app, then a stable fallback.
    private static let subsystem =
        Bundle(for: ImageDataModel.self).bundleIdentifier
        ?? Bundle.main.bundleIdentifier
        ?? "com.technistic.ImageDataPicker"

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
