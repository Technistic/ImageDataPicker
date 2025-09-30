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
    public var imageState: ImageDataModel.ImageState = .empty
    private var emptyPlaceholder: String = Constants.personPlaceholder
    private var errorPlaceholder: String = Constants.errorPlaceholder

    public init(
        imageState: ImageDataModel.ImageState = .empty,
        emptyPlaceholder: String = Constants.personPlaceholder,
        errorPlaceholder: String = Constants.errorPlaceholder
    ) {
        self.imageState = imageState
        self.emptyPlaceholder = emptyPlaceholder
        self.errorPlaceholder = errorPlaceholder
    }

    public var body: some View {
        switch imageState {
        case .empty:
            ImageDataView(imageData: nil, placeholder: emptyPlaceholder)
                // TODO: Consider scaling the placeholder image using Util.scaleFactor(systemImage: emptyPlaceholder)
        case .loading(_):
            ProgressView()
                // TODO: Implement a responsive mechanism to size the ProgressView
                //.controlSize(.extraLarge)
        case .success(let imageData):
            ImageDataView(imageData: imageData, placeholder: emptyPlaceholder)
                .scaledToFill()
        case .failure(let error):
            // TODO: Reassess the use of an ImageDataView with an errorPlaceholder here.
            let _: () = Logger.application.error(
                "ImageStateView: Failure - \(error.localizedDescription)"
            )
            ImageDataView(imageData: nil, placeholder: errorPlaceholder)
        }
    }
}

#Preview("Empty View") {
    @Previewable @State var empty: ImageDataModel.ImageState = .empty
    let placeholder: String = "person"

    ImageStateView(imageState: empty)
        .frame(width: 200, height: 200)

    ImageStateView(imageState: empty)
        .foregroundColor(.red)
        .scaleEffect(Util.scaleFactor(systemImage: placeholder))
        .offset(x: 0, y: Util.offsetFactor(systemImage: placeholder))
        .squareImageView(shape: Circle(), background: .white)
        // Test .background(), .frame() modifiers
        .background(.red)
        .frame(width: 200, height: 200)
}

#Preview("Loading View") {
    @Previewable @State var loading: ImageDataModel.ImageState = .loading(
        Progress()
    )

    let placeholder: String = "person"

    ImageStateView(imageState: loading)
        .frame(width: 200, height: 200)
        .border(.red)

    ImageStateView(imageState: loading, emptyPlaceholder: placeholder)
        .tint(Color.white)
        .scaleEffect(1.5)
        .squareImageView(shape: Circle(), background: .blue)
        // Test .background(), .frame() modifiers
        .background(.green)
        .frame(width: 200, height: 200)
}

#if canImport(UIKit)
#Preview("Success View iOS") {
    @Previewable @State var successTest: ImageDataModel.ImageState = .success(
        UIImage(
            named: "TestImage",
            in: Bundle(for: ImageDataModel.self),
            compatibleWith: nil)?
            .pngData()
    )

    ImageStateView(imageState: successTest)
        .frame(width: 200, height: 200)
        .clipped()

    ImageStateView(imageState: successTest)
        .squareImageView(shape: Circle(), background: .mint)
        // Test .background(), .border(), .frame() modifiers
        .background(.green)
        .clipped()
        .border(.red, width: 2.0)
        .frame(width: 200, height: 200)
}
#else
#Preview("Success View macOS") {
    @Previewable @State var successTest: ImageDataModel.ImageState = .success(
    Bundle(
    for: ImageDataModel.self)
    .image(forResource: "TestImage")?
    .pngData()
    )

ImageStateView(imageState: successTest)
    .frame(width: 200, height: 200)
    .clipped()

ImageStateView(imageState: successTest)
    .squareImageView(shape: Circle(), background: .mint)
    // Test .background(), .border(), .frame() modifiers
    .background(.green)
    .clipped()
    .border(.red, width: 2.0)
    .frame(width: 200, height: 200)
}
#endif

#Preview("Failure View") {
    @Previewable @State var failure: ImageDataModel.ImageState = .failure(
        NSError(domain: "Test", code: 1, userInfo: nil)
    )

    let placeholder: String = "exclamationmark.triangle"

    ImageStateView(imageState: failure)
        .frame(width: 200, height: 200)

    ImageStateView(imageState: failure, errorPlaceholder: placeholder)
        .foregroundColor(.red)
        .scaleEffect(Util.scaleFactor(systemImage: placeholder))
        .offset(x: 0, y: Util.offsetFactor(systemImage: placeholder))
        .squareImageView(shape: Circle(), background: .white)
        // Test .background(), .frame() modifiers
        .background(.gray)
        .frame(width: 200, height: 200)
}
