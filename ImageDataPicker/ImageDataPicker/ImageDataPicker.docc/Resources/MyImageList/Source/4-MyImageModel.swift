//
//  MyImageModel.swift
//  MyImageList
//
//  Copyright © 2025 Technistic Pty Ltd. All rights reserved.
//

import Foundation
import SwiftData
import SwiftUI


// The MyImage model represents an Image with a name and optional imageData.
//
@Model
final class MyImage: Identifiable {
    var imageName: String
    var imageData: Data?

    init(imageName: String, imageData: Data? = nil) {
        self.imageName = imageName
        self.imageData = imageData
    }

    // For convenience, we provide a computed property to return an Image from the imageData.
    var photo: Image {
        #if canImport(UIKit)
            if let imageData, let uiImage = UIImage(data: imageData) {
                return Image(uiImage: uiImage)
            }
        #else
            if let imageData {
                return Image(nsImage: NSImage(data: imageData as Data)!)
            }
        #endif
    }
}
