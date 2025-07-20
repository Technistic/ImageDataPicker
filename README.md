# Swift Image Data Picker

The **Swift Image Data Picker Framework** provides a convenient, intuitive and customizable control that you can use in your SwiftUI projects, to select images from a device's Photo Library and bind the selected image to a Swift Data Model.

<img width="640" height="320" alt="GitHub 640" src="https://github.com/user-attachments/assets/b36f3d25-3681-4197-8ad6-9b24382a0761" />

## Getting Started

[Download](https://github.com/Technistic/ImageDataPicker/releases) the latest copy of the Image Data Picker Framework and Add (+) it to your Swift Project.

<img width="320" height="122" alt="GitHub Xcode Framework" src="https://github.com/user-attachments/assets/cb41a35c-7862-457c-a6e0-46c30397c630" />

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

<img width="320" height="263" alt="GitHub Xcode Code" src="https://github.com/user-attachments/assets/80e65e6b-80d0-44a0-acdf-964879d4fbd8" />

## Documentation

Read the [Documentation](https://technistic.github.io/ImageDataPicker/imagedatapicker/documentation/imagedatapicker) for details on how to use and customize the **Image Data Framework** or get started by following our Tutorial.

Look at the documentation and code for our **EmployeeForm** example app, to see how to use the Framework in your Apps.

## Support

Commercial Support available on request.

## Further Details

[ImageDataPicker - README](ImageDataPicker/README.md)

[ImageDataPicker Documentation](https://technistic.github.io/ImageDataPicker/imagedatapicker/documentation/imagedatapicker)

[EmployeeFormExample - README](EmployeeFormExample/README.md)

[EmployeeFormExample Documentation](https://technistic.github.io/ImageDataPicker/employeeformexample/documentation/employeeformexample)

Copyright Technistic Pty Ltd 2025
