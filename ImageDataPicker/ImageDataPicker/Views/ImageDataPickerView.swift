//
//  ImageDataPickerView.swift
//  ImageDataPicker
//
//  Created by Michael Logothetis on 06/09/2025.
//

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

/// A  **SwiftUI**  view to select, display and store a photo from a user's photo library.
///
/// The ``ImageDataPickerView`` presents a thumbnail `Image` of a photo selected from a user's photo library. It is overlayed with an **edit** button that allows the photo to be changed and optionally, a **delete** button that removes the selected photo. The `Image` is presented in a 1:1 aspect ratio and can be clipped to either a `Circle(), `Rectangle()` or `RoundedRectangle()` shape.
///
/// To simplify integration with **SwiftData**,  data associated with the selected photo is bound to an `imageData` property of type `Data?`. If no Image is selected (`imageData == nil`), a placeholder image is displayed. The placeholder image can be changed to any SF symbol. The Image will change to a **Progress View** while an image is loading or a **Failure** image if the transfer is unsuccessful. The **Failure** image can also be customized to any SF symbol.
public struct ImageDataPickerView<S: Shape>: View {
    @Binding var imageData: Data?
    private var emptyImage: String = Constants.personPlaceholder
    private var errorImage: String = Constants.errorPlaceholder
    private var cshape: S

    #if canImport(AppKit)
        private var backgroundColor: NSColor = NSColor.windowBackgroundColor
        private var foregroundColor: NSColor = NSColor.labelColor
    #else
        private var backgroundColor: Color = Color(uiColor: .systemBackground)
        private var foregroundColor: Color = Color(uiColor: .label)
    #endif

    @State var viewModel: ImageDataModel = ImageDataModel(imageState: .empty)
    //@State private var imageSize: CGSize = CGSize(width: CGFloat.infinity, height: CGFloat.infinity)
    @State private var imageSize: CGSize = .zero

    /// Initializes a new instance of `ImageDataPickerView`.
    ///
    /// - Parameters:
    ///   - imageData: A binding to the image data that will be displayed in the view. This should be a `Data?` type, which can be `nil`
    ///   if no image is selected.
    ///   - emptyImage: A String specifying the systemName of the system symbol image to be displayed when the image state is empty. The default is  ``Constants/personPlaceholder`` image.
    ///   - errorImage: A String specifying the systemName of the system symbol  image to be displayed when there is an error. The default is
    ///   ``Constants/errorPlaceholder`` image.
    ///   - cshape: The clipping shape to apply to the image. This can be any SwiftUI Shape, such as Circle(), Rectangle() or RoundedRectangle(cornerRadius:).
    ///   - backgroundColor: The background color to apply to the image. The default is the system background color.
    ///   - foregroundColor: The foreground color to apply to the image. The default is the system label color.
#if canImport(AppKit)
    /// Iniitializer for the ImageDataPickerView().
    /// - Parameters:
    ///   - imageData: Property to bind the image data to.
    ///   - emptyImage: A String specifying the system image name to be displayed when the image state is empty. The default is  ``Constants/personPlaceholder`` image.
    ///   - errorImage: A String specifying the system image name to be displayed when there is an error. The default is ``Constants/errorPlaceholder`` image.
    ///   - cshape: The clipping shape to apply to the image. This can be any SwiftUI Shape, such as Circle(), Rectangle() or RoundedRectangle(cornerRadius:).
    ///   - backgroundColor: The background color to apply to the placeholder  image. The default is the system background color.
    ///   - foregroundColor: The foreground color to apply to the placeholder image. The default is the system label color.
        public init(
            imageData: Binding<Data?>,
            emptyImage: String = Constants.personPlaceholder,
            errorImage: String = Constants.errorPlaceholder,
            cshape: S,
            backgroundColor: NSColor = NSColor.windowBackgroundColor,
            foregroundColor: NSColor = NSColor.labelColor
        ) {
            self._imageData = imageData
            self.emptyImage = emptyImage
            self.errorImage = errorImage
            self.cshape = cshape
            self.backgroundColor = backgroundColor
            self.foregroundColor = foregroundColor
        }
#else
    /// Initializer for the ImageDataPickerView().
    /// - Parameters:
    ///   - imageData: A binding to the image data that will be displayed in the view. This should be a `Data?` type, which can be `nil`
    ///   if no image is selected.
    ///   - emptyImage: A String specifying the system image name to be displayed when the image state is empty. The default is  ``Constants/personPlaceholder`` image.
    ///   - errorImage: A String specifying the system image name to be displayed when there is an error. The default is
    ///   ``Constants/errorPlaceholder`` image.
    ///   - cshape: The clipping shape to apply to the image. This can be any SwiftUI Shape, such as Circle(), Rectangle() or RoundedRectangle(cornerRadius:).
    ///   - backgroundColor: The background color to apply to the image. The default is the system background color.
    ///   - foregroundColor: The foreground color to apply to the image. The default is the system label color.
        public init(
            imageData: Binding<Data?>,
            emptyImage: String = Constants.personPlaceholder,
            errorImage: String = Constants.errorPlaceholder,
            cshape: S,
            backgroundColor: Color = Color(.systemBackground),
            foregroundColor: Color = Color(.label)
        ) {
            self._imageData = imageData
            self.emptyImage = emptyImage
            self.errorImage = errorImage
            self.cshape = cshape
            self.backgroundColor = backgroundColor
            self.foregroundColor = foregroundColor
        }
    #endif

    public var body: some View {
        ClippedImageStateView(
            imageState: viewModel.imageState,
            emptyPlaceholder: emptyImage,
            errorPlaceholder: errorImage,
            cshape: cshape,
            backgroundColor: backgroundColor,
            foregroundColor: foregroundColor
        )
        .getSize { viewSize in
            Logger.application.debug("\(viewSize.debugDescription)")
            imageSize.width = viewSize.width
            imageSize.height = viewSize.height
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
                    .frame(width: buttonSize * 0.9, height: buttonSize * 0.9)
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
        }
        .overlay(alignment: .bottomLeading) {
            if viewModel.imageState != .empty {
                Button(role: .destructive) {
                    viewModel.imageState = ImageDataModel.ImageState.empty
                } label: {
                    Circle()
                        .opacity(0.0)
                        .frame(
                            width: buttonSize * 0.9,
                            height: buttonSize * 0.9
                        )

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
                // For testing: Simulate loading state on appear
                // self.viewModel.imageState = .loading(Progress())
                // For testing: Simulate failure state on appear
                //self.viewModel.imageState = .failure(NSError(domain: "Test", code: 1, userInfo: nil))
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

/// A SwiftUI view that displays an image based on its state (empty, loading, failure, or success) and clipped to a specified shape with background and foreground colors appliede.
public struct ClippedImageStateView<S: Shape>: View {
    public var imageState: ImageDataModel.ImageState = .empty
    private var emptyPlaceholder: String = Constants.personPlaceholder
    private var errorPlaceholder: String = Constants.errorPlaceholder

    let cshape: S

    #if canImport(AppKit)
        private var backgroundColor: Color = Color(
            nsColor: NSColor.windowBackgroundColor
        )
        private var foregroundColor: Color = Color(nsColor: NSColor.labelColor)
    #else
        private var backgroundColor: Color = Color(.systemBackground)
        private var foregroundColor: Color = Color(.label)
    #endif

    /// Initializes a new instance of `ClippedImageStateView`.
    /// - Parameters:
    ///   - imageState: The ``ImageDataModel/ImageState-swift.enum`` to be displayed.
    ///   - emptyImage: An optional system image name to be displayed when the image state is empty.
    ///   - errorImage: An optional system image name to be displayed when there is an error.
    #if canImport(AppKit)
        public init(
            imageState: ImageDataModel.ImageState = ImageDataModel.ImageState
                .empty,
            emptyPlaceholder: String = Constants.personPlaceholder,
            errorPlaceholder: String = Constants.errorPlaceholder,
            cshape: S,
            backgroundColor: NSColor = NSColor.windowBackgroundColor,
            foregroundColor: NSColor = NSColor.labelColor
        ) {
            self.imageState = imageState
            self.emptyPlaceholder = emptyPlaceholder
            self.errorPlaceholder = errorPlaceholder
            self.cshape = cshape
            self.backgroundColor = Color(nsColor: backgroundColor)
            self.foregroundColor = Color(nsColor: foregroundColor)
        }
    #else
        public init(
            imageState: ImageDataModel.ImageState = ImageDataModel.ImageState
                .empty,
            emptyPlaceholder: String = Constants.personPlaceholder,
            errorPlaceholder: String = Constants.errorPlaceholder,
            cshape: S,
            backgroundColor: Color = Color(.systemBackground),
            foregroundColor: Color = Color(.label)
        ) {
            self.imageState = imageState
            self.emptyPlaceholder = emptyPlaceholder
            self.errorPlaceholder = errorPlaceholder
            self.cshape = cshape
            self.backgroundColor = backgroundColor
            self.foregroundColor = foregroundColor
        }
    #endif

    public var body: some View {
        if imageState.description() == "success" {
            ImageStateView(imageState: imageState)
                .modifier(
                    SquareImageViewModifier(
                        shape: cshape,
                        background: backgroundColor
                    )
                )
        } else if imageState.description() == "loading" {
            ImageStateView(imageState: imageState)
                .tint(foregroundColor)
                .modifier(
                    SquareImageViewModifier(
                        shape: cshape,
                        background: backgroundColor
                    )
                )
        } else if imageState.description() == "failure" {
            ImageStateView(
                imageState: imageState,
                emptyPlaceholder: emptyPlaceholder,
                errorPlaceholder: errorPlaceholder
            )
            .foregroundColor(foregroundColor)
            .scaleEffect(Util.scaleFactor(systemImage: errorPlaceholder))
            .offset(x: 0, y: Util.offsetFactor(systemImage: errorPlaceholder))
            .modifier(
                SquareImageViewModifier(
                    shape: cshape,
                    background: backgroundColor
                )
            )
        } else {
            ImageStateView(
                imageState: imageState,
                emptyPlaceholder: emptyPlaceholder,
                errorPlaceholder: errorPlaceholder
            )
            .foregroundColor(foregroundColor)
            //.scaleEffect(Util.scaleFactor(systemImage: emptyPlaceholder))
            //.offset(x: 0, y: Util.offsetFactor(systemImage: emptyPlaceholder))
            .modifier(
                SquareImageViewModifier(
                    shape: cshape,
                    background: backgroundColor
                )
            )
        }
    }
}

#if canImport(UIKit)
    #Preview("ImageDataPickerView") {
        @Previewable @State var nilImageData: Data? = nil
        @Previewable @State var successImageData: Data? = UIImage(
            named: "TestImage",
            in: Bundle(for: ImageDataModel.self),
            compatibleWith: nil
        )?
        .pngData()

        VStack {
            ImageDataPickerView(
                imageData: $nilImageData,
                cshape: Circle(),
                backgroundColor: .red,
                foregroundColor: .white
            )

            ImageDataPickerView(
                imageData: $nilImageData,
                cshape: RoundedRectangle(cornerRadius: 12),
                backgroundColor: .yellow,
                foregroundColor: .red
            )

            ImageDataPickerView(
                imageData: $nilImageData,
                cshape: Rectangle(),
                backgroundColor: .orange,
                foregroundColor: .purple
            )

            ImageDataPickerView(
                imageData: $successImageData,
                cshape: Circle()
            )
            .background(.yellow)
            .frame(width: 100, height: 100)

            ImageDataPickerView(
                imageData: $successImageData,
                cshape: Rectangle()
            )
        }
    }
#else
    #Preview("ImageDataPickerView") {
        @Previewable @State var nilImageData: Data? = nil
        @Previewable @State var successImageData: Data? = Bundle(
            for: ImageDataModel.self
        )
        .image(forResource: "TestImage")?
        .pngData()

        VStack {
            ImageDataPickerView(
                imageData: $nilImageData,
                cshape: Circle(),
                backgroundColor: .red,
                foregroundColor: .white
            )

            ImageDataPickerView(
                imageData: $nilImageData,
                cshape: RoundedRectangle(cornerRadius: 12),
                backgroundColor: .yellow,
                foregroundColor: .red
            )

            ImageDataPickerView(
                imageData: $nilImageData,
                cshape: Rectangle(),
                backgroundColor: .orange,
                foregroundColor: .purple
            )

            ImageDataPickerView(
                imageData: $successImageData,
                cshape: Circle()
            )
            .background(.yellow)
            .frame(width: 100, height: 100)

            ImageDataPickerView(
                imageData: $successImageData,
                cshape: Rectangle()
            )
        }
    }
#endif

#if canImport(UIKit)
    #Preview("Clipped Image State View") {
        @Previewable @State var emptyState: ImageDataModel.ImageState = .empty
        @Previewable @State var failureState: ImageDataModel.ImageState =
            .failure(
                NSError(domain: "", code: 0, userInfo: nil)
            )
        @Previewable @State var loadingState: ImageDataModel.ImageState =
            .loading(
                Progress()
            )
        @Previewable @State var successState: ImageDataModel.ImageState =
            .success(
                UIImage(
                    named: "TestImage",
                    in: Bundle(for: ImageDataModel.self),
                    compatibleWith: nil
                )?
                .pngData()
            )

        ClippedImageStateView(
            imageState: emptyState,
            emptyPlaceholder: "person.circle",
            cshape: Circle(),
            backgroundColor: .white,
            foregroundColor: .red
        )
        .background(.black, ignoresSafeAreaEdges: [])

        ClippedImageStateView(
            imageState: emptyState,
            emptyPlaceholder: "person.circle",
            cshape: RoundedRectangle(cornerRadius: 12),
            backgroundColor: .red,
            foregroundColor: .orange
        )

        ClippedImageStateView(
            imageState: failureState,
            errorPlaceholder: "exclamationmark.circle",
            cshape: Rectangle(),
            backgroundColor: .red,
            foregroundColor: .yellow
        )
        ClippedImageStateView(
            imageState: loadingState,
            cshape: Circle(),
            backgroundColor: .green,
            foregroundColor: .white
        )
        .background(.blue)

        ClippedImageStateView(
            imageState: successState,
            cshape: Circle(),
            backgroundColor: .red,
            foregroundColor: .yellow
        )
    }
#else
    #Preview("Clipped Image State View") {
        @Previewable @State var emptyState: ImageDataModel.ImageState = .empty
        @Previewable @State var failureState: ImageDataModel.ImageState =
            .failure(
                NSError(domain: "", code: 0, userInfo: nil)
            )
        @Previewable @State var loadingState: ImageDataModel.ImageState =
            .loading(
                Progress()
            )
        @Previewable @State var successState: ImageDataModel.ImageState =
            .success(
                Bundle(for: ImageDataModel.self)
                    .image(forResource: "TestImage")?
                    .pngData()
            )

        ClippedImageStateView(
            imageState: emptyState,
            emptyPlaceholder: "person.circle",
            cshape: Circle(),
            backgroundColor: .white,
            foregroundColor: .red
        )
        .background(.black, ignoresSafeAreaEdges: [])

        ClippedImageStateView(
            imageState: emptyState,
            emptyPlaceholder: "person.circle",
            cshape: RoundedRectangle(cornerRadius: 12),
            backgroundColor: .red,
            foregroundColor: .orange
        )

        ClippedImageStateView(
            imageState: failureState,
            errorPlaceholder: "exclamationmark.circle",
            cshape: Rectangle(),
            backgroundColor: .red,
            foregroundColor: .yellow
        )
        ClippedImageStateView(
            imageState: loadingState,
            cshape: Circle(),
            backgroundColor: .green,
            foregroundColor: .white
        )
        .background(.blue)

        ClippedImageStateView(
            imageState: successState,
            cshape: Circle(),
            backgroundColor: .red,
            foregroundColor: .yellow
        )
    }
#endif
