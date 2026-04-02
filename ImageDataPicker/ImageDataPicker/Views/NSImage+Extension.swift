//
//  NSImage+Extension.swift
//  NSImage helpers used by the ImageDataPicker framework.
//
//  Created by Michael Logothetis on 30/04/2025.
//  Updated by Michael Logothetis on 02/04/2026.
//
//  MIT License
//  Copyright (c) 2025 Michael Logothetis (Technistic Pty Ltd)
//

import Foundation
import SwiftUI

#if os(macOS)
    import AppKit
    typealias UIImage = NSImage

    extension NSBitmapImageRep {
        var png: Data? { representation(using: .png, properties: [:]) }
    }
    extension Data {
        var bitmap: NSBitmapImageRep? { NSBitmapImageRep(data: self) }
    }
    extension NSImage {
        var png: Data? { tiffRepresentation?.bitmap?.png }

        public func pngData() -> Data? {
            return png
        }
    }
#endif
