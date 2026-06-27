//
//  MyImageListView.swift
//  MyImageList
//
//  Copyright © 2025 Technistic Pty Ltd.
//  Refer to LICENSE file for licensing terms.
//

import SwiftData
import SwiftUI

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
#if os(macOS)
            .navigationSplitViewColumnWidth(min: 180, ideal: 200)
#endif
        } detail: {
            if let selectedImageID = selectedImageID {
                let myImage: MyImage? = modelContext.registeredModel(for: selectedImageID)
                myImage!.photo
            } else {
                Text("Please select an image.")
            }
        }
    }
}

#Preview {
    MyImageListView()
}
