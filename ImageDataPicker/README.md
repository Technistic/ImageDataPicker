# SwiftUI  Image Data Picker
![][image-1]

 
The Image Data Picker Framework, provides a simple control to select photos using SwiftUI's PhotosPicker and then store the selected image to a SwiftData Model. The control presents a thumbnail view of the selected image that can  be clipped to various geometries (round, square, rounded square).

## Getting Started in Xcode

1. Create a new Xcode Project

2. Select a Multiplatform App

3. Add ImageDataPicker as Swift Package dependency.

4. Import ImageDataPicker into you project

	import SwiftData
	import SwiftUI
	import ImageDataPicker

## Using the ImageDataPicker

1. Create a SwiftData Model to store your image

	import Foundation
	import SwiftData
	import SwiftUI
	import ImageDataPicker
	# if canImport(UIKit)
	//import UIKit
	# endif
		
		
	/// Employee Data Model
	///
	/// This simple SwiftData model forms part of the EmployeeFormExample App that demonstrates how to use the Swift Data Image Picker.
	///
	/// The model stores an Employee name (non-unique) and photo. The photo image data is stored in a `Data` attribute called `imageData`. The `imageData` that can be bound directly to the
	/// Swift Data Image Picker. The Employee class also provides a computed variable `image` that returns the `imageData` as a `UIImage`. If `imageData` is nil, `image` returns a placeholder image.
	///
	@Model
	final class MyPhoto {
		var imageName: String?
		var imageData: Data?
		
		/// Initialize an MyModel with an imageName and (optional) imageData.
		/// - Parameters:
		///   - imageName: The name of the Photo
		///   - imageData: The imageData. Any platform supported image format can be used but .png is preferred.
		init(imageName: String, imageData: Data? = nil) {
		    self.imageName = imageName
		    self.imageData = imageData
		}
		
		/// Representation of the stored imageData as an Image View. If imageData is nil a placeholder image is presented.
		var photo: Image {
		    //ImageDataView(imageData: imageData)
		    #if canImport(UIKit)
		
		    if let imageData, let uiImage = UIImage(data: imageData) {
		        return Image(uiImage: uiImage)
		    }
		    else
		    {
		        return pConstants.personPlaceholderImage
		    }
		    #else
		    if let imageData {
		        return Image(nsImage: NSImage(data: imageData as Data)!)
		    }
		    else
		    {
		        return pConstants.personPlaceholderImage
		    }
		    #endif
		}
	}

[image-1]:	file:///.file/id=6571367.224925024