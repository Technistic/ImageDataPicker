//
//  MyImageModel.swift
//  MyImageList
//
//  Copyright © 2025 Technistic Pty Ltd.
//  Refer to LICENSE file for licensing terms.
//

import Foundation
import SwiftData

@Model
final class MyImage: Identifiable {
    var imageName: String
    //var imageData: Data?
    @Attribute(.externalStorage) var imageData: Data?
    
    init(imageName: String, imageData: Data? = nil) {
        self.imageName = imageName
        self.imageData = imageData
    }
}
