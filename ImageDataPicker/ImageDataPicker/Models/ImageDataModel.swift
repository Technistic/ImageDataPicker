//
//  ImageDataModel.swift
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

import CoreTransferable
import Foundation
import OSLog
import PhotosUI
import SwiftUI

/// The ``ImageDataModel`` is a model of the state of a (thumbnail) Image that can be selected and loaded using the SwiftUI PhotosPicker View. The ``ImageState`` represents whether the selected image is empty, in the process of being loaded, successfully loaded, or has failed to load.
///
//ToDo: Do we need @MainActor
//@MainActor
@Observable
public class ImageDataModel: Hashable {

    /// ImageDataModel equality function
    /// - Parameters:
    ///   - lhs: lhs ImageDataModel
    ///   - rhs: rhs ImageDataModel
    /// - Returns: Compares the two ImageDataModel objects
    public static func == (lhs: ImageDataModel, rhs: ImageDataModel) -> Bool {
        ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
    }

    /// ImageDataModel hash function
    /// - Parameter hasher: Hashes the essential components of this value by feeding them into the given hasher.
    public func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }

    // MARK: - ImageState
    /// The UI state of the (thumbnail) Image presented by the DataImagePickerView
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

    /// The current ``ImageState`` of the model.
    public var imageState: ImageState

    /// Initialize the ImageDataModel with an ImageState
    /// - Parameters:
    ///   - imageState: Initialize the model with the ImageState
    ///   - imageSelection: The PhotosPicker selected image
    public init(imageState: ImageState, imageSelection: PhotosPickerItem? = nil)
    {
        Logger.application.info("\(imageState.description())")
        self.imageState = imageState
        self.imageSelection = imageSelection
    }

    /// Initialize the ImageDataModel using imageData to set the ImageState.success
    /// - Parameters:
    ///   - imageData: Use imageData to initialize the model with ImageState.success
    ///   - imageSelection: The PhotosPicker selected image
    public init(
        imageData: Binding<Data?>,
        imageSelection: PhotosPickerItem? = nil
    ) {
        if imageData.wrappedValue == nil {
            self.imageState = ImageState.empty
        } else {
            self.imageState = ImageState.success(imageData.wrappedValue)
        }
        self.imageSelection = imageSelection
    }

    // TODO: Test this
    public init(imageData: Data?, imageSelection: PhotosPickerItem? = nil) {
        if imageData == nil {
            self.imageState = ImageState.empty
        } else {
            self.imageState = ImageState.success(imageData)
        }
    }

    /// An error that can be thrown when importing a photo.
    public enum TransferError: Error {
        case importFailed
    }

    /// Transfer the selected photo as Data
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

    /// The selected image from the PhotosPicker library.
    /// This initiates the loading of the image when set.
    public var imageSelection: PhotosPickerItem? = nil {
        didSet {
            if let imageSelection {
                let progress = loadTransferable(from: imageSelection)
                self.imageState = .loading(progress)
            } else {
                imageState = .empty
            }
        }
    }

    // MARK: - Private Methods
    private func loadTransferable(from imageSelection: PhotosPickerItem)
        -> Progress
    {
        return imageSelection.loadTransferable(type: DataImage.self) { result in
            DispatchQueue.main.async {
                guard imageSelection == self.imageSelection else {
                    // ToDo: Handle failure case
                    Logger.application.error("Failed to get the selected item.")
                    return
                }
                switch result {
                case .success(let image?):
                    self.imageState = .success(image.imageData)
                case .success(nil):
                    self.imageState = .empty
                case .failure(let error):
                    self.imageState = .failure(error)
                    Logger.application.error(
                        "Failed to load image: \(error.localizedDescription)."
                    )
                }
            }
        }
    }
}
