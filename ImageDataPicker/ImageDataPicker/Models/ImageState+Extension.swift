//
//  ImageState+Extension.swift
//  A SwiftUI Image Picker that supporting SwiftData binding.
//
//  Created by Michael Logothetis on 30/04/2025.
//
//  MIT License
//  Copyright (c) 2025 Michael Logothetis (Technistic Pty Ltd)
//

import Foundation

//TODO: Review support for Equatable and Hashable
extension ImageDataModel.ImageState: Equatable {
    public static func == (
        lhs: ImageDataModel.ImageState,
        rhs: ImageDataModel.ImageState
    ) -> Bool {
        switch (lhs, rhs) {
        case (.empty, .empty):
            return true
        case (.loading(let lhsv), .loading(let rhsv)):
            return lhsv == rhsv
        case (.success(let lhsv), .success(let rhsv)):
            return lhsv == rhsv
        case (.failure(let lhsv), .failure(let rhsv)):
            return lhsv.localizedDescription == rhsv.localizedDescription
        default:
            return false
        }
    }
}
