//
//  PrototypePreviews.swift
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

import OSLog
import SwiftData
import SwiftUI
import ImageDataPicker

/// The sole purpose of this file is to provide a convenient mechanism to experiment with a #Preview of the Views provided by the ``ImageDataPicker`` framework.
/// These Previews rely on Development Assets that are not budled with the EmployeeFormExample Application.
///
#Preview("Square Image View") {
    SquareImageView(imageState: ImageDataModel.ImageState.success(UIImage(named: "Anne_Lee")?.pngData()))
    
    ClippedImageStateView(imageState: ImageDataModel.ImageState.success(UIImage(named: "Anne_Lee")?.pngData()))
        .clippedImageShape(.round)
    
    ClippedImageStateView(imageState: ImageDataModel.ImageState.success(UIImage(named: "Anne_Lee")?.pngData()))
        .clippedImageShape(.square)
    
    ClippedImageStateView(imageState: ImageDataModel.ImageState.success(UIImage(named: "Anne_Lee")?.pngData()))
        .clippedImageShape(.roundedSquare)
    
    ClippedImageStateView(imageState: ImageDataModel.ImageState.empty)
        .clippedImageShape(.round)
        .padding(4)
        .background() {
            //Circle()
            //  .fill(Color.teal)
            RoundedRectangle(cornerRadius: 8).fill(Color.teal)
        }
        .foregroundColor(.white)
    
    ClippedImageStateView(imageState: ImageDataModel.ImageState.empty, emptyImage: "photo")
        .clippedImageShape(.round)
        .background() {
            Circle()
                .fill(Color.teal)
        }
    
    ClippedImageStateView(imageState: ImageDataModel.ImageState.empty)
        .clippedImageShape(.square)
        .padding(4)
        .background(.blue)
    
    ClippedImageStateView(imageState: ImageDataModel.ImageState.empty)
        .clippedImageShape(.roundedSquare)
        .background(.blue)
    
    ZStack {
        Circle().fill(Color.gray)
        ClippedImageStateView(imageState: ImageDataModel.ImageState.empty, emptyImage: "photo")
            .clippedImageShape(.round)
            .foregroundColor(.green)
            .background(.yellow)
    }
        //.padding(4)
        //.background(.blue)
        //.clipShape(RoundedRectangle(cornerRadius: 8))
        //.background(.blue)

    
    ClippedImageStateView(imageState: ImageDataModel.ImageState.empty, emptyImage: "photo")
        .clippedImageShape(.square)
        .background(.yellow)
    
    ClippedImageStateView(imageState: ImageDataModel.ImageState.empty, emptyImage: "photo")
        .clippedImageShape(.roundedSquare)
        .background(.yellow)
    
}
