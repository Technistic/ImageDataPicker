//
//  ImageDataView.swift
//  A SwiftUI Image View that supports SwiftData binding.
//
//  Created by Michael Logothetis on 30/04/2025.
//
//  MIT License
//  Copyright (c) 2025 Michael Logothetis (Technistic Pty Ltd)
//

import Foundation
import OSLog
import SwiftUI

/// An Image View of the supplied ``imageData``, scaled to the size of the parent container and maintaining the image's original aspect ratio.
///
/// The ``ImageDataView`` produced a SwiftUI Image derived from the supplied ``imageData``. ``imageData`` can be stored as an attributed of a SwiftData Model. If ``imageData`` is nil, a placeHolderImage is presented based on an SF Symbols `systemName` image. The default is to use the ``Constants/personPlaceholder`` image but this can be overriden on creation.
///
/// Refer to: [https://developer.apple.com/design/resources/#sf-symbols](https://developer.apple.com/design/resources/#sf-symbols)
///



//@available(iOS 13.0, macCatalyst 13.0, macOS 10.15, visionOS 1.0, *)
public struct ImageDataView: View {

    public var imageData: Data?
    private var placeholder: String = Constants.personPlaceholder

    /// Initializes an Image View using imageData. Use the emptyImage parameter to override the default system symbol image presented when imageData is nil
    /// - Parameters:
    ///   - imageData: The data for the underlying image. Although this can be in the format of any of the supported platform-native image types, png format is recommended.
    ///   - placeholder: The system symbol image to use as a placeholder if imageData is nil.
    public init(
        imageData: Data? = nil,
        placeholder: String = Constants.personPlaceholder
    ) {
        let x: MyFWClass = MyFWClass()
        self.imageData = imageData
        self.placeholder = placeholder
    }

    public var body: some View {
        
        //Image("blahBlah")
        //    .resizable()
        //    .scaledToFit()
            
        #if canImport(UIKit)
            if let imageData {
                if let uiImage = UIImage(data: imageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                } else {
                    Image(systemName: placeholder)
                        .resizable()
                        .scaledToFit()
                }
            } else {
                Image(systemName: placeholder)
                    .resizable()
                    .scaledToFit()
            }
        #endif
        #if canImport(AppKit)
            if let imageData {
                if let nsImage = NSImage(data: imageData) {
                    Image(nsImage: nsImage)
                        .resizable()
                        .scaledToFill()
                } else {
                    Image(systemName: placeholder)
                        .resizable()
                        .scaledToFit()
                }
            } else {
                Image(systemName: placeholder)
                    .resizable()
                    .scaledToFit()
            }
        #endif
        Image(systemName: "person")
            
    }
}

/* extension DeveloperToolsSupport.ImageResource {
    /// The "japan-street" asset catalog image resource.
    static let japanStreet = DeveloperToolsSupport.ImageResource(name: "Image", bundle: Bundle(for: ImageDataModel.self))
} */

#Preview("Photo View") {
    @Previewable @State var imageData: Data? = nil

    let placeholder: String = "photo"

    ImageDataView(imageData: imageData)
        .border(.green)

    ImageDataView(imageData: imageData)
        .scaledToFit()
        .scaleEffect(Util.scaleFactor(systemImage: placeholder))
        .offset(x: 0, y: Util.offsetFactor(systemImage: placeholder))
        .squareImageView(shape: Circle(), background: .gray)
        // Test .background(), .border(), .frame() modifiers
        .background(.yellow)
        .clipped()
        .border(.green)
        .frame(width: 200, height: 200)
}

/* public func myView() -> Image {
    Image(uiImage: UIImage(named: "blahBlah", in: Bundle(for: MyFWClass.self), compatibleWith: nil)!)

} */

#Preview("Exclamation Mark View") {
    @Previewable @State var imageData: Data? = nil

    let placeholder: String = "exclamationmark.triangle"

    ImageDataView(imageData: imageData, placeholder: placeholder)
        .border(.green)

    ImageDataView(imageData: imageData, placeholder: placeholder)
        .scaledToFill()
        .scaleEffect(Util.scaleFactor(systemImage: placeholder))
        .offset(x: 0, y: Util.offsetFactor(systemImage: placeholder))
        .squareImageView(shape: Circle(), background: .gray)
        // Test .background(), .border(), .frame() modifiers
        .background(.yellow)
        .clipped()
        .border(.green)
        .frame(width: 200, height: 200)
}

#Preview("Image View") {
    
    //Image(uiImage: UIImage(named: "blahBlah", in: Bundle(for: MyFWClass.self), compatibleWith: nil)!)
    
    //Image(uiImage: UIImage(named: "blahBlah", in: Bundle.main, compatibleWith: nil)!)
    
    /* myView()
        .resizable()
        .scaledToFill() */
        
    @Previewable @State var imageData: Data? = UIImage(named: "blahBlah", in: Bundle(for: ImageDataModel.self), compatibleWith: nil)?.pngData()
    
    ImageDataView(imageData: imageData, placeholder: "photo")
    
    //let frameworkBundles = Bundle.allFrameworks
    //let frameworkNames = frameworkBundles.compactMap { $0.bundleIdentifier }

    //Image(.blahBlah)
    //Image(uiImage: UIImage(named: "blahBlah", in: Bundle(for: MyFWClass.self), compatibleWith: nil)!)
    //Image(uiImage("Image", bundle: Bundle)
        //.resizable()
        //.scaledToFill()
        //.frame(width: 200, height: 200)
        
    //let bundle = Bundle(identifier: "com.technistic.ImageDataPicker")
    //ImageDataView(imageData: nil, placeholder: "photo")

    /* Text("Hello")
        .frame(width: 200, height: 200)
        .onAppear {
            print("Frameworks used by the application:")
            //for name in frameworkNames {
            //    print(name)
            //}
        } */

    ImageDataView(imageData: nil, placeholder: "photo")
        
    
    
    /*ImageDataView(imageData: imageData)
        .border(.green)

    ImageDataView(imageData: imageData)
        .scaledToFill()
        .squareImageView(shape: Circle())
        // Test .background(), .border(), .frame() modifiers
        .background(.yellow)
        .clipped()
        .border(.green)
        .frame(width: 200, height: 200) */
}
