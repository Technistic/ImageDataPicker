[![Build xcframework](https://github.com/Technistic/ImageDataPicker/actions/workflows/build-xcframework.yaml/badge.svg?branch=alpha_v0.1.0)](https://github.com/Technistic/ImageDataPicker/actions/workflows/build-xcframework.yaml)

# The ImageDataPicker Framework

![ImageDataPicker Hero](/assets/images/ImageDataPicker-README-Hero.png)

## Summary

The **ImageDataPicker** framework provides a convenient, intuitive and customizable control that you can use in your **SwiftUI** projects, to select photos from a device's **PhotoLibrary** and bind the selected image to a **SwiftData** [@Model](https://developer.apple.com/documentation/swiftdata/model()).

Learn more by reading the [Documentation](https://technistic.github.io/ImageDataPicker/imagedatapicker/documentation/imagedatapicker) or following the [Tutorial](https://technistic.github.io/ImageDataPicker/imagedatapicker/tutorials/imagedatapickertoc).

## Quick Start

1. [Download](https://github.com/Technistic/ImageDataPicker/releases) the latest copy of the **ImageDataPicker** framework.

2. Add **(+)** the Framework to your Xcode Project.
   
    ![Embed Framework](/assets/images/FrameworkEmbedded.png)

4. Add the `ImageDataPickerView` to a `View` in your application.
   
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
        @State var imageData: Data? = UIImage(named: "Image")!.pngData()
        var body: some View {
            VStack {
                ImageDataPickerView(imageData: $imageData)
                .clippedImageShape(.round)
                .frame(width: 240, height: 240)
                .padding(32)

                Text("Image Data Picker")
                .font(.title)

            	Spacer()
            }
        }
    }
     
    #Preview {
        @Previewable @State var imageData: Data? = UIImage(named: "Image")!.pngData()
        ContentView()
    }
    ```

    ![ContentView.swift](/assets/images/MyGreatApp-Content.png)

## Documentation

Read more about the [ImageDataPicker](ImageDataPicker/README.md) framework.

See the full [Documentation](https://technistic.github.io/ImageDataPicker/imagedatapicker/documentation/imagedatapicker) for details on how to use and customize the **ImageDataPicker** framework.

Follow the [Tutorial](https://technistic.github.io/ImageDataPicker/imagedatapicker/tutorials/imagedatapickertoc) to learn how to build a multi-platform application using the **ImageDataPicker** framework.

Look at the [Documentation](https://technistic.github.io/ImageDataPicker/employeeformexample/documentation/employeeformexample) and [code](/EmployeeFormExample) for our [EmployeeFormExample](EmployeeFormExample/README.md) application, to understand how to use the Framework in a *real-world* application.

## Support

Commercial Support available on request.

**Contact:** [sales@technistic.com](mailto://sales@technistic.com)

---

Copyright &copy; 2025 Technistic Pty Ltd
