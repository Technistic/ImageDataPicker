//
//  Constants.swift
//  A SwiftUI Image Picker that supporting SwiftData binding.
//
//  Created by Michael Logothetis on 30/04/2025.
//
//  MIT License
//  Copyright (c) 2025 Michael Logothetis (Technistic Pty Ltd)
//

import Foundation
import SwiftUI

/// Constants used throughout the framework.
/// These constants are used to define system symbols (SF Symbols) that can be used as placeholder images for consistency throughout the app.
public enum Constants {
    /// A person placeholder image to display when no image is available.
    public static let personPlaceholder = "person.fill"
    /// A photo placeholder image to display when no photo is available.
    public static let photoPlaceholder = "photo.fill"
    /// An error placeholder image to display when an image fails to load.
    public static let errorPlaceholder = "exclamationmark.circle.fill"

    public static let buttonPosition: Double = 1 / (2.0.squareRoot())
}
