//
//  MyImageListView.swift
//  MyImageList
//
//  Copyright © 2025 Technistic Pty Ltd. All rights reserved.
//

import ImageDataPicker
import SwiftData
import SwiftUI


// We use a NavigationSplitView to create a multi-platform compatible view
// that allows us to navigate from a list of MyImage objects to a detail view
// of each selected image.
// We make use of editMode to allow users to delete images from the list on iOS.

struct MyImageListView: View {
    // We make use of editMode to allow users to delete images from the list on iOS.
    #if os(iOS)
        @Environment(\.editMode) private var editMode
    #endif

    @Environment(\.modelContext) private var modelContext
    @Query private var myImages: [MyImage]

    @State private var selectedImageID: MyImage.ID? = nil
    @State private var columnVisibility = NavigationSplitViewVisibility
        .doubleColumn

    var body: some View {
        NavigationSplitView(columnVisibility: $columnVisibility) {
            List(selection: $selectedImageID) {
                ForEach(myImages) { myImage in
                    myImage.photo
                }
                .onDelete(perform: deleteMyImages)
            }
            .navigationTitle("My Images")
            .environment(\.defaultMinListRowHeight, 100)

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
            if selectedImageID == nil {
                Text("Please select an image.")
            } else {
                var anImage: MyImage? {
                    modelContext.registeredModel(
                        for: selectedImageID!
                    )
                }
                Text(anImage?.imageName ?? "Unknown Image")
            }
        }
    }

    private func addImage() {
        withAnimation {
            let newImage = MyImage(
                imageName: "New Image"
            )
            modelContext.insert(newImage)
            selectedImageID = newImage.persistentModelID
        }
    }

    /// Delete the selected Employee.
    /// - Parameter offsets: The index(es) of the rows to delete.
    private func deleteMyImages(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                let deletedImage = myImages[index]
                if deletedImage.persistentModelID == selectedImageID {
                    selectedImageID = nil
                }
                modelContext.delete(deletedImage)
                do {
                    try modelContext.save()
                } catch {
                    // Handle error, e.g., show an alert
                }
            }
        }
    }
}

#Preview {
    MyImageListView()
        .modelContainer(for: MyImage.self)
}
