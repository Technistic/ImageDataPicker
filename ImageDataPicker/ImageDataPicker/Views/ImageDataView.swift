//
//  ImageDataView.swift
//  A SwiftUI view that displays image data or a fallback symbol.
//
//  Created by Michael Logothetis on 30/04/2025.
//  Updated by Michael Logothetis on 01/04/2026.
//
//  MIT License
//  Copyright (c) 2025 Michael Logothetis (Technistic Pty Ltd)
//

import Foundation
import OSLog
import SwiftUI

/// A SwiftUI image view backed by `Data?`.
///
/// `ImageDataView` converts `Data?` into a platform image (`UIImage` or `NSImage`).
/// If conversion fails or the data is `nil`, it displays the supplied SF Symbol placeholder.
///
/// An Image is displayed with `.scaledToFill()` to ensure it fills the view, and the placeholder is displayed with `.scaledToFit()` to maintain its aspect ratio.

@available(iOS 13.0, macCatalyst 13.0, macOS 10.15, visionOS 1.0, *)
public struct ImageDataView: View {

    public var imageData: Data?
    private var placeholder: String = Constants.photoPlaceholder

    /// Creates an image view from imageData.
    /// - Parameters:
    ///   - imageData: The image data to display, typically .png.
    ///   - placeholder: The SF Symbol to display if `imageData` is `nil` or invalid. Defaults to ``Constants/photoPlaceholder``.
    public init(
        imageData: Data? = nil,
        placeholder: String = Constants.photoPlaceholder
    ) {
        self.imageData = imageData
        self.placeholder = placeholder
    }

    public var body: some View {
        #if canImport(UIKit)
            if let imageData {
                if let uiImage = UIImage(data: imageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                } else {
                    Image(systemName: placeholder)
                        .resizable()
                        .scaledToFit()
                }
            } else {
                Image(systemName: placeholder)
                    .resizable()
                    .scaledToFit()
            }
        #endif
        #if canImport(AppKit)
            if let imageData {
                if let nsImage = NSImage(data: imageData) {
                    Image(nsImage: nsImage)
                        .resizable()
                        .scaledToFill()
                } else {
                    Image(systemName: placeholder)
                        .resizable()
                        .scaledToFit()
                }
            } else {
                Image(systemName: placeholder)
                    .resizable()
                    .scaledToFit()
            }
        #endif
    }
}


/// This helper function loads an Image resource from the bundle and returns its data as .png `Data?`. It handles both UIKit and AppKit image loading.
/// - Parameter _imageResource: The name of the image resource to load from the bundle.
/// - Returns: pngData for the specified image resource, or `nil` if the resource cannot be found or loaded.
func imageResourceData(for _imageResource: String) -> Data? {
#if canImport(UIKit)
    return UIImage(named: _imageResource,
    in: Bundle(for: ImageDataModel.self),
    compatibleWith: nil)?.pngData()
#else
    return Bundle(
        for: ImageDataModel.self)
        .image(forResource: _imageResource)?
        .pngData()
#endif
}

#Preview("Image") {
    @Previewable @State var imageData: Data? = imageResourceData(for: "TestPortrait")
    
    VStack {
        ImageDataView(imageData: imageData)
            .border(.green)
        Text("Image Data")
    }
}

#Preview("Image-Scaled") {
    @Previewable @State var imageData: Data? = imageResourceData(for: "TestPortrait")

    VStack {
        ImageDataView(imageData: imageData)
            .scaledToFit()
            .border(.green)
        Text("Image Scaled")
    }
}

#Preview("Placeholders") {
    HStack {
        VStack {
            ImageDataView(imageData: nil)
                .border(.green)
            Text("Default Placeholder")
        }
        VStack {
            ImageDataView(imageData: nil, placeholder: "person")
                .border(.green)
            Text("Specified Placeholder")
        }
    }
}

#Preview("Image-Squared") {
    @Previewable @State var imageData: Data? = imageResourceData(for: "TestPortrait")

    VStack {
        ImageDataView(imageData: imageData)
            .scaledToFill()
            .squareImageView(shape: Circle())
            .background(.blue.opacity(0.3), ignoresSafeAreaEdges: [])
            .border(.green)
        ImageDataView(imageData: imageData)
            .scaledToFill()
            .squareImageView(shape: RoundedRectangle(cornerRadius: 24.0))
        Text("Image Scaled")
    }
}

#Preview("Placeholders-Squared") {
    @Previewable @State var imageData: Data? = imageResourceData(for: "TestPortrait")
    
    HStack {
        VStack {
            ImageDataView(imageData: nil)
            .foregroundColor(.white)
            .scaleEffect(SymbolLayoutHelper.scaleFactor(systemImage: Constants.photoPlaceholder))
            .offset(x: 0, y: SymbolLayoutHelper.offsetFactor(systemImage: Constants.photoPlaceholder))
            .squareImageView(shape: Circle(), background: .blue)
            .background(.blue.opacity(0.3))
            .border(.green)
            Text("Default Placeholder")
        }
        
        VStack {
            ImageDataView(imageData: nil, placeholder: "person")
                .foregroundColor(.white)
                .scaleEffect(SymbolLayoutHelper.scaleFactor(systemImage: Constants.personPlaceholder))
                .offset(x: 0, y: SymbolLayoutHelper.offsetFactor(systemImage: Constants.personPlaceholder))
                .squareImageView(shape: RoundedRectangle(cornerRadius: 24.0), background: .blue)

            Text("Specified Placeholder")
        }
    }
}
