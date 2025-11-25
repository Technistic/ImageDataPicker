//
//  ImageDataView.swift
//  A SwiftUI Image View that supports SwiftData binding.
//
//  Created by Michael Logothetis on 30/04/2025.
//
//  MIT License
//  Copyright (c) 2025 Michael Logothetis (Technistic Pty Ltd)
//

import Foundation
import OSLog
import SwiftUI

/// An Image view of the supplied ``imageData``, scaled to the size of the parent container and maintaining the image's original aspect ratio.
///
/// The ``ImageDataView`` produced a SwiftUI Image derived from the supplied ``imageData``. ``imageData`` can be stored as an attributed of a SwiftData Model. If ``imageData`` is nil, a placeHolderImage is presented based on an SF Symbols `systemName` image. The default is to use the ``Constants/personPlaceholder`` image but this can be overriden on creation.
///
/// Refer to: [https://developer.apple.com/design/resources/#sf-symbols](https://developer.apple.com/design/resources/#sf-symbols)
///

@available(iOS 13.0, macCatalyst 13.0, macOS 10.15, visionOS 1.0, *)
public struct ImageDataView: View {

    public var imageData: Data?
    private var placeholder: String = Constants.personPlaceholder

    /// Initializes an Image View using imageData. Use the emptyImage parameter to override the default system symbol image presented when imageData is nil
    /// - Parameters:
    ///   - imageData: The data for the underlying image. Although this can be in the format of any of the supported platform-native image types, png format is recommended.
    ///   - placeholder: The system symbol image to use as a placeholder if imageData is nil.
    public init(
        imageData: Data? = nil,
        placeholder: String = Constants.personPlaceholder
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
                        .scaledToFit()
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
                        .scaledToFit()
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

#Preview("Photo View") {
    @Previewable @State var imageData: Data? = nil

    let placeholder: String = "photo"

    ImageDataView(imageData: imageData)
        .border(.green)

    ImageDataView(imageData: imageData)
        .scaledToFit()
        .scaleEffect(Util.scaleFactor(systemImage: placeholder))
        .offset(x: 0, y: Util.offsetFactor(systemImage: placeholder))
        .squareImageView(shape: Circle(), background: .gray)
        // Test .background(), .border(), .frame() modifiers
        .background(.yellow)
        .clipped()
        .border(.green)
        .frame(width: 200, height: 200)
}

#Preview("Exclamation Mark View") {
    @Previewable @State var imageData: Data? = nil

    let placeholder: String = "exclamationmark.triangle"

    ImageDataView(imageData: imageData, placeholder: placeholder)
        .border(.green)

    ImageDataView(imageData: imageData, placeholder: placeholder)
        .scaledToFill()
        .scaleEffect(Util.scaleFactor(systemImage: placeholder))
        .offset(x: 0, y: Util.offsetFactor(systemImage: placeholder))
        .squareImageView(shape: Circle(), background: .gray)
        // Test .background(), .border(), .frame() modifiers
        .background(.yellow)
        .clipped()
        .border(.green)
        .frame(width: 200, height: 200)
}

#if canImport(UIKit)
#Preview("Image View iOS") {
    @Previewable @State var imageData: Data? = UIImage(
        named: "TestPortrait",
        in: Bundle(for: ImageDataModel.self),
        compatibleWith: nil)?
        .pngData()
    
    ImageDataView(imageData: imageData, placeholder: "photo")
        .border(.green)
        .frame(width: 400, height: 400)
    
    ImageDataView(imageData: imageData, placeholder: "photo")
        .scaledToFill()
        .squareImageView(shape: Circle())
    // Test .background(), .border(), .frame() modifiers
        .background(.green)
        .clipped()
        .border(.green)
        .frame(width: 400, height: 400)
}
#else
#Preview("Image View macOS") {
    @Previewable @State var imageData: Data? = Bundle(
        for: ImageDataModel.self)
        .image(forResource: "TestPortrait")?
        .pngData()
    
    ImageDataView(imageData: imageData, placeholder: "photo")
        .border(.green)
    
    ImageDataView(imageData: imageData, placeholder: "photo")
        .scaledToFill()
        .squareImageView(shape: Circle())
    // Test .background(), .border(), .frame() modifiers
        .background(.green)
        .clipped()
        .border(.green)
        .frame(width: 200, height: 200)
}
#endif
