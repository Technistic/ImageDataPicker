//
//  MyImageModel.swift
//  MyImageList
//
//  Copyright © 2025 Technistic Pty Ltd. All rights reserved.
//

import Foundation
import SwiftData


// The MyImage model represents an Image with a name and optional imageData.
//
@Model
final class MyImage: Identifiable {
    var imageName: String
    @Attribute(.externalStorage) var imageData: Data?
}
