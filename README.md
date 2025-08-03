<img width="640" height="320" alt="ImageDataPicker-DocC" src="https://github.com/user-attachments/assets/a4b5dd0d-b3ce-4fcd-a6a6-24279d031ff4" />

# SwiftUI Image Data Picker

The **SwiftUI Image Data Picker Framework** provides a convenient, intuitive and customizable control that you can use in your SwiftUI projects, to select images from a device's Photo Library and bind the selected image to a SwiftData Model.

## Getting Started

### Download the Framework

[Download](https://github.com/Technistic/ImageDataPicker/releases) the latest copy of the Image Data Picker Framework and Add **(+)** it to your Swift Project.

<img width="1247" height="621" alt="MyImageList-Framework Added" src="https://github.com/user-attachments/assets/e209dc2f-4cc7-49e1-b7e5-577bad11b8b1" />

### Add the `ImageDataPickerView` to your view

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

<img width="640" height="512" alt="GitHub Xcode Code" src="https://github.com/user-attachments/assets/80e65e6b-80d0-44a0-acdf-964879d4fbd8" />

## Documentation

Read the [Documentation](https://technistic.github.io/ImageDataPicker/imagedatapicker/documentation/imagedatapicker) for details on how to use and customize the **Image Data Framework** or get started by following our [Tutorial](https://technistic.github.io/ImageDataPicker/imagedatapicker/tutorials/imagedatapickertoc).

Look at the documentation and code for our **EmployeeForm** example app, to see how to use the Framework in your Apps.

## Support

Commercial Support available on request.

## Further Details

[ImageDataPicker - README](ImageDataPicker/README.md)

[ImageDataPicker Documentation](https://technistic.github.io/ImageDataPicker/imagedatapicker/documentation/imagedatapicker)

[EmployeeFormExample - README](EmployeeFormExample/README.md)

[EmployeeFormExample Documentation](https://technistic.github.io/ImageDataPicker/employeeformexample/documentation/employeeformexample)

Copyright &copy; 2025 Technistic Pty Ltd
