//
//  ContentView.swift
//  MyImageList
//
//  Copyright © 2025 Technistic Pty Ltd. All rights reserved.
//

import SwiftUI
import SwiftData


struct ContentView: View {

    var body: some View {
        MyImageListView()
    }
}

#Preview {
    ContentView()
        .modelContainer(for: MyImage.self, inMemory: true)
}
