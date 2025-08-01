//
//  MyImageView.swift
//  MyImageList
//
//  Copyright © 2025 Technistic Pty Ltd. All rights reserved.
//


import SwiftData
import SwiftUI

struct MyImageView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    @Binding public var selectedImageID: MyImage.ID?
    @State var myImage: MyImage?
    
    var body: some View {
        VStack {
            myImage?.photo
                .resizable()
                .scaledToFit()
        }
        .onAppear {
            if let selectedImageID {
                myImage = modelContext.registeredModel(for: selectedImageID)
            }
        }
    }
}

#Preview {
    @Previewable @State var selectedImageID: MyImage.ID? = nil
    
    MyImageView(selectedImageID: $selectedImageID)
}
