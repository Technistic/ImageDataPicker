# ``ImageDataPicker``

@Metadata {
    @Available("ImageDataPicker", introduced: "0.1.0")
}

The **ImageDataPicker** framework provides a **SwiftUI** control for selecting a photo from the photo library using **PhotosUI** and storing it as `Data?`.

![ImageDataPicker](ImageDataPicker-Hero)

Use the `ImageDataPickerView` to bind a selected photo directly to `Data?` in `@State` or a SwiftData model. The control presents a square (1:1) thumbnail of the image clipped to a supplied shape. Button controls overlaid on the image allow the selected image to be removed or changed. An empty image is represented by an ``Constants/photoPlaceholder`` and any error in loading an image presents an ``Constants/errorPlaceholder``.

## Quick Start

![ImageDataPicker](ImageDataPicker-Header)

1. Add the package in Xcode with **File > Add Package Dependencies...** or download the [latest release](https://github.com/Technistic/ImageDataPicker/releases) if you prefer the xcframework distribution.

2. If you are using the binary distribution, add `ImageDataPicker.xcframework` to your Xcode project. The framework supports iOS, iPadOS, macOS, and visionOS.

3. Create a SwiftData `@Model` property or an `@State` property to store image data as `Data?`.

4. Add the ``ImageDataPickerView`` to your `View` and bind it to your `imageData`.

```
import ImageDataPicker
import SwiftData
import SwiftUI

struct ContentView: View {
    @State var imageData: Data? = nil

    var body: some View {
        ImageDataPickerView(imageData: $imageData, clipShape: Circle())
    }
}
```

5. `ImageDataPickerView` always renders a square image. Use the `clipShape` parameter of ``ImageDataPickerView/init(imageData:emptyPlaceholderImageName:errorPlaceholderImageName:clipShape:backgroundColor:foregroundColor:)`` to clip it to shapes such as `Circle()`, `Rectangle()`, or `RoundedRectangle(cornerRadius:)`.

## Tutorial

Learn more by following the <doc:ImageDataPickerTOC> tutorial.

## Example Application

The [EmployeeFormExample](https://technistic.github.io/ImageDataPicker/employeeformexample/documentation/employeeformexample) application demonstrates how to use the **ImageDataPicker** framework in a multiplatform **SwiftUI** application backed by SwiftData.

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

- ``SymbolLayoutHelper``

- ``SymbolLayoutHelper/scaleFactor(systemImage:)``

- ``SymbolLayoutHelper/offsetFactor(systemImage:)``


### Customization

- ``Constants``
