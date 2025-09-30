//
//  SquareImageViewModifier.swift
//  A ViewModifier to transform a View to a square (1:1)
//  aspect ratio.
//
//  Created by Michael Logothetis on 22/09/2025.
//
//  MIT License
//  Copyright (c) 2025 Michael Logothetis (Technistic Pty Ltd)
//

import SwiftUI

#if canImport(UIKit)
    import UIKit
#endif

#if canImport(UIColor)
    import UIColor
#endif

public struct SquareImageViewModifier<S: Shape>: ViewModifier {
    var shape: S

    #if canImport(AppKit)
        var background: Color = Color(nsColor: NSColor.windowBackgroundColor)
    #else
        var background: Color = Color(uiColor: UIColor.systemBackground)
    #endif

    public func body(content: Content) -> some View {
        var imageSize: CGSize = CGSize(
            width: CGFloat.infinity,
            height: CGFloat.infinity
        )
        ZStack {
            GeometryReader { geometry in
                let side = Util.minDim(geometry.size)
                content
                    .frame(width: side, height: side)
                    .background(background)
                    .clipShape(shape)
                    .clipped()
                    .onChange(of: geometry.size) {
                        imageSize = CGSize(
                            width: Util.minDim(geometry.size),
                            height: Util.minDim(geometry.size)
                        )
                    }
                    .onAppear {
                        imageSize = CGSize(
                            width: Util.minDim(geometry.size),
                            height: Util.minDim(geometry.size)
                        )
                    }
            }
            .scaledToFit()

            .frame(
                width: Util.minDim(imageSize),
                height: Util.minDim(imageSize)
            )
        }
    }
}

public struct Util {
    static func maxDim(_ size: CGSize) -> CGFloat {
        max(size.width, size.height)
    }

    static func minDim(_ size: CGSize) -> CGFloat {
        min(size.width, size.height)
    }

    static func imageRadius(systemImage: String) -> CGFloat {
        if systemImage.contains("circle") {
            return 1.0
        } else {
            #if canImport(UIKit)
                let imageSize = UIImage(systemName: systemImage)!.size
            #else
                let imageSize = NSImage(
                    systemSymbolName: systemImage,
                    accessibilityDescription: "TestImage"
                )!.size
            #endif

            let radius =
                (((imageSize.width) * (imageSize.width) + (imageSize.height)
                    * (imageSize.height))
                    .squareRoot()) / 2.0

            return radius
        }
    }

    /// Calculates the scale factor to apply to a specific system image, so it fits within the bounds of a circle.
    /// - Parameter systemImage: The name of the system image to be scaled.
    /// - Returns: The scale factor to be applied.
    public static func scaleFactor(systemImage: String) -> CGFloat {
        if systemImage.contains("circle") {
            return 1.01
        } else {
            #if canImport(UIKit)
                let imageSize = UIImage(systemName: systemImage)!.size
            #else
                let imageSize = NSImage(
                    systemSymbolName: systemImage,
                    accessibilityDescription: "TestImage"
                )!.size
            #endif

            return
                (maxDim(imageSize) / 2 / imageRadius(systemImage: systemImage))
                * 0.9
        }
    }

    public static func offsetFactor(systemImage: String) -> CGFloat {
        if systemImage.contains("circle") {
            return 0.0
        } else if systemImage.contains("triangle") {
            return -8.0
        } else {
            return 0.0
        }
    }
}

extension View {
    #if canImport(UIKit)
        public func squareImageView<S: Shape>(
            shape: S,
            background: Color = Color(uiColor: UIColor.systemBackground)
        ) -> some View {
            modifier(
                SquareImageViewModifier(shape: shape, background: background)
            )
        }
    #else
        public func squareImageView<S: Shape>(
            shape: S,
            background: Color = Color(nsColor: NSColor.windowBackgroundColor)
        ) -> some View {
            modifier(
                SquareImageViewModifier(shape: shape, background: background)
            )
        }
    #endif
}

#Preview {
    VStack {
        #if canImport(UIKit)
            Image(
                uiImage: UIImage(
                    named: "TestImage",
                    in: Bundle(for: ImageDataModel.self),
                    compatibleWith: nil
                )!
            )
            .resizable()
            .scaledToFit()

            Image(
                uiImage: UIImage(
                    named: "TestImage",
                    in: Bundle(for: ImageDataModel.self),
                    compatibleWith: nil
                )!
            )
            .resizable()
            .scaledToFill()
            .squareImageView(shape: Circle())
            .background(.yellow)
        #else
            Image(
                nsImage: Bundle(for: ImageDataModel.self).image(
                    forResource: "TestImage"
                )!
            )
            .resizable()
            .scaledToFit()

            Image(
                nsImage: Bundle(for: ImageDataModel.self).image(
                    forResource: "TestImage"
                )!
            )
            .resizable()
            .scaledToFill()
            .squareImageView(shape: Circle())
            .background(.yellow)
        #endif
        Image(systemName: "person")
            .resizable()
            .scaledToFit()
            .scaleEffect(0.7)
            .foregroundStyle(.white)
            .modifier(
                SquareImageViewModifier(shape: Circle(), background: .red)
            )
            //.background(.green)
            .border(.green)
    }
}
