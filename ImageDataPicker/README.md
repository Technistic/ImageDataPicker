[![Build xcframework](https://github.com/Technistic/ImageDataPicker/actions/workflows/build-xcframework.yaml/badge.svg?branch=alpha_v0.1.0)](https://github.com/Technistic/ImageDataPicker/actions/workflows/build-xcframework.yaml)

# The ImageDataPicker Framework

![ImageDataPicker Hero](/assets/images/ImageDataPicker-README-Hero.png)

## Summary

The **ImageDataPicker** framework provides a convenient, intuitive, and customizable control you can use in **SwiftUI** projects to select photos from the system photo library and bind the selected image as `Data?` in app state or a **SwiftData** [@Model](https://developer.apple.com/documentation/swiftdata/model()).

## Features

The **ImageDataPicker** framework is a multiplatform framework for **SwiftUI** on iOS, iPadOS, macOS, and visionOS. It leverages **PhotosUI** [PhotosPicker](https://developer.apple.com/documentation/photosui/photospicker) to provide a **SwiftUI** control that presents an `Image` selected from a user's photo library. The control automatically crops the selected image to a 1:1 aspect ratio and resizes the image to the containing frame. Use the `clipShape` initializer parameter to present the image clipped to a circular, square, or rounded-square shape.

![Clipping Options](ImageDataPicker/ImageDataPicker.docc/Resources/Clipping-Background@0.5x.png)

If no image is selected, or there is an error loading the selected Image, the control will present a customizable placeholder Image in its place.

![Placeholder Options](ImageDataPicker/ImageDataPicker.docc/Resources/Placeholders@0.5x.png)

## Get the **ImageDataPicker** Framework

### Swift Package Manager

Add this repository in Xcode using `File > Add Package Dependencies...`, then select the `ImageDataPicker` library product.

### XCFramework

1. [Download](https://github.com/Technistic/ImageDataPicker/releases) the latest archive of the **ImageDataPicker** framework from the official repo.

2. Double-click the downloaded file to extract the archive.

## Using the **ImageDataPicker** Framework

1. If you are using the xcframework distribution, add **ImageDataPicker.xcframework** to your Xcode project.

    ![Embed Framework](/assets/images/MyGreatApp-FrameworkEmbedded.png)
   
2. Add the ``ImageDataPickerView`` to a View in your application.
 
    ```
    //
    //  ContentView.swift
    //  MyGreatApp
    //
    //

    import ImageDataPicker
    import SwiftData
    import SwiftUI

    struct ContentView: View {
        @State var imageData: Data? = nil
        var body: some View {
            VStack {
                ImageDataPickerView(
                    imageData: $imageData,
                    clipShape: Circle(),
                    backgroundColor: .gray,
                    foregroundColor: .white
                )
                .frame(width: 240, height: 240)
                .padding(32)
                Text("Image Data Picker")
                    .font(.title)

                Spacer()
            }
        }
    }

    #Preview {
        @Previewable @State var imageData: Data? = nil
        ContentView()
    }
    ```
   ![ContentView.swift](/assets/images/MyGreatApp-Content.png)
 
## Documentation

See the full [Documentation](https://technistic.github.io/ImageDataPicker/imagedatapicker/documentation/imagedatapicker) for details on how to use and customize the **ImageDataPicker** framework.

Follow the [Tutorial](https://technistic.github.io/ImageDataPicker/imagedatapicker/tutorials/imagedatapickertoc) to learn how to adopt the framework in a multiplatform SwiftUI application.

Look at the [Documentation](https://technistic.github.io/ImageDataPicker/employeeformexample/documentation/employeeformexample) and [code](/EmployeeFormExample) for the [EmployeeFormExample](EmployeeFormExample/README.md) application to see how the framework is used in a working sample app.

## Release Channels

This repository publishes three release channels:

- `alpha_v*` branches run the `ImageDataPicker-alpha` and `EmployeeFormExample-alpha` schemes and publish prerelease XCFramework artifacts.
- `beta_v*` branches run the `ImageDataPicker-beta` and `EmployeeFormExample-beta` schemes and publish prerelease XCFramework artifacts.
- `main` runs the production schemes, publishes the production XCFramework release, and updates the semantic version tag used by Swift Package Manager.

## Credits

### Sample Images

The sample images used in this project are from [unsplash.com](https://unsplash.com).

Photo by [Jimmy Fermin](https://unsplash.com/@jimmyferminphotography?utm_content=creditCopyText&utm_medium=referral&utm_source=unsplash)

![Jimmy Fermin Image](ImageDataPicker/Preview%20Content/Preview%20Assets.xcassets/TestPortrait.imageset/jimmy-fermin.png)

[Credit](https://unsplash.com/photos/woman-staring-directly-at-camera-near-pink-wall-bqe0J0b26RQ?utm_content=creditCopyText&utm_medium=referral&utm_source=unsplash)


## Support

Commercial Support available on request.

**Contact:** [sales@technistic.com](mailto:sales@technistic.com)

---

Copyright &copy; 2025 Technistic Pty Ltd
