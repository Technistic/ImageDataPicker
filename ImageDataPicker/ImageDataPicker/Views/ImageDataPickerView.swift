//
//  ImageDataPickerView.swift
//  A SwiftUI Image Picker that supporting SwiftData binding.
//
//  Derived from Sample Code - "Bringing Photos picker to your SwiftUI app"
//  by Apple Inc. © 2022
//
//  See original License in License/License-Apple-Sample-Code
//
//  Created by Michael Logothetis on 30/04/2025.
//
//  MIT License
//  Copyright (c) 2025 Michael Logothetis (Technistic Pty Ltd)
//
//  See License in License/License-Michael-Logothetis-2025
//

import OSLog
import PhotosUI
import SwiftUI

#if canImport(UIKit)
    import UIKit
#endif

//TODO: Move to Environment if used across multiple views.
// The relative position of the edit and delete buttons from the .bottomLeading and .bottomTrailing corners of the (thumbnail) image.
public let buttonPosition: Double = Constants.buttonPosition

/// The ImageDataPickerView is a SwiftUI view that allows users to select and display an image from their photo library. It represents a thumbnail image that can be changed or removed. If no image is selected, a placeholder image is displayed. The placeholder image can be changed to any SF system image. The image will also change to a Progress view while an image is loading or a Failure image if the transfer is unsuccessful. The Failure image can also be customised to any SF system image.
public struct ImageDataPickerView: View {
    @State var viewModel: ImageDataModel = ImageDataModel(imageState: .empty)
    @State private var imageSize: CGSize = .zero

    @Binding var imageData: Data?
    private var emptyImage: String = Constants.personPlaceholder
    private var errorImage: String = Constants.errorPlaceholder

    /// Initializes a new instance of `ImageDataPickerView`.
    /// - Parameters:
    ///   - imageData: A binding to the image data that will be displayed in the view. This should be a `Data?` type, which can be `nil` if no image is selected.
    ///   - emptyImage: A String specifying the system image name to be displayed when the image state is empty. The default is ``Constants/personPlaceholder`` image.
    ///   - errorImage: A String specifying the system image name to be displayed when there is an error. The default is ``Constants/errorPlaceholder`` image.
    public init(
        imageData: Binding<Data?>,
        emptyImage: String = Constants.personPlaceholder,
        errorImage: String = Constants.errorPlaceholder
    ) {
        self._imageData = imageData
        self.viewModel = ImageDataModel(imageState: .empty)
        self.emptyImage = emptyImage
        self.errorImage = errorImage
    }

    public var body: some View {
        ClippedImageStateView(
            imageState: viewModel.imageState,
            emptyImage: emptyImage,
            errorImage: errorImage
        )
        .getSize { viewSize in
            print(viewSize)
            imageSize = viewSize
        }
        .overlay(alignment: .bottomTrailing) {
            PhotosPicker(
                selection: $viewModel.imageSelection,
                matching: .images,
                preferredItemEncoding: PhotosPickerItem
                    .EncodingDisambiguationPolicy.automatic,
                photoLibrary: .shared()
            ) {
                Circle()
                    .opacity(0.0)
                    .frame(width: buttonSize*0.9, height: buttonSize*0.9)
            }
            .clipShape(Circle())
            .contentShape(Circle())
            .overlay(alignment: .center) {
                ImagePickerEditButton()
                    .frame(
                        width: buttonSize,
                        height: buttonSize,
                        alignment: .center
                    )
                    .allowsHitTesting(false)
            }
            //.padding(4)
        }
        .overlay(alignment: .bottomLeading) {
            if viewModel.imageState != .empty {
                Button(role: .destructive) {
                    viewModel.imageState = ImageDataModel.ImageState.empty
                } label: {
                    Circle()
                        .opacity(0.0)
                        .frame(width: buttonSize * 0.9, height: buttonSize * 0.9)

                }
                .clipShape(Circle())
                .contentShape(Circle())
                .overlay(alignment: .center) {
                    ImagePickerDeleteButton()
                        .frame(
                            width: buttonSize,
                            height: buttonSize,
                            alignment: .center
                        )
                        .allowsHitTesting(false)
                }
                //.padding(4)
            }
        }
        .onChange(of: viewModel.imageState) { oldValue, newValue in
            switch newValue {
            case .success(let mydata?):
                self.imageData = mydata
            default:
                imageData = nil
            }
        }
        .onAppear {
            if self.imageData == nil {
                self.viewModel.imageState = .empty
            } else {
                self.viewModel.imageState = .success(self.imageData)
            }
        }
        .onChange(of: self.imageData) { oldValue, newValue in
            if newValue == nil {
                self.viewModel.imageState = .empty
            } else {
                self.viewModel.imageState = .success(self.imageData)
            }
        }
    }

    func ratio(size: CGSize) -> CGFloat {
        return min(size.width, size.height) * 1.0
    }

    private var buttonSize: CGFloat {
        return ratio(size: imageSize) * 0.24
    }

    func bsize(size: CGSize) -> CGFloat {
        return ratio(size: imageSize) * 0.2
    }

    private var paddingSize: CGFloat {
        return (ratio(size: imageSize) * (1.0 - buttonPosition) - buttonSize)
            / 2
    }
}
