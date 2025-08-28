//
//  MyImageModel.swift
//  MyImageList
//
//  Copyright © 2025 Technistic Pty Ltd.
//  Refer to LICENSE file for licensing terms.
//

import Foundation
import SwiftData
import SwiftUI

// System image names used as placeholders should imageData be nil.
struct Constants {
    static let photoPlaceholder: String = "photo"
    static let personPlaceholder: String = "person.fill"
}

@Model
final class MyImage: Identifiable {
    var imageName: String
    var imageData: Data?
    //@Attribute(.externalStorage) var imageData: Data?
    
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
        return Image(systemName: Constants.photoPlaceholder)
    }
}
