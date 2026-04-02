//
//  ImageStateView.swift
//  A SwiftUI view that renders an image from an ImageDataModel.ImageState value.
//
//  Created by Michael Logothetis on 30/04/2025.
//  Updated by Michael Logothetis on 01/04/2026.
//
//  MIT License
//  Copyright (c) 2025 Michael Logothetis (Technistic Pty Ltd)
//

import OSLog
import SwiftUI

/// A SwiftUI view that renders the visual state of an image load operation.
///
/// `ImageStateView` renders these states:
///
/// ``ImageDataModel/ImageState/empty`` displays the empty placeholder image.
///
/// ``ImageDataModel/ImageState/loading(_:)`` displays a ProgressView while the image is loading.
///
/// ``ImageDataModel/ImageState/success(_:)`` displays the loaded image if available, or the empty placeholder if the image data is nil.
///
/// ``ImageDataModel/ImageState/failure(_:)`` displays the error placeholder image and logs the error to the console.
///
public struct ImageStateView: View {
    /// The state to render.
    public var imageState: ImageDataModel.ImageState = .empty
    private var emptyPlaceholder: String = Constants.personPlaceholder
    private var errorPlaceholder: String = Constants.errorPlaceholder
    
    /// - Parameters:
    ///   - imageState: The state to render.
    ///   - emptyPlaceholder: The SF Symbol to use when the state is `.empty`.
    ///   - errorPlaceholder: The SF Symbol to use when the state is `.failure`.
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
                .scaleEffect(SymbolLayoutHelper.scaleFactor(systemImage: emptyPlaceholder))
                
                .offset(x: 0, y: SymbolLayoutHelper.offsetFactor(systemImage: emptyPlaceholder))
        case .loading(_):
            ProgressView()
                .controlSize(.extraLarge)
        case .success(let imageData):
            if imageData != nil {
                ImageDataView(imageData: imageData, placeholder: emptyPlaceholder)
                    .scaledToFill()
            }
            else {
                ImageDataView(imageData: imageData, placeholder: emptyPlaceholder)
                    .scaledToFit()
                    .scaleEffect(SymbolLayoutHelper.scaleFactor(systemImage: emptyPlaceholder))
                    
                    .offset(x: 0, y: SymbolLayoutHelper.offsetFactor(systemImage: emptyPlaceholder))
            }
        case .failure(let error):
            let _: () = Logger.application.error(
                "ImageStateView: Failure - \(error.localizedDescription)"
            )
            ImageDataView(imageData: nil, placeholder: errorPlaceholder)
                .scaleEffect(SymbolLayoutHelper.scaleFactor(systemImage: errorPlaceholder))
                
                .offset(x: 0, y: SymbolLayoutHelper.offsetFactor(systemImage: errorPlaceholder))
        }
    }
}


#Preview("Empty View") {
    @Previewable @State var empty: ImageDataModel.ImageState = .empty
    let placeholder: String = Constants.personPlaceholder

    ImageStateView(imageState: empty)
        .squareImageView(shape: Circle(), background: .blue)
        .foregroundColor(.white)
        .background(.blue.opacity(0.3))
        .frame(width: 200, height: 200)

    ImageStateView(imageState: empty, emptyPlaceholder: placeholder)
        .squareImageView(shape: RoundedRectangle(cornerRadius: 24.0), background: .gray)
        .foregroundColor(.black)
        .frame(width: 200, height: 200)
}

#Preview("Loading View") {
    @Previewable @State var loading: ImageDataModel.ImageState = .loading(
        Progress()
    )

    let placeholder: String = Constants.personPlaceholder

    ImageStateView(imageState: loading)
        .squareImageView(shape: Circle(), background: .blue)
        .background(.blue.opacity(0.3))
        .tint(Color.white)
        .frame(width: 200, height: 200)
        .border(.green)

    ImageStateView(imageState: loading, emptyPlaceholder: placeholder)
        .squareImageView(shape: RoundedRectangle(cornerRadius: 24.0), background: .gray)
        .tint(Color.black)
        .frame(width: 200, height: 200)
}

#Preview("Success View") {
    @Previewable @State var successTest: ImageDataModel.ImageState = .success(
        imageResourceData(for: "TestImage")
    )

    ImageStateView(imageState: successTest)
        .squareImageView(shape: Circle())
    //TODO: Apply background via .squareImageView() modifier instead, and test that it renders correctly with the image.
        .background(.blue.opacity(0.3))
        .frame(width: 200, height: 200)
        .border(.green)

    ImageStateView(imageState: successTest)
        .squareImageView(shape: RoundedRectangle(cornerRadius: 24.0), background: .gray)
        .frame(width: 200, height: 200)
}

 #Preview("Failure View") {
     @Previewable @State var failure: ImageDataModel.ImageState = .failure(
        NSError(domain: "Test", code: 1, userInfo: nil)
     )
 
     let placeholder: String = Constants.errorPlaceholder
 
     ImageStateView(imageState: failure)
         .squareImageView(shape: Circle(), background: .white)
         .foregroundColor(.blue)
         .background(.blue.opacity(0.3))
         .frame(width: 200, height: 200)
 
     ImageStateView(imageState: failure, errorPlaceholder: placeholder)
         .squareImageView(shape: RoundedRectangle(cornerRadius: 24.0), background: .gray)
         .foregroundColor(.black)
         .frame(width: 200, height: 200)
 }
