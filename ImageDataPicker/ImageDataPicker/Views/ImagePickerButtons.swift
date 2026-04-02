//
//  ImagePickerButtons.swift
//  Overlay controls used by ImageDataPickerView.
//
//  Created by Michael Logothetis on 30/04/2025.
//  Updated by Michael Logothetis on 02/04/2026.
//
//  MIT License
//  Copyright (c) 2025 Michael Logothetis (Technistic Pty Ltd)
//

import OSLog
import SwiftUI

/// An EditButton used as an overlay over a thumbnail image.
/// 
struct ImagePickerEditButton: View {
    var body: some View {
        VStack {
            Circle()
                .fill(Color.blue)
                //.scaleEffect(1.0)
                .overlay(
                    Image(systemName: "pencil")
                        .resizable()
                        .fontWeight(.heavy)
                        .aspectRatio(contentMode: .fill)
                        .scaleEffect(0.5)
                        .foregroundColor(.white)
                )
        }
        //.frame(width: 440, height: 440)
    }
}

/// A DeleteButton used as an overlay over a thumbnail image.
/// 
struct ImagePickerDeleteButton: View {
    var body: some View {
        VStack {
            Circle()
                .fill(Color.white)
                //.fill(Color.red)
                .scaleEffect(0.8)
                .overlay(
                    Image(systemName: "minus.circle.fill")
                        .resizable()
                        .fontWeight(.heavy)
                        //.background(.background.opacity(0.0))
                        .aspectRatio(contentMode: .fill)
                        .scaleEffect(1.0)
                        .foregroundColor(Color.red)
                )
        }
    }
}

/// A Star used as an overlay over a thumbnail image.
/// 
struct ImagePickerStar: View {
    var color = Color.yellow

    var body: some View {
        Image(systemName: "star.fill")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .background(.background.opacity(0.0))
            .foregroundStyle(color)
    }
}

#Preview("ImagePickerButtons") {
    VStack {
        ImagePickerEditButton()
            .frame(width: 50, height: 50)
        ImagePickerDeleteButton()
            .frame(width: 50, height: 50)
        ImagePickerStar()
            .frame(width: 50, height: 50)
    }
    .background(.teal)
}
