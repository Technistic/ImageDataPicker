//
//  ImageDataModel.swift
//  A SwiftUI image picker model that supports SwiftData-friendly image storage.
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

import CoreTransferable
import Foundation
import OSLog
import PhotosUI
import SwiftUI

/// A main-actor-isolated model that tracks the UI state of an image selected with `PhotosPicker`.
///
/// `ImageDataModel` is designed for SwiftUI views that bind image content as `Data?`.
/// It represents whether the image is empty, loading, loaded successfully, or failed to load.
///
@MainActor
@Observable
public final class ImageDataModel: Hashable {

    /// Returns `true` when both references point to the same model instance.
    /// - Parameters:
    ///   - lhs: lhs ImageDataModel
    ///   - rhs: rhs ImageDataModel
    /// - Returns: Compares the two ImageDataModel objects
    public nonisolated static func == (lhs: ImageDataModel, rhs: ImageDataModel)
        -> Bool
    {
        ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
    }

    /// Hashes the model by identity.
    /// - Parameter hasher: The hasher to update.
    public nonisolated func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }

    // MARK: - ImageState
    /// The UI state of the image presented by `ImageDataPickerView`.
    public enum ImageState {
        /// An empty image state, indicating no image has been selected or loaded.
        case empty
        /// A loading state with a `Progress` indicating the image is being loaded.
        /// - Progress: The progress of the image loading operation.
        case loading(Progress)
        /// A successful image state with the loaded image data.
        /// - Data?: The successfully loaded image data.
        case success(Data?)
        /// A failure state with an error indicating the image loading operation failed.
        /// - Error: The error that occurred during the image loading operation.
        case failure(Error)

        func description() -> String {
            switch self {
            case .empty:
                return "empty"
            case .loading(_):
                return "loading"
            case .success:
                return "success"
            case .failure(_):
                return "failure"
            }
        }
    }

    /// The current state of the image.
    public var imageState: ImageState

    private var imageLoadTask: Task<Void, Never>?

    /// Creates a model with an explicit state.
    /// - Parameters:
    ///   - imageState: The initial image state.
    ///   - imageSelection: The current `PhotosPicker` selection, if any.
    public init(imageState: ImageState, imageSelection: PhotosPickerItem? = nil)
    {
        Logger.application.info("\(imageState.description())")
        self.imageState = imageState
        self.imageSelection = imageSelection
    }

    /// Creates a model from a `Binding<Data?>`.
    /// - Parameters:
    ///   - imageData: The bound image data used to determine the initial state.
    ///   - imageSelection: The current `PhotosPicker` selection, if any.
    public init(
        imageData: Binding<Data?>,
        imageSelection: PhotosPickerItem? = nil
    ) {
        self.imageSelection = imageSelection

        if imageData.wrappedValue == nil {
            self.imageState = ImageState.empty
        } else {
            self.imageState = ImageState.success(imageData.wrappedValue)
        }
    }

    /// Creates a model from image data.
    /// - Parameters:
    ///   - imageData: The image data used to determine the initial state.
    ///   - imageSelection: The current `PhotosPicker` selection, if any.
    public init(imageData: Data?, imageSelection: PhotosPickerItem? = nil) {
        self.imageSelection = imageSelection

        if imageData == nil {
            self.imageState = ImageState.empty
        } else {
            self.imageState = ImageState.success(imageData)
        }
    }

    /// Errors that can occur while importing a selected photo.
    public enum TransferError: Error {
        case importFailed
    }

    /// A transferable wrapper used to import selected photo data.
    public struct DataImage: Transferable {
        let imageData: Data?

        init?(imageData: Data?) {
            guard imageData != nil else {
                return nil
            }
            self.imageData = imageData
        }

        public static var transferRepresentation: some TransferRepresentation {
            DataRepresentation(importedContentType: .data) { data in
                #if canImport(AppKit)
                    //guard let nsImage = NSImage(data: data) else {
                    //    throw TransferError.importFailed
                    //}
                    //let image = Image(nsImage: nsImage)
                    return
                        ((DataImage(imageData: data)
                        ?? DataImage(imageData: nil))!)
                #elseif canImport(UIKit)
                    //guard let uiImage = UIImage(data: data) else {
                    //    throw TransferError.importFailed
                    //}
                    //let image = Image(uiImage: uiImage)
                    guard let dataImage = DataImage(imageData: data) else {
                        throw TransferError.importFailed
                    }
                    //return DataImage(imageData: data)
                    return dataImage
                #else
                    throw TransferError.importFailed
                #endif
            }
        }
    }

    /// The selected item from `PhotosPicker`.
    ///
    /// Setting this property cancels any in-flight load and starts loading the new selection.
    public var imageSelection: PhotosPickerItem? = nil {
        didSet {
            imageLoadTask?.cancel()
            imageLoadTask = nil

            guard let imageSelection else {
                imageState = .empty
                return
            }

            beginLoadingImage(from: imageSelection)
        }
    }

    // MARK: - Private Methods
    private func beginLoadingImage(from imageSelection: PhotosPickerItem) {
        // PhotosPicker's async API does not currently expose progress here, so we use
        // an indeterminate placeholder progress value while the transfer runs.
        imageState = .loading(Progress(totalUnitCount: 1))
        imageLoadTask = Task { [weak self, imageSelection] in
            await self?.loadTransferable(from: imageSelection)
        }
    }

    private func loadTransferable(from imageSelection: PhotosPickerItem) async {
        do {
            let image = try await imageSelection.loadTransferable(
                type: DataImage.self
            )

            guard !Task.isCancelled else {
                return
            }

            guard imageSelection == self.imageSelection else {
                Logger.application.error("Failed to get the selected item.")
                return
            }

            if let image {
                self.imageState = .success(image.imageData)
            } else {
                self.imageState = .empty
            }
        } catch is CancellationError {
            Logger.application.debug("Cancelled image load request.")
        } catch {
            guard !Task.isCancelled else {
                return
            }

            self.imageState = .failure(error)
            Logger.application.error(
                "Failed to load image: \(error.localizedDescription)."
            )
        }
    }
}
