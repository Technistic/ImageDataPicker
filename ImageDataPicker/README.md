# Image Data Picker Framework

The **Swift Image Data Picker Framework** is a multi-platform (iOS, iPadOS, macOS) Framework that provides a convenient, intuitive and customizable control that you can use in your SwiftUI projects, to select images from a device's Photo Library and bind the selected image to a Swift Data Model.

<p align="center">
<img width="640" height="320" alt="GitHub 640" src="https://github.com/user-attachments/assets/b36f3d25-3681-4197-8ad6-9b24382a0761" />
</p>

## Getting Started

### Quick Start

You can [download](https://github.com/Technistic/ImageDataPicker/releases) the latest copy of the Image Data Picker Framework from the [Technistic/ImageDataPicker](https://github.com/Technistic/ImageDataPicker) repository [Releases](https://github.com/Technistic/ImageDataPicker/releases) page.

Expand the downloaded `ImageDataPicker.tgz` archive and **Add (+)** the `ImageDataPicker.xcframework` to your SwiftUI Project.

<p align="center">
<img width="640" height="244" alt="GitHub Xcode Framework" src="https://github.com/user-attachments/assets/cb41a35c-7862-457c-a6e0-46c30397c630" />
</p>

Then include an [ImageDataPickerView()](https://technistic.github.io/ImageDataPicker/imagedatapicker/documentation/imagedatapicker/imagedatapickerview) in your App.

```
import ImageDataPicker
import SwiftUI

struct ContentView: View {
    @State private var imageData: Data? = nil
    var body: some View {
        VStack {
            ImageDataPickerView(imageData: $imageData)
        }
        .padding()
    }
}
```

<p align="center">
<img width="640" height="526" alt="GitHub Xcode Code" src="https://github.com/user-attachments/assets/80e65e6b-80d0-44a0-acdf-964879d4fbd8" />
</p>

### Using the ImageDataPicker in your App

1. Create a new Xcode Project.
2. Select the `Multiplatform` App template.
3. On the _Choose options for your new project:_ page, select **Options:** `SwiftData`.
4. Create a **SwiftData Model** for your _App_. The **photo** computed property returns an **Image View** of the **imageData**.
```
import Foundation
import SwiftData
import SwiftUI

struct Constants {
    static let photoPlaceholder: String = "photo"
    static let personPlaceholder: String = "person.fill"
}

@Model
final class MyImage: Identifiable {
    var imageName: String
    var imageData: Data?

    var photo: Image {
        #if canImport(UIKit)
            if let imageData, let uiImage = UIImage(data: imageData) {
                return Image(uiImage: uiImage)
            } else {
                return Image(systemName: Constants.photoPlaceholder)
            }
        #else
            if let imageData {
                return Image(nsImage: NSImage(data: imageData as Data)!)
            } else {
                return Image(systemName: Constants.photoPlaceholder)
            }
        #endif
    }
```
5. Add a **NavigationSplitView** to navigate your application's data.
```
import SwiftData
import SwiftUI

struct MyImageListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var myImages: [MyImage]

    @State private var selectedImageID: MyImage.ID? = nil
    @State private var columnVisibility = NavigationSplitViewVisibility.doubleColumn

    var body: some View {
        NavigationSplitView(columnVisibility: $columnVisibility) {
            List(selection: $selectedImageID) {
                ForEach(myImages) { image in
		    Text(image.imageName)
		    image.photo
			.resizeable()
			.scaleToFit()
			.frame(height: 60)
		}
	    }
	    .toolbar {
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
                if let theImage = modelContext.model(for: selectedImageID!) as? MyImage {
                        MyImageView(theImage: theImage)
		}
            }
        }
    }

    private func addImage() {
        withAnimation {
            let newImage = MyImage(
                imageName: "A New Image"
            )
            modelContext.insert(newImage)
            selectedImageID = newImage.persistentModelID
        }
    }
}
```
6. Add an **ImageDataPickerView** to the MyImageView.
```
import SwiftData
import SwiftUI

import ImageDataPicker

struct MyImageView: View {
    @Environment(\.modelContext) private var modelContext

    public var theImage: MyImage

    var body: some View {
	@Bindable var _image = theImage
        TextField("Image Name:", text: $_image.imageName)
	ImageDataPickerView(imageData: $_image.imageData)
	.frame(height: 120)
    }
}
```

## Documentation

Read the [Documentation](https://technistic.github.io/ImageDataPicker/imagedatapicker/documentation/imagedatapicker) for details on how to use and customize the **Image Data Framework** or get started by following our Tutorial.

The **Employee Form** example App, shows how the **Image Data Picker** can be incorporated into a SwiftData application.

## Support

Commercial Support available on request. 

**Email:** <a href="mailto:sales\@technistic.com">sales\@technistic.com</a>

Copyright &copy; 2025 Technistic Pty Ltd
