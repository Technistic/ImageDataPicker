//
//  ImageDataView.swift
//  A SwiftUI Image Picker that supporting SwiftData binding.
//
//  Created by Michael Logothetis on 30/04/2025.
//
//  MIT License
//  Copyright (c) 2025 Michael Logothetis (Technistic Pty Ltd)
//

import OSLog
import SwiftUI

/// An Image View of the supplied ``imageData``, scaled to the size of the parent container and maintaining the image's original aspect ratio.
///
/// The ``ImageDataView`` produced a SwiftUI Image derived from the supplied ``imageData``. ``imageData`` can be stored as an attributed of a SwiftData Model. If ``imageData`` is nil, a placeHolderImage is presented based on an SF Symbols `systemName` image. The default is to use the ``Constants/personPlaceholder`` image but this can be overriden on creation.
///
/// Refer to: [https://developer.apple.com/design/resources/#sf-symbols](https://developer.apple.com/design/resources/#sf-symbols)
///

@available(iOS 17.6, macOS 14.6, *)
public struct ImageDataView: View {

    public var imageData: Data?
    private var emptyImage: String = Constants.personPlaceholder

    /// Initializes an Image View using imageData. Use the emptyImage parameter to override the default system symbol image presented when imageData is nil
    /// - Parameters:
    ///   - imageData: The data for the underlying image. Although this can be in the format of any of the supported platform-native image types, png format is recommended.
    ///   - emptyImage: The system symbol image to use as a placeholder if imageData is nil.
    public init(
        imageData: Data?,
        emptyImage: String = Constants.personPlaceholder
    ) {
        self.imageData = imageData
        self.emptyImage = emptyImage
    }

    public var body: some View {
        imageFromData(imageData)
            .resizable()
            .aspectRatio(contentMode: .fit)
    }
    
    private func imageFromData(_ imageData: Data?) -> Image {
        #if canImport(UIKit)
        if let data = imageData {
            if let uiImage = UIImage(data: data) {
                return Image(uiImage: uiImage)
            } else {
                Logger.appdata.error("Failed to create UIImage from data.")
                return emptyPlaceholderImage
            }
        } else {
            return emptyPlaceholderImage
        }
        #elseif canImport(AppKit)
        if let data = imageData {
            if let nsImage = NSImage(data: data) {
                return Image(nsImage: nsImage)
            } else {
                Logger.appdata.error("Failed to create NSImage from data.")
                return emptyPlaceholderImage
            }
        } else {
            return emptyPlaceholderImage
        }
        #endif
    }

    var emptyPlaceholderImage: Image {
        Image(systemName: self.emptyImage)
    }
}
