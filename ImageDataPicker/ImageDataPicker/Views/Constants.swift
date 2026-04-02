//
//  Constants.swift
//  Shared constants used by the ImageDataPicker framework.
//
//  Created by Michael Logothetis on 30/04/2025.
//  Updated by Michael Logothetis on 01/04/2026.
//
//  MIT License
//  Copyright (c) 2025 Michael Logothetis (Technistic Pty Ltd)
//

import Foundation
import SwiftUI

/// Shared default values used by the framework.
public enum Constants {
    /// A person placeholder image to display when no photo is selected.
    public static let personPlaceholder = "person.fill"
    /// A photo placeholder image to display when no photo is available.
    public static let photoPlaceholder = "photo.fill"
    /// An error placeholder image to display when a photo fails to load.
    public static let errorPlaceholder = "exclamationmark.circle.fill"
    /// The relative position of the Edit and Delete buttons located at the lower corners of the image.
    public static let buttonPosition: Double = 1 / (2.0.squareRoot())
}

// Display the standard Placeholder images used by the framework.
#Preview("Constants") {
    VStack {
        Image(systemName: Constants.personPlaceholder)
            .resizable()
            .scaledToFit()
            .border(Color.gray, width: 1)
        Text("Person Placeholder").font(.caption)

        Image(systemName: Constants.photoPlaceholder)
            .resizable()
            .scaledToFit()
            .border(Color.gray, width: 1)
        Text("Photo Placeholder").font(.caption)

        Image(systemName: Constants.errorPlaceholder)
            .resizable()
            .scaledToFit()
            .border(Color.gray, width: 1)
        Text("Error Placeholder").font(.caption)
    }
    .padding(8)
}

// Display the standard Placeholder images used by the framework, along with
// the standard modifiers applied to them in the ImageDataPickerView.
#Preview("with modifiers") {
    VStack {
        Image(systemName: Constants.personPlaceholder)
            .resizable()
            .scaledToFit()
            .scaleEffect(
                SymbolLayoutHelper.scaleFactor(systemImage: Constants.personPlaceholder)
            )
            .squareImageView(shape: Circle())
            .padding(1)
            .border(Color.gray, width: 1)
            .background(.teal)
        Text("Person Placeholder").font(.caption)

        Image(systemName: Constants.photoPlaceholder)
            .resizable()
            .scaledToFit()
            .scaleEffect(
                SymbolLayoutHelper.scaleFactor(systemImage: Constants.photoPlaceholder)
            )
            .squareImageView(shape: Circle())
            .padding(1)
            .border(Color.gray, width: 1)
            .background(.teal)
        Text("Photo Placeholder").font(.caption)

        Image(systemName: Constants.errorPlaceholder)
            .resizable()
            .scaledToFit()
            .scaleEffect(SymbolLayoutHelper.scaleFactor(systemImage: Constants.errorPlaceholder))
            .squareImageView(shape: Circle())
            .padding(1)
            .border(Color.gray, width: 1)
            .background(.teal)
        Text("Error Placeholder").font(.caption)
    }
    .padding(8)
}

// Display the ImageDataPickerView.
#Preview("ImageDataPicker") {
    @Previewable @State var imageData: Data? = nil
    ImageDataPickerView(
        imageData: $imageData,
        clipShape: Circle(),
        backgroundColor: .black,
        foregroundColor: .white
    )
    .background(.teal)
}
