//  ImageDataPickerView.swift
//  A SwiftUI image picker view that supports SwiftData-friendly image storage.
//
//  Derived from Sample Code - "Bringing Photos picker to your SwiftUI app"
//  by Apple Inc. © 2022
//
//  See original License in License/License-Apple-Sample-Code
//
//  Created by Michael Logothetis on 30/04/2025.
//  Updated by Michael Logothetis on 02/04/2026.
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

// The relative position of the edit and delete buttons from the bottom corners of the image.
public let buttonPosition: Double = Constants.buttonPosition

/// A SwiftUI view that lets the user select, preview, replace, and remove a photo.
///
/// `ImageDataPickerView` binds directly to `Data?`, making it convenient to use with
/// `@State` or SwiftData model properties. The view displays a square thumbnail clipped
/// to a supplied shape and overlays controls for replacing or removing the current image.
///
/// When `imageData` is `nil`, the view displays a configurable placeholder symbol.
/// While a new image is loading, it shows a progress view. If loading fails, it displays
/// a configurable error symbol.
public struct ImageDataPickerView<S: Shape>: View {
    @Binding var imageData: Data?
    private var emptyPlaceholderImageName: String = Constants.personPlaceholder
    private var errorPlaceholderImageName: String = Constants.errorPlaceholder
    private var clipShape: S

    #if canImport(AppKit)
        private var backgroundColor: NSColor = NSColor.windowBackgroundColor
        private var foregroundColor: NSColor = NSColor.labelColor
    #else
        private var backgroundColor: Color = Color(uiColor: .systemBackground)
        private var foregroundColor: Color = Color(uiColor: .label)
    #endif

    @State var viewModel: ImageDataModel = ImageDataModel(imageState: .empty)
    @State private var imageSize: CGSize = .zero

    /// - Parameters:
    ///   - imageData: A binding to the image data displayed by the view.
    ///   - emptyPlaceholderImageName: The SF Symbol to display when no image is available.
    ///   - errorPlaceholderImageName: The SF Symbol to display when loading fails.
    ///   - clipShape: The shape used to clip the square image.
    ///   - backgroundColor: The background color behind the clipped image.
    ///   - foregroundColor: The tint color used for placeholder and loading content.
    #if canImport(AppKit)
        public init(
            imageData: Binding<Data?>,
            emptyPlaceholderImageName: String = Constants.personPlaceholder,
            errorPlaceholderImageName: String = Constants.errorPlaceholder,
            clipShape: S,
            backgroundColor: NSColor = NSColor.windowBackgroundColor,
            foregroundColor: NSColor = NSColor.labelColor
        ) {
            self._imageData = imageData
            self.emptyPlaceholderImageName = emptyPlaceholderImageName
            self.errorPlaceholderImageName = errorPlaceholderImageName
            self.clipShape = clipShape
            self.backgroundColor = backgroundColor
            self.foregroundColor = foregroundColor
        }
    #else
        /// Initializer for the ImageDataPickerView().
        /// - Parameters:
        ///   - imageData: A binding to the image data that will be displayed in the view. This should be a `Data?` type, which can be `nil`
        ///   if no image is selected.
        ///   - emptyPlaceholderImageName: A String specifying the system image name to be displayed when the image state is empty. The default is  ``Constants/personPlaceholder`` image.
        ///   - errorPlaceholderImageName: A String specifying the system image name to be displayed when there is an error. The default is
        ///   ``Constants/errorPlaceholder`` image.
        ///   - clipShape: The clipping shape to apply to the image. This can be any SwiftUI Shape, such as Circle(), Rectangle() or RoundedRectangle(cornerRadius:).
        ///   - backgroundColor: The background color to apply to the image. The default is the system background color.
        ///   - foregroundColor: The foreground color to apply to the image. The default is the system label color.
        public init(
            imageData: Binding<Data?>,
            emptyPlaceholderImageName: String = Constants.personPlaceholder,
            errorPlaceholderImageName: String = Constants.errorPlaceholder,
            clipShape: S,
            backgroundColor: Color = Color(.systemBackground),
            foregroundColor: Color = Color(.label)
        ) {
            self._imageData = imageData
            self.emptyPlaceholderImageName = emptyPlaceholderImageName
            self.errorPlaceholderImageName = errorPlaceholderImageName
            self.clipShape = clipShape
            self.backgroundColor = backgroundColor
            self.foregroundColor = foregroundColor
        }
    #endif

    public var body: some View {
        ClippedImageStateView(
            imageState: viewModel.imageState,
            emptyPlaceholder: emptyPlaceholderImageName,
            errorPlaceholder: errorPlaceholderImageName,
            clipShape: clipShape,
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

/// A square image container that styles `ImageStateView` for a specific shape and color scheme.
public struct ClippedImageStateView<S: Shape>: View {
    public var imageState: ImageDataModel.ImageState = .empty
    private var emptyPlaceholder: String = Constants.personPlaceholder
    private var errorPlaceholder: String = Constants.errorPlaceholder

    let clipShape: S

    #if canImport(AppKit)
        private var backgroundColor: Color = Color(
            nsColor: NSColor.windowBackgroundColor
        )
        private var foregroundColor: Color = Color(nsColor: NSColor.labelColor)
    #else
        private var backgroundColor: Color = Color(.systemBackground)
        private var foregroundColor: Color = Color(.label)
    #endif

    /// - Parameters:
    ///   - imageState: The image state to display.
    ///   - emptyPlaceholder: The SF Symbol to use when the state is `.empty`.
    ///   - errorPlaceholder: The SF Symbol to use when the state is `.failure`.
    ///   - clipShape: The shape used to clip the square image.
    ///   - backgroundColor: The background color behind the clipped image.
    ///   - foregroundColor: The tint color used for placeholder, loading, and error content.
    #if canImport(AppKit)
        public init(
            imageState: ImageDataModel.ImageState = ImageDataModel.ImageState
                .empty,
            emptyPlaceholder: String = Constants.personPlaceholder,
            errorPlaceholder: String = Constants.errorPlaceholder,
            clipShape: S,
            backgroundColor: NSColor = NSColor.windowBackgroundColor,
            foregroundColor: NSColor = NSColor.labelColor
        ) {
            self.imageState = imageState
            self.emptyPlaceholder = emptyPlaceholder
            self.errorPlaceholder = errorPlaceholder
            self.clipShape = clipShape
            self.backgroundColor = Color(nsColor: backgroundColor)
            self.foregroundColor = Color(nsColor: foregroundColor)
        }
    #else
        public init(
            imageState: ImageDataModel.ImageState = ImageDataModel.ImageState
                .empty,
            emptyPlaceholder: String = Constants.personPlaceholder,
            errorPlaceholder: String = Constants.errorPlaceholder,
            clipShape: S,
            backgroundColor: Color = Color(.systemBackground),
            foregroundColor: Color = Color(.label)
        ) {
            self.imageState = imageState
            self.emptyPlaceholder = emptyPlaceholder
            self.errorPlaceholder = errorPlaceholder
            self.clipShape = clipShape
            self.backgroundColor = backgroundColor
            self.foregroundColor = foregroundColor
        }
    #endif

    public var body: some View {
        switch imageState {
        case .success:
            ImageStateView(imageState: imageState)
                .modifier(
                    SquareImageViewModifier(
                        shape: clipShape,
                        background: backgroundColor
                    )
                )
                .clipped()
        case .loading:
            ImageStateView(imageState: imageState)
                .tint(foregroundColor)
                .modifier(
                    SquareImageViewModifier(
                        shape: clipShape,
                        background: backgroundColor
                    )
                )
        case .failure:
            ImageStateView(
                imageState: imageState,
                emptyPlaceholder: emptyPlaceholder,
                errorPlaceholder: errorPlaceholder
            )
            .foregroundColor(foregroundColor)
            //.scaleEffect(
            //    SymbolLayoutHelper.scaleFactor(systemImage: errorPlaceholder)
            //)
            .offset(
                x: 0,
                y: SymbolLayoutHelper.offsetFactor(
                    systemImage: errorPlaceholder
                )
            )
            .modifier(
                SquareImageViewModifier(
                    shape: clipShape,
                    background: backgroundColor
                )
            )
        case .empty:
            ImageStateView(
                imageState: imageState,
                emptyPlaceholder: emptyPlaceholder,
                errorPlaceholder: errorPlaceholder
            )
            .foregroundColor(foregroundColor)
            //.scaleEffect(SymbolLayoutHelper.scaleFactor(systemImage: emptyPlaceholder))
            //.offset(x: 0, y: SymbolLayoutHelper.offsetFactor(systemImage: emptyPlaceholder))
            .modifier(
                SquareImageViewModifier(
                    shape: clipShape,
                    background: backgroundColor
                )
            )
        }
    }
}

#Preview("ImageDataPickerView") {
    @Previewable @State var nilImageData: Data? = nil
    @Previewable @State var successImageData: Data? = imageResourceData(
        for: "TestImage"
    )

    VStack {
        ImageDataPickerView(
            imageData: $nilImageData,
            clipShape: Circle(),
            backgroundColor: .blue,
            foregroundColor: .white
        )
        .background(.blue.opacity(0.3), ignoresSafeAreaEdges: [])

        ImageDataPickerView(
            imageData: $nilImageData,
            clipShape: RoundedRectangle(cornerRadius: 24),
            backgroundColor: .yellow,
            foregroundColor: .red
        )

        ImageDataPickerView(
            imageData: $nilImageData,
            clipShape: Rectangle(),
            backgroundColor: .orange,
            foregroundColor: .purple
        )

        ImageDataPickerView(
            imageData:
                $successImageData,
            emptyPlaceholderImageName: Constants.photoPlaceholder,
            clipShape: Circle(),
            backgroundColor: .blue,
            foregroundColor: .white
        )
        .background(.gray.opacity(0.6))

        ImageDataPickerView(
            imageData: $successImageData,
            emptyPlaceholderImageName: Constants.photoPlaceholder,
            clipShape: Rectangle(),
            backgroundColor: .yellow,
            foregroundColor: .red
        )
    }
}

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
        .success(imageResourceData(for: "TestImage"))

    ClippedImageStateView(
        imageState: emptyState,
        emptyPlaceholder: "person.circle",
        clipShape: Circle(),
        backgroundColor: .white,
        foregroundColor: .blue
    )
    .background(.blue.opacity(0.3), ignoresSafeAreaEdges: [])

    ClippedImageStateView(
        imageState: emptyState,
        emptyPlaceholder: "person.circle",
        clipShape: RoundedRectangle(cornerRadius: 12),
        backgroundColor: .cyan,
        foregroundColor: .red
    )

    ClippedImageStateView(
        imageState: failureState,
        errorPlaceholder: "exclamationmark.triangle",
        //clipShape: Rectangle(),
        clipShape: Circle(),
        backgroundColor: .red,
        foregroundColor: .yellow
    )
    ClippedImageStateView(
        imageState: loadingState,
        clipShape: Circle(),
        backgroundColor: .green,
        foregroundColor: .white
    )
    .background(.blue)

    ClippedImageStateView(
        imageState: successState,
        clipShape: Circle(),
        backgroundColor: .red,
        foregroundColor: .yellow
    )
    .background(.gray, ignoresSafeAreaEdges: [])
}
