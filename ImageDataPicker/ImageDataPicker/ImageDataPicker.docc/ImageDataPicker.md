# ``ImageDataPicker``

@Metadata {
    @Available("ImageDataPicker", introduced: "0.2.0")
}

The **ImageDataPicker** framework provides a `SwiftUI` **control** for selecting a photo from the PhotoLibrary using the **PhotosUI** `PhotosPicker` and binding the resulting `Image` to `SwiftData`.

![ImageDataPicker](ImageDataPicker-Hero)

The `ImageDataPicker` framework provides a simple control for selecting photos using SwiftUI's `PhotosPicker` and then stores the selected image to a `SwiftData @Model`. The control presents a thumbnail view in a **1:1 aspect ratio** of the selected photo, that can be clipped to geometries (**round**, **square** or **rounded square**). A customisable placeholder image is presented if no photo has been selected or there is a failure loading the photo.

## Quick Start

![ImageDataPicker](ImageDataPicker-Header)

1. Download the [latest release](https://github.com/Technistic/ImageDataPicker/releases) of the ImageDataPicker framework from the official repository.

2. Add the `ImageDataPicker` framework (`ImageDataPicker.xcframework`) to your Xcode project. This is a multiplatform framework that can be used in iOS, iPadOS and macOS applications.

3. Create a SwiftData `@Model` or declare an `@State` property to store your `imageData`. The property in the model should be a `Data?` type.

4. Add the ``ImageDataPickerView`` to your `View` and bind it to your `imageData`.

```
import ImageDataPicker
import SwiftData
import SwiftUI

struct ContentView: View {
    @State var imageData: Data? = nil

    var body: some View {
        ImageDataPickerView(imageData: $imageData, cshape: Circle())
    }
}
```

5. The ``ImageDataPickerView`` presents an `Image` with a **1:1 aspect ratio**. Use the `cshape` parameter of the ``ImageDataPickerView/init(imageData:emptyImage:errorImage:cshape:backgroundColor:foregroundColor:)-(_,_,_,_,Color,_)`` to specify the clipped shape (`Circle()`, `Rectangle()` or `RoundedRectangle()`) to apply to the ``ImageDataPickerView``.

## Tutorial

Learn more by following the <doc:ImageDataPickerTOC> tutorial.

## Example Application

The [EmployeeFormExample](https://technistic.github.io/ImageDataPicker/employeeformexample/documentation/employeeformexample) application demonstrates how to use the `ImageDataPicker` framework in a multiplatform `SwiftUI` application.

## Topics

### The ImageDataPickerView

- ``ImageDataPickerView`` 

### Image State

- ``ImageDataModel``

- ``ImageDataModel/ImageState``

- ``ImageDataModel/ImageState/empty``

- ``ImageDataModel/ImageState/loading(_:)``

- ``ImageDataModel/ImageState/success(_:)``

- ``ImageDataModel/ImageState/failure(_:)``


### Companion Views

- ``ImageStateView``

- ``ImageDataView``


### View Modifiers

- ``SquareImageViewModifier``

- ``SwiftUICore/View/squareImageView(shape:background:)``


### Utility Functions

- ``Util``

- ``Util/scaleFactor(systemImage:)``

- ``Util/offsetFactor(systemImage:)``


### Customization

- ``Constants``
