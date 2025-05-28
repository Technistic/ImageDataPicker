//
//  ImageStateView.swift
//  A SwiftUI Image Picker that supporting SwiftData binding.
//
//  Created by Michael Logothetis on 30/04/2025.
//
//  MIT License
//  Copyright (c) 2025 Michael Logothetis (Technistic Pty Ltd)
//

import OSLog
import SwiftUI

/// The ``ImageStateView`` provides an Image view that represents the ``ImageDataModel/ImageState`` associated with the state of an image being loaded using the PhotosUI PhotosPicker.
///
/// This view is designed to handle various image transfer states, including:
/// ``ImageDataModel/ImageState/empty``
/// ``ImageDataModel/ImageState/loading(_:)``
/// ``ImageDataModel/ImageState/success(_:)``
/// ``ImageDataModel/ImageState/failure(_:)
///
/// If the `imageState` is `.empty`, it will display a placeholder image defined by the `emptyImage` parameter.
///
/// If the `imageState` is `.loading`, it will display a `ProgressView` until the image is loaded.
///
/// If the `imageState` is `.success`, it will display the loaded image.
///
/// If the `imageState` is `.failure`, it will display an error placeholder image defined by the `errorImage` parameter.
///
public struct ImageStateView: View {
    var imageState: ImageDataModel.ImageState
    var emptyImage: String = Constants.personPlaceholder
    var errorImage: String = Constants.errorPlaceholder

    public init(
        imageState: ImageDataModel.ImageState,
        emptyImage: String = Constants.personPlaceholder,
        errorImage: String = Constants.errorPlaceholder
    ) {
        self.imageState = imageState
        self.emptyImage = emptyImage
        self.errorImage = errorImage
    }

    public var body: some View {
        switch imageState {
        case .success(let imageData):
            ImageDataView(imageData: imageData, emptyImage: emptyImage)
        case .loading:
            ProgressView()
                // TODO: Implement a responsive mechanism to size the ProgressView
                .controlSize(.extraLarge)
        case .empty:
            ImageDataView(imageData: nil, emptyImage: emptyImage)
        case .failure:
            errorPlaceholderImage
                .resizable()
                .aspectRatio(contentMode: .fit)
        }
    }

    var emptyPlaceholderImage: Image {
        Image(systemName: self.emptyImage)
    }

    var errorPlaceholderImage: Image {
        Image(systemName: self.errorImage)
    }
}
