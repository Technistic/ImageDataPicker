# The ImageDataPicker Framework

<img width="518" height="322" alt="ImageDataPicker-README-Hero" src="https://github.com/user-attachments/assets/ae9cf4bb-4223-4523-80d5-f62f4bc78aa3" />

The **ImageDataPicker** framework provides a convenient, intuitive and customizable control that you can use in your **SwiftUI** projects, to select images from a device's **PhotoLibrary** and bind the selected image to a **SwiftData** `@Model`.

## Overview

The **ImageDataPicker** is a multi-platform framework that can be used with **SwiftUI** on iOS, iPadOS and macOS. It leverages the **Swift PhotosUI** `PhotosPicker` to provide a **SwiftUI** control that presents an `Image` and allows a user to select a photo from a device's **PhotoLibrary**. The control automatically crops the selected image to a 1:1 aspect ratio and resizes the image to the containing `Frame`. The `clippedImageShape()` viewModifier allows the view to be presented as a circle, rounded-square or square.

![Clipping Options](/ImageDataPicker/ImageDataPicker/ImageDataPicker.docc/Resources/Clipping-Background@0.5x.png)

If no image is selected, the control will present a customizable placeholder image.

![Placeholder Options](/ImageDataPicker/ImageDataPicker/ImageDataPicker.docc/Resources/Placeholders@0.5x.png)

## Download

[Download](https://github.com/Technistic/ImageDataPicker/releases) the latest copy of the **ImageDataPicker** framework from the official repo.

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

Read the [Documentation](https://technistic.github.io/ImageDataPicker/imagedatapicker/documentation/imagedatapicker) for details on how to use and customize the **ImageDataPicker Framework**.

Walk through the [Tutorial](https://technistic.github.io/ImageDataPicker/imagedatapicker/tutorials/imagedatapickertoc) to learn how to build a multi-platform application using the Framework.

## Support

Commercial Support available on request.

**Contact** <a href="mailto:sales&#64;technistic.com?subject='Request for ImageDataPicker commercial support'" target="_blank">sales&#64;technistic.com</a>

---

Copyright &copy; 2025 Technistic Pty Ltd
