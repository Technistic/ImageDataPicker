//
//  SquareImageView.swift
//  A SwiftUI Image Picker that supporting SwiftData binding.
//
//  Created by Michael Logothetis on 30/04/2025.
//
//  MIT License
//  Copyright (c) 2025 Michael Logothetis (Technistic Pty Ltd)
//

import SwiftUI

/// The SquareImageView displays a square (1:1 aspect ratio) view of an image.
///
/// This view is designed to present images in a square format, ensuring that the width and height are equal. For a placeholder image it ensures the entire image fits within the container, while for success images it scales to fill the container.
public struct SquareImageView: View {
    var imageState: ImageDataModel.ImageState
    var emptyImage: String = Constants.personPlaceholder
    var errorImage: String = Constants.errorPlaceholder

    /// Initialiser
    /// - Parameters:
    ///   - imageState: The ``ImageDataModel.ImageState`` to be displayed.
    ///   - emptyImage: Optional system image name to be displayed when the image state is empty.
    ///   - errorImage: Optional system image name to be displayed when there is an error.
    public init(
        imageState: ImageDataModel.ImageState,
        emptyImage: String = Constants.personPlaceholder,
        errorImage: String = Constants.errorPlaceholder
    ) {
        self.imageState = imageState
        self.emptyImage = emptyImage
        self.errorImage = errorImage
    }

    @State private var imageSize: CGSize? = nil

    public var body: some View {
        GeometryReader { geometry in
            // For system images we want to scale the entire image to fit the container.
            if imageState == .empty || imageState.description() == "failure" {
                ImageStateView(
                    imageState: imageState,
                    emptyImage: emptyImage,
                    errorImage: errorImage
                )
                .frame(
                    width: min(geometry.size.width, geometry.size.height),
                    height: min(geometry.size.width, geometry.size.height)
                )
                .scaledToFit()
                .onAppear {
                    imageSize = CGSize(
                        width: min(geometry.size.width, geometry.size.height),
                        height: min(geometry.size.width, geometry.size.height)
                    )
                }  // Make it square
                .clipShape(Rectangle())  // Clip to a square
                .clipped()  // Ensure content outside the frame is clipped
            } else {
                // For success images we want to scale the image to fill the container.
                ImageStateView(
                    imageState: imageState,
                    emptyImage: emptyImage,
                    errorImage: errorImage
                )
                .scaledToFill()
                .frame(
                    width: min(geometry.size.width, geometry.size.height),
                    height: min(geometry.size.width, geometry.size.height)
                )  // Make it square
                .onAppear {
                    imageSize = CGSize(
                        width: min(geometry.size.width, geometry.size.height),
                        height: min(geometry.size.width, geometry.size.height)
                    )
                }
                .clipShape(Rectangle())  // Clip to a square
                .clipped()  // Ensure content outside the frame is clipped
            }
        }
        .frame(
            maxWidth: (imageSize == nil ? .infinity : imageSize!.width),
            maxHeight: (imageSize == nil ? .infinity : imageSize!.height)
        )
    }
}

#Preview("Square-Placeholder") {
    SquareImageView(
        imageState: ImageDataModel.ImageState.empty
    )
    .border(Color.blue)
}
