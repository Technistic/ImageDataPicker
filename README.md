[![Build xcframework](https://github.com/Technistic/ImageDataPicker/actions/workflows/build-xcframework.yaml/badge.svg?branch=alpha_v0.1.0)](https://github.com/Technistic/ImageDataPicker/actions/workflows/build-xcframework.yaml)

# SwiftUI ImageDataPicker

*_A SwiftUI control for seemlessly selecting PhotoLibrary images and binding them to SwiftData_*.

![ImageDataPicker Hero](/assets/images/ImageDataPicker-README-Hero.png)


The **SwiftUI Image Data Picker Framework** provides a convenient, customizable control you can use in SwiftUI projects to select a photo from an iOS/macOS system's photo library and bind the selected image as `Data?` in app state or a SwiftData model.

Grab the package from [Swift Package Index](https://swiftpackageindex.com/) or download the multi-platform framework to use it in Xcode.

## 1. Getting Started

### 1.1 Add the ImageDataPicker to your project:

A. Download the framework archive from our repo and extract the Xcode multi-platform framework or;

B. Add the Swift package from Swift Package Index.

### 1.2. Import the ImageDataPicker module into your project.

    ```
    import ImageDataPicker
    import SwiftUI
    ```

### 1.3. Create app state to store the selected image data.

    ```
    @State var imageData: Data? = nil
    ```

### 1.4. Add the ImageDataPicker control to your app.

```
ImageDataPickerView(imageData: $imageData, clipShape: Circle())
```


## 2. Overview

The ImageDataPicker control simplifies how developers build apps that allow users to select photos from their device's PhotoLibrary and bind them to app state or persist them to a SwiftData  model.

Add the ImageDataPicker control to your app - it is multi-platform, designed to run on iOS, iPadOS and macOS. Bind the control to `Data?`.

The control automatically presents a thumbnail of the selected image or a customisable placeholder (any SF Symbol with developer defined foreground and background colours). The thumbnail itself automatically adopts a 1:1 aspect ratio, and can be cropped to a circular, rectangular or rounded-rectangular shape.


![Concept](/assets/images/Architecture@1x.png)


## 3. Using the ImageDataPicker

### 3.1 Add with Swift Package Manager

In Xcode, choose `File > Add Package Dependencies...` and add this repository. Then add the `ImageDataPicker` library product to your app target.

### 3.2 Download the XCFramework

[Download](https://github.com/Technistic/ImageDataPicker/releases) the latest xcframework release and add **ImageDataPicker.xcframework** to your Xcode project.

![Add xcframework](/assets/images/MyGreatApp-FrameworkEmbedded.png)

### 3.3 Add the `ImageDataPickerView` to your view

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

![Add ImageDataPickerView](/assets/images/MyGreatApp-Content.png)


## 4. Documentation

Read the [Documentation](https://technistic.github.io/ImageDataPicker/) for details on how to use and customize the **ImageDataPicker** framework.


## 5. Tutorial

The [ImageDataPicker Tutorial](https://technistic.github.io/ImageDataPicker/staging/imagedatapicker/tutorials/imagedatapickertoc) provides a comprehensive step-by-step quide on how to incorporate and use the ImageDataPicker in your application. 


## 6. The EmployeeFormExample App

The EmployeeFormExample App demonstrates how to use the ImageDataPicker framework in a real-world application. It shows how the framework fits into real SwiftUI and SwiftData workflows.

[EmployeeFormExample Documentation](https://technistic.github.io/ImageDataPicker/staging/employeeformexample/documentation/employeeformexample)


## 7. Release Channels

The repository uses three release channels:

- `alpha_v*` branches build and test the `*-alpha` schemes and publish pre-release artifacts for integration testing.
- `beta_v*` branches build and test the `*-beta` schemes and publish pre-release artifacts for staging releases.
- `main` is the verified production branch.
- `vX.Y.Z` tags created from `main` publish the production GitHub release and the Swift Package Manager release version.

Xcode Cloud and GitHub Actions both follow the same scheme mapping:

- `alpha_v*` -> `ImageDataPicker-alpha`, `EmployeeFormExample-alpha`
- `beta_v*` -> `ImageDataPicker-beta`, `EmployeeFormExample-beta`
- `main` -> `ImageDataPicker`, `EmployeeFormExample-Release`


## 8. Support

If you encounter a bug or would like to suggest an enhancement, review the current list of [open issues](https://github.com/Technistic/ImageDataPicker/issues) first.

Commercial Support available on request. E-mail <sales@technistic.com>.


> Copyright &copy; 2025, 2026 Technistic Pty Ltd
