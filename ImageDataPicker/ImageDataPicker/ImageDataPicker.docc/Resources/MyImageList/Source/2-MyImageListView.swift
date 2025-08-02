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
            }
            .navigationTitle("My Images")
            .environment(\.defaultMinListRowHeight, 100)
        } detail: {
            if selectedImageID == nil {
                Text("Please select an image.")
            } else {
                var anImage: MyImage? {
                    modelContext.registeredModel(
                        for: selectedImageID!
                    )}
                Text(anImage?.imageName ?? "Unknown Image")
            }
        }
    }
}

#Preview {
    MyImageListView()
}
