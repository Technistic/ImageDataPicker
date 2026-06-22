[![Build xcframework](https://github.com/Technistic/ImageDataPicker/actions/workflows/build-xcframework.yaml/badge.svg?branch=alpha_v0.1.0)](https://github.com/Technistic/ImageDataPicker/actions/workflows/build-xcframework.yaml)

<img width="640" height="320" alt="ImageDataPicker-DocC" src="https://github.com/user-attachments/assets/a4b5dd0d-b3ce-4fcd-a6a6-24279d031ff4" />

# SwiftUI Image Data Picker

The **SwiftUI Image Data Picker Framework** provides a convenient, customizable control you can use in SwiftUI projects to select a photo from the system photo library and bind the selected image as `Data?` in app state or a SwiftData model.

## Getting Started

### Add with Swift Package Manager

In Xcode, choose `File > Add Package Dependencies...` and add this repository. Then add the `ImageDataPicker` library product to your app target.

### Download the XCFramework

[Download](https://github.com/Technistic/ImageDataPicker/releases) the latest xcframework release and add **ImageDataPicker.xcframework** to your Xcode project.

<img width="1247" height="621" alt="MyImageList-Framework Added" src="https://github.com/user-attachments/assets/e209dc2f-4cc7-49e1-b7e5-577bad11b8b1" />

### Add the `ImageDataPickerView` to your view

```
import ImageDataPicker
import SwiftUI

struct ContentView: View {
    @State private var imageData: Data? = nil
    var body: some View {
        ImageDataPickerView(
            imageData: $imageData,
            clipShape: Circle()
        )
        .padding()
    }
}
```

<img width="640" height="512" alt="GitHub Xcode Code" src="https://github.com/user-attachments/assets/80e65e6b-80d0-44a0-acdf-964879d4fbd8" />

## Documentation

Read the [Documentation](https://technistic.github.io/ImageDataPicker/imagedatapicker/documentation/imagedatapicker) for details on how to use and customize the **ImageDataPicker** framework, or get started with the [Tutorial](https://technistic.github.io/ImageDataPicker/imagedatapicker/tutorials/imagedatapickertoc).

See the documentation and code for the **EmployeeFormExample** sample app to understand how the framework fits into a real SwiftUI and SwiftData workflow.

## Release Channels

The repository uses three release channels:

- `alpha_v*` branches build and test the `*-alpha` schemes and publish prerelease artifacts.
- `beta_v*` branches build and test the `*-beta` schemes and publish prerelease artifacts.
- `main` builds production artifacts, publishes the production GitHub release, and updates the semantic version tag used by Swift Package Manager.

## Support

Commercial Support available on request.

[EmployeeFormExample Documentation](https://technistic.github.io/ImageDataPicker/employeeformexample/documentation/employeeformexample)

Copyright &copy; 2025 Technistic Pty Ltd
