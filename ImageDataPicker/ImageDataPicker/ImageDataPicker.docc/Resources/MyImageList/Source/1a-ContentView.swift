//
//  ContentView.swift
//  MyImageList
//
//  Copyright © 2025 Technistic Pty Ltd. All rights reserved.
//

import SwiftData
import SwiftUI

struct ContentView: View {

    var body: some View {

    }
}

#Preview {
    ContentView()
        .modelContainer(for: MyImage.self, inMemory: true)
}
