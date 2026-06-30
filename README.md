[![Build xcframework](https://github.com/Technistic/ImageDataPicker/actions/workflows/build-xcframework.yaml/badge.svg?branch=alpha_v0.1.0)](https://github.com/Technistic/ImageDataPicker/actions/workflows/build-xcframework.yaml)

# SwiftUI ImageDataPicker

## __A SwiftUI control for seemlessly selecting PhotoLibrary images and binding them to SwiftData__.

![ImageDataPicker Hero](/assets/images/ImageDataPicker-README-Hero.png)


The **SwiftUI Image Data Picker Framework** provides a convenient, customizable control you can use in SwiftUI projects to select a photo from an iOS/macOS system's photo library and bind the selected image as `Data?` in app state or a SwiftData model.

Grab the package from [Swift Package Index](https://swiftpackageindex.com/) or download the multi-platform framework to use with Xcode.

## 1. Getting Started

1. Add the ImageDataPicker to your project:

    A. Download the framework archive from our repo and extract the Xcode multi-platform framework or;

    B. Add the Swift package from Swift Package Index.

2. Import the ImageDataPicker module into your project.

    ```
    import ImageDataPicker
    import SwiftUI
    
    ```

3. Create app state to store the selected image data.

    ```
    @State var imageData: Data? = nil
    
    ```

4. Add the ImageDataPicker control to your app.

    ```
    ImageDataPickerView(imageData: $imageData, clipShape: Circle())
    
    ```

## 2. Concept

The ImageDataPicker control simplifies how developers build apps that allow users to select photos from their device's PhotoLibrary and bind them to app state or persist them to a SwiftData  model. Add the ImageDataPicker control to your app - it is multi-platform, designed to run on iOS, iPadOS and macOS. Bind the control to `Data?`. The control automatically presents a thumbnail of the selected image or a customisable placeholder (any SF Symbol with developer defined foreground and background colours). The thumbnail itself automatically adopts a 1:1 aspect ratio, and can be cropped to a circular, rectangular or rounded-rectangular shape.


![Concept](/assets/images/Architecture@1x.png)


## 3. Using the ImageDataPicker

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

Read the [Documentation](https://technistic.github.io/ImageDataPicker/) for details on how to use and customize the **ImageDataPicker** framework across the [integration, staging] release channels, or go directly to the [release framework documentation](https://technistic.github.io/ImageDataPicker/release/imagedatapicker/documentation/imagedatapicker) and [tutorial](https://technistic.github.io/ImageDataPicker/release/imagedatapicker/tutorials/imagedatapickertoc).

See the documentation and code for the **EmployeeFormExample** sample app to understand how the framework fits into a real SwiftUI and SwiftData workflow.

[EmployeeFormExample Documentation](https://technistic.github.io/ImageDataPicker/release/employeeformexample/documentation/employeeformexample)

## Release Channels

The repository uses three release channels:

- `alpha_v*` branches build and test the `*-alpha` schemes and publish prerelease artifacts.
- `beta_v*` branches build and test the `*-beta` schemes and publish prerelease artifacts.
- `main` is the verified production branch.
- `vX.Y.Z` tags created from `main` publish the production GitHub release and the Swift Package Manager release version.

Xcode Cloud and GitHub Actions should both follow the same scheme mapping:

- `alpha_v*` -> `ImageDataPicker-alpha`, `EmployeeFormExample-alpha`
- `beta_v*` -> `ImageDataPicker-beta`, `EmployeeFormExample-beta`
- `main` -> `ImageDataPicker`, `EmployeeFormExample-Release`

## Support

Commercial Support available on request.


Copyright &copy; 2025, 2026 Technistic Pty Ltd
