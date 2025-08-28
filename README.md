[![Build xcframework](https://github.com/Technistic/ImageDataPicker/actions/workflows/build-xcframework.yaml/badge.svg?branch=alpha_v0.1.0)](https://github.com/Technistic/ImageDataPicker/actions/workflows/build-xcframework.yaml)

# The ImageDataPicker Framework

<img width="518" height="322" alt="ImageDataPicker-README-Hero" src="https://github.com/user-attachments/assets/ae9cf4bb-4223-4523-80d5-f62f4bc78aa3" />

The **ImageDataPicker** framework provides a convenient, intuitive and customizable control that you can use in your SwiftUI projects, to select images from a device's **PhotoLibrary** and bind the selected image to a SwiftData Model.

## Quick Start

1. [Download](https://github.com/Technistic/ImageDataPicker/releases) the latest copy of the **ImageDataPicker** framework.

2. Add **(+)** the Framework to your Xcode Project.
   
    <img width="624" height="310" alt="MyImageList-Framework Added" src="https://github.com/user-attachments/assets/e209dc2f-4cc7-49e1-b7e5-577bad11b8b1" />

4. Add the `ImageDataPickerView` to a View in your application.
   
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

Read the full [Documentation](https://technistic.github.io/ImageDataPicker/imagedatapicker/documentation/imagedatapicker) for details on how to use and customize the [ImageDataPicker](ImageDataPicker/README.md) framework.

Walk through the [Tutorial](https://technistic.github.io/ImageDataPicker/imagedatapicker/tutorials/imagedatapickertoc) to learn how to build a multi-platform application using the Framework.

Look at the [Documentation](https://technistic.github.io/ImageDataPicker/employeeformexample/documentation/employeeformexample) and [code](/EmployeeFormExample) for our [EmployeeFormExample](EmployeeFormExample/README.md) application, to understand how to use the Framework in a *real-world* application.

## Support

Commercial Support available on request.

Contact <a href="mailto:support&amp;#64;technistic.com">support&#64;technistic.com</a>

---

Copyright &copy; 2025 Technistic Pty Ltd
