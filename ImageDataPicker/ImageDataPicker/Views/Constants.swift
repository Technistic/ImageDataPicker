//
//  Constants.swift
//  Constants used the ImageDataPicker framework.
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
    /// The relative horizontal and vertical position of Edit and Delete buttons from the centre of a Frame, calculated as 1 divided by the square root of 2.
    public static let buttonPosition: Double = 1 / (2.0.squareRoot())
}

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

#Preview("with modifiers") {
    VStack {
        Image(systemName: Constants.personPlaceholder)
            .resizable()
            .scaledToFit()
            .scaleEffect(
                Util.scaleFactor(systemImage: Constants.photoPlaceholder)
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
                Util.scaleFactor(systemImage: Constants.photoPlaceholder)
            )
            .squareImageView(shape: Circle())
            .padding(1)
            .border(Color.gray, width: 1)
            .background(.teal)
        Text("Photo Placeholder").font(.caption)

        Image(systemName: Constants.errorPlaceholder)
            .resizable()
            .scaledToFit()
            //.scaleEffect(Util.scaleFactor(systemImage: Constants.photoPlaceholder))
            .squareImageView(shape: Circle())
            .padding(1)
            .border(Color.gray, width: 1)
            .background(.teal)
        Text("Error Placeholder").font(.caption)
    }
    .padding(8)
}
