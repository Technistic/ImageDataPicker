//
//  MyImageView.swift
//  MyImageList
//
//  Copyright © 2025 Technistic Pty Ltd.
//  Refer to LICENSE file for licensing terms.
//

import ImageDataPicker
import SwiftData
import SwiftUI

struct MyImageView: View {
    @Environment(\.modelContext) private var modelContext

    @Binding public var selectedImageID: MyImage.ID?
    @State private var myImage: MyImage?

    @State private var imageName: String = ""
    @State private var imageData: Data? = nil

    var body: some View {
        HStack {
            Spacer()
            
            VStack {
                Section(header: Text("Selected Image")) {
                    VStack {
                        ImageDataPickerView(imageData: $imageData)
                            .frame(width: 120, height: 120)
                        
                        TextField("Enter Image Name", text: $imageName)
                            .textFieldStyle(.roundedBorder)
                            .multilineTextAlignment(.center)
                    }
                    .padding(20)
                    .background(.blue.opacity(0.6))
                    .cornerRadius(12)
                    
                    HStack {
                        Button(role: .cancel) {
                            cancelChanges()
                        } label: {
                            Text("Cancel")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.bordered)

                        Button {
                            saveImage()
                        } label: {
                            Text("Save")
                                .frame(maxWidth: .infinity)
                        }
                        .disabled(!hasChanges)
                        .buttonStyle(.bordered)
                    }
                }
                .padding(12)
                
                Spacer()
            }
            
            Spacer()
        }
        .frame(width: 360)
        .onAppear {
            loadSelectedImage()
        }
    }

    private var hasChanges: Bool {
        guard let myImage = myImage else { return false }
        return imageName != myImage.imageName || imageData != myImage.imageData
    }

    private func loadSelectedImage() {
        guard let selectedImageID = selectedImageID else { return }
        
        myImage = modelContext.registeredModel(for: selectedImageID)
        
        if let myImage = myImage {
            imageName = myImage.imageName
            imageData = myImage.imageData
        }
    }

    private func cancelChanges() {
        guard let myImage = myImage else { return }
        
        imageName = myImage.imageName
        imageData = myImage.imageData
        modelContext.rollback()
        selectedImageID = nil
    }

    private func saveImage() {
        guard let myImage = myImage else { return }
        
        myImage.imageName = imageName
        myImage.imageData = imageData
        
        do {
            try modelContext.save()
        } catch {
            print("Error: \(error.localizedDescription)")
        }
        
        selectedImageID = nil
    }
}

#Preview {
    @Previewable @State var selectedImageID: MyImage.ID? = nil
    MyImageView(selectedImageID: $selectedImageID)
}
