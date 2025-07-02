# ``ImageDataPicker``

@Metadata {
    @Available("ImageDataPicker", introduced: "0.0.1")
}

A Framework for binding an Image to SwiftData with a control that allows you to select a photo from the PhotoLibrary using the PhotosUI `PhotosPicker`.

![ImageDataPicker](Release-Doc-Title)

The ImageDataPicker framework provides a simple control to select photos using SwiftUI's PhotosPicker and then store the selected image to a SwiftData Model. The control presents a thumbnail view of the selected image that can be clipped to various geometries (round, square or rounded). A customisable placeholder image is presented if no image has been selected or an error loading the image occurs.

## How to use the ImageDataPicker Framework

![ImageDataPicker](ImageDataPicker-Header)

1. You start by adding the ImageDataPicker Framework (ImageDataPicker.xcframework) to your Xcode project.

2. Create a SwiftData Model to store your image or an @State variable to hold the image data. The model should have a `Data` attribute that can be bound directly to the ImageDataPicker.

3. Add the ``ImageDataPickerView`` to your View and bind it to your imageData.

4. You can use the ``ClippedImageShape`` view modifier to clip the image to a specific shape, such as `.circle`, `.square`, or `.roundedRectangle`. The image will automatically be resized to fit the containing frame and clipped to a 1:1 aspect ratio.

## Topics

### Essentials

[Getting Started]<doc:GettingStarted>


