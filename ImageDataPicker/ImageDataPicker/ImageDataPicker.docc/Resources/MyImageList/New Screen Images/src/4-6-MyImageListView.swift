//
//  MyImageListView.swift
//  MyImageList
//
//  Copyright © 2025 Technistic Pty Ltd.
//  Refer to LICENSE file for licensing terms.
//

import ImageDataPicker
import SwiftData
import SwiftUI

struct MyImageListView: View {
    @Environment(\.dismiss) private var dismiss
    
    @Environment(\.modelContext) private var modelContext
    @Query private var myImages: [MyImage]
    
    @State private var selectedImageID: MyImage.ID? = nil
    @State private var columnVisibility = NavigationSplitViewVisibility
        .doubleColumn
    
    var body: some View {
        NavigationSplitView(columnVisibility: $columnVisibility) {
            List(selection: $selectedImageID) {
                ForEach(myImages) { myImage in
                    MyImageListRow(myImage: myImage)
                }
                .onDelete(perform: deleteMyImages)
            }
            .navigationTitle("My Images")
            .environment(\.defaultMinListRowHeight, 100)
#if os(macOS)
            .navigationSplitViewColumnWidth(min: 180, ideal: 200)
#endif
            .toolbar {
#if os(iOS)
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
#endif
                ToolbarItem {
                    Button(action: addImage) {
                        Label("Add Image", systemImage: "plus")
                    }
                }
            }
        } detail: {
            if let selectedImageID = selectedImageID {
                let myImage: MyImage? = modelContext.registeredModel(for: selectedImageID)
                myImage!.photo
            } else {
                Text("Please select an image.")
            }
        }
    }
    
    /// Add a new Image.
    /// Initially imageData defaults to nil.
    private func addImage() {
        withAnimation {
            let newImage = MyImage(
                imageName: "New Image"
            )
            modelContext.insert(newImage)
            selectedImageID = newImage.persistentModelID
        }
    }

    /// Delete the selected Image.
    /// - Parameter offsets: The index(es) of the rows to delete.
    private func deleteMyImages(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                let deletedImage = myImages[index]
                if deletedImage.persistentModelID == selectedImageID {
                    selectedImageID = nil
                }
                modelContext.delete(deletedImage)
                if modelContext.hasChanges {
                    do {
                        try modelContext.save()
                    }
                    catch {
                        print("Error: \(error)")
                    }
                }
            }
        }
    }
}

// MyImageListRow
struct MyImageListRow: View {
    var myImage: MyImage?

    var body: some View {
        @State var img: Data? = myImage?.imageData
        @State var state: ImageDataModel = ImageDataModel(imageData: img)
            
        HStack {
            ClippedImageStateView(imageState: state.imageState)
                .clippedImageShape(.round)
            Text(myImage!.imageName)
        }
        .padding(4)
    }
}

#Preview {
    MyImageListView()
        .modelContainer(for: MyImage.self)
}
