//
//  ClippedImageStateView.swift
//  A SwiftUI Image Picker that supporting SwiftData binding.
//
//  Created by Michael Logothetis on 30/04/2025.
//
//  MIT License
//  Copyright (c) 2025 Michael Logothetis (Technistic Pty Ltd)
//

import OSLog
import SwiftUI

/// The `ClippedImageShape` enum defines the clipping shape to apply to the ``ClippedImageStateView``.
public enum ClippedImageShape: Equatable, CaseIterable {
    case round
    case square
    case roundedSquare
}

extension EnvironmentValues {
    @Entry var clippedImageShape: ClippedImageShape = .round
}

extension View {
    public func clippedImageShape(_ imageShape: ClippedImageShape) -> some View
    {
        environment(\.clippedImageShape, imageShape)
    }
}

/// Presents a clipped image view based on the provided image state.
///
/// This view is designed to display images in a specific shape (round, square, or rounded square) based on the provided image state. It handles empty and error states by displaying appropriate placeholder images.
public struct ClippedImageStateView: View {
    @Environment(\.clippedImageShape) var imageShape
    @State private var imageSize: CGSize? = nil

    var imageState: ImageDataModel.ImageState
    private var emptyImage: String = Constants.personPlaceholder
    private var errorImage: String = Constants.errorPlaceholder

    /// Initializes a new instance of `ClippedImageStateView`.
    /// - Parameters:
    ///   - imageState: The ``ImageDataModel/ImageState-swift.enum`` to be displayed.
    ///   - emptyImage: An optional system image name to be displayed when the image state is empty.
    ///   - errorImage: An optional system image name to be displayed when there is an error.
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
        if imageState == .empty || imageState.description() == "failure" {
            switch imageShape {
            case .round:
                SquareImageView(
                    imageState: imageState,
                    emptyImage: emptyImage,
                    errorImage: errorImage
                )
                .scaleEffect(scaleFactor(systemImage: emptyImage))
                .background {
                    Circle()
                        .fill(.thinMaterial)
                }
            case .square:
                SquareImageView(
                    imageState: imageState,
                    emptyImage: emptyImage,
                    errorImage: errorImage
                )
                .scaleEffect(0.9)
                .background {
                    Rectangle()
                        .fill(.thinMaterial)
                }

            case .roundedSquare:
                SquareImageView(
                    imageState: imageState,
                    emptyImage: emptyImage,
                    errorImage: errorImage
                )
                .scaleEffect(0.9)
                .background {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(.thickMaterial)
                }
            }
        } else if imageState.description() == "success" {
            switch imageShape {
            case .round:
                SquareImageView(
                    imageState: imageState,
                    emptyImage: emptyImage,
                    errorImage: errorImage
                )
                .clipShape(Circle())

            case .square:
                SquareImageView(
                    imageState: imageState,
                    emptyImage: emptyImage,
                    errorImage: errorImage
                )
                .clipShape(Rectangle())

            case .roundedSquare:
                SquareImageView(
                    imageState: imageState,
                    emptyImage: emptyImage,
                    errorImage: errorImage
                )
                .clipShape(RoundedRectangle(cornerRadius: 20))
            }
        }
    }

    //TODO: Rename this function to something more appropriate
    /// Calculates the minimum dimension (width or height) of the given size.
    /// - Parameter size: The frame s
    /// - Returns: The minimum dimension of the size.
    func ratio(size: CGSize) -> CGFloat {
        if size.width > size.height {
            return size.height * 1.0
        } else {
            return size.width * 1.0
        }
    }

    //TODO: Rename this function to something more appropriate.
    /// Calcluates the scale factor to apply to a specific system image, so it fits within the bounds of a circle.
    /// - Parameter systemImage: The name of the system image to be scaled.
    /// - Returns: The scale factor to be applied.
    func scaleFactor(systemImage: String) -> CGFloat {
        if systemImage.contains("circle") {
            return 1.0
        } else {
            #if canImport(UIKit)
                let imageSize = UIImage(systemName: systemImage)!.size
                return
                    (min(imageSize.width, imageSize.height)
                    / (((imageSize.width * imageSize.width)
                        + (imageSize.height * imageSize.height)).squareRoot()))
            #else
                let imageSize = NSImage(
                    systemSymbolName: systemImage,
                    accessibilityDescription: "TestImage"
                )!.size
                return
                    (min(imageSize.width, imageSize.height)
                    / (((imageSize.width * imageSize.width)
                        + (imageSize.height * imageSize.height)).squareRoot()))
            #endif
        }
    }
}

#Preview("Square-Placeholder") {
    SquareImageView(
        imageState: ImageDataModel.ImageState.empty
    )
    .border(Color.blue)

    List {
        ClippedImageStateView(imageState: ImageDataModel.ImageState.empty)
            .border(Color.blue)
        ClippedImageStateView(imageState: ImageDataModel.ImageState.empty)
            .border(Color.blue)
        ClippedImageStateView(imageState: ImageDataModel.ImageState.empty)
            .clippedImageShape(.round)
            .border(Color.blue)
    }
}
