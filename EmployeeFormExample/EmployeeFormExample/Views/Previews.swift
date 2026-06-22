//
//  Previews.swift
//  EmployeeFormExample
//
//  Part of the EmployeeFormExample application supplied with the
//  ImageDataPicker Framework.
//
//  Created by Michael Logothetis on 30/04/2025.
//
//  MIT License
//  Copyright (c) 2025 Michael Logothetis (Technistic Pty Ltd)
//

import Foundation
import ImageDataPicker
import OSLog
import PhotosUI
import SwiftData
import SwiftUI

/// The sole purpose of this file is to provide a convenient mechanism to #Preview the Views provided by the ``ImageDataPicker`` framework.
/// These Previews rely on Development Assets that are not bundled with the ``EmployeeFormExample`` application.
///
#Preview("Sample Image") {
    Text("Sample Image").font(.title)
    Text("Test scale 1:1 clipped Image").font(.title2)
    GeometryReader { geometry in
        Image("Boy_Rectangle")
            .resizable()
            .scaledToFill()
            .frame(
                width: min(geometry.size.width, geometry.size.height),
                height: min(geometry.size.width, geometry.size.height)
            )  // Make it square
            .clipShape(Circle())  // Clip to a circle
            .clipped()  // Ensure content outside the frame is clipped
    }
}

#Preview("ImageDataView-nil-default") {
    @Previewable @State var imageData: Data? = nil

    Text("ImageDataView").font(.title)
    Text("Test imageData=nil").font(.title2)
    Text("with default placeholder").font(.title2)
    ImageDataView(imageData: imageData)
}

#Preview("ImageDataView-sample") {
    @Previewable @State var imageData: Data? = UIImage(named: "Boy_Rectangle")!
        .pngData()

    Text("ImageDataView").font(.title)
    Text("Test sample Image").font(.title2)
    ImageDataView(imageData: imageData)
}

#Preview("ImageDataView-nil-photo") {
    @Previewable @State var imageData: Data? = nil

    Text("ImageDataView").font(.title)
    Text("Test imageData=nil").font(.title2)
    Text("with custom placeholder").font(.title2)
    ImageDataView(
        imageData: imageData,
        placeholder: "photo.fill"
    )
}

#Preview("ImageStateView-empty-default") {
    @Previewable @State var imageStateEmpty: ImageDataModel.ImageState =
        ImageDataModel.ImageState.empty

    Text("ImageStateView").font(.title)
    Text("Test ImageState.empty").font(.title2)
    Text("with default placeholder").font(.title2)
    ImageStateView(
        imageState: imageStateEmpty
    )
}

#Preview("ImageStateView-loading") {
    @Previewable @State var imageStateProgress = ImageDataModel.ImageState
        .loading(Progress(totalUnitCount: 100))

    Text("ImageStateView").font(.title)
    Text("Test ImageState.loading").font(.title2)
    ImageStateView(
        imageState: imageStateProgress
    )
}

#Preview("ImageStateView-empty_sample-default") {
    @Previewable @State var imageStateSuccessBoy: ImageDataModel.ImageState =
        ImageDataModel.ImageState.success(nil)

    Text("ImageStateView").font(.title)
    Text("Test empty sample Image").font(.title2)
    Text("with default placeholder").font(.title2)
    ImageStateView(
        imageState: imageStateSuccessBoy
    )
}

#Preview("ImageStateView-sample") {
    @Previewable @State var imageStateSuccessBoy: ImageDataModel.ImageState =
        ImageDataModel.ImageState.success(
            UIImage(named: "Boy_Rectangle")?.pngData()
        )

    Text("ImageStateView").font(.title)
    Text("Test sample Image").font(.title2)
    ImageStateView(
        imageState: imageStateSuccessBoy
    )
}

#Preview("ImageStateView-failure-default") {
    @Previewable @State var imageStateFailure = ImageDataModel.ImageState
        .failure(ImageDataModel.TransferError.importFailed)

    Text("ImageStateView").font(.title)
    Text("Test ImageState.failure").font(.title2)
    Text("with default placeholder").font(.title2)
    ImageStateView(
        imageState: imageStateFailure
    )
}

#Preview("ImageStateView-empty-photo") {
    @Previewable @State var imageStateEmpty: ImageDataModel.ImageState =
        ImageDataModel.ImageState.empty

    Text("ImageStateView").font(.title)
    Text("Test ImageState.empty").font(.title2)
    Text("with custom placeholder").font(.title2)
    ImageStateView(
        imageState: imageStateEmpty,
        emptyPlaceholder: "photo.circle.fill",
        errorPlaceholder: "exclamationmark.triangle.fill"
    )
}

#Preview("ImageStateView-empty_sample-photo") {
    @Previewable @State var imageStateSuccessBoy: ImageDataModel.ImageState =
    ImageDataModel.ImageState.success(nil)
    
    Text("ImageStateView").font(.title)
    Text("Test empty sample Image").font(.title2)
    Text("with custom placeholder").font(.title2)
    ImageStateView(
        imageState: imageStateSuccessBoy,
        emptyPlaceholder: "photo.circle.fill",
        errorPlaceholder: "exclamationmark.triangle.fill")
}

#Preview("ImageStateView-failure-triangle") {
    @Previewable @State var imageStateFailure = ImageDataModel.ImageState
        .failure(ImageDataModel.TransferError.importFailed)

    Text("ImageStateView").font(.title)
    Text("Test ImageState.failure").font(.title2)
    Text("with custom placeholder").font(.title2)
    ImageStateView(
        imageState: imageStateFailure,
        emptyPlaceholder: "photo.circle.fill",
        errorPlaceholder: "exclamationmark.triangle.fill"
    )
}

#Preview("ImagePickerView-nil-default") {
    @Previewable @State var imageData: Data? = nil
    Text("ImagePickerView").font(.title)
    Text("Test imageData=nil").font(.title2)
    Text("with default placeholder").font(.title2)
    ImageDataPickerView(
        imageData: $imageData,
        emptyPlaceholderImageName: "person.circle.fill",
        clipShape: Circle()
    )
    .frame(width: 200, height: 200)
}

#Preview("ImagePickerView-Woman") {
    @Previewable @State var imageData = UIImage(named: "Woman_Rectangle")!
        .pngData()
    Text("ImagePickerView").font(.title)
    Text("Test imageData=Woman").font(.title2)
    Text("clipShape: RoundedRectangle(cornerRadius: 8)")
    ImageDataPickerView(
        imageData: $imageData,
        clipShape: RoundedRectangle(cornerRadius: 8)
    )
    .frame(width: 200, height: 200)
}

#Preview("ImagePickerView-Man") {
    @Previewable @State var imageData = UIImage(named: "Man_Rectangle")!
        .pngData()
    Text("ImagePickerView").font(.title)
    Text("Test imageData=Man").font(.title2)
    Text("clipShape: Rectangle()")
    ImageDataPickerView(
        imageData: $imageData,
        clipShape: Rectangle()
    )
    .frame(width: 200, height: 200)
}

#Preview("ImagePickerView-Girl") {
    @Previewable @State var imageData = UIImage(named: "Girl_Rectangle")!
        .pngData()
    Text("ImagePickerView").font(.title)
    Text("Test imageData=Girl").font(.title2)
    Text("clipShape: RoundedRectangle(cornerRadius: 8)")
    ImageDataPickerView(
        imageData: $imageData,
        clipShape: RoundedRectangle(cornerRadius: 8)
    )
}

#Preview("ImagePickerView-nil-photo") {
    @Previewable @State var imageData: Data? = nil
    Text("ImagePickerView").font(.title)
    Text("Test imageData=nil").font(.title2)
    Text("with custom placeholder").font(.title2)
    ImageDataPickerView(
        imageData: $imageData,
        emptyPlaceholderImageName: "photo.circle.fill",
        errorPlaceholderImageName: "exclamationmark.triangle.fill",
        clipShape: Circle()
    )
    .frame(width: 200, height: 200)
}

//TODO: Add a #Preview of the .failure state
/*
#Preview("Picker-Failure") {
    @Previewable @State var imageData = UIImage(named: "Non-ExistingImage.png")?.pngData()
    Text("Non-Existing").font(.title)
    ImageDataPickerView(
        imageData: $imageData,
        emptyPlaceholderImageName: "photo.circle.fill",
    )
    .frame(width: 200,  height: 200)
}

#Preview("Failure-Circle") {
    @Previewable @State var imageStateFailure = ImageDataModel.ImageState.failure(ImageDataModel.TransferError.importFailed)
    Text("Failed to load image").font(.title)
    ClippedImageStateView(imageState: imageStateFailure)
}

#Preview("Failure-Rectangle") {
    @Previewable @State var imageStateFailure = ImageDataModel.ImageState.failure(ImageDataModel.TransferError.importFailed)
    Text("Failed to load image").font(.title)
    ClippedImageStateView(
        imageState: imageStateFailure
    ).foregroundColor(.red)
}
*/

//TODO: Add a #Preview of the .loading state
/*
#Preview("Progress") {
    @Previewable @State var imageStateProgress = ImageDataModel.ImageState.loading(Progress(totalUnitCount: 100))
    Text("Loading").font(.title)
    ImageStateView(imageState: imageStateProgress)
        .foregroundColor(.blue)
}
*/
