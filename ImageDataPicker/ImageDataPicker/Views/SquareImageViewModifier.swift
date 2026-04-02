//
//  SquareImageViewModifier.swift
//  A view modifier that presents content in a clipped square frame.
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

/// A view modifier that constrains content to a square and clips it to a supplied shape.
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
                let side = SymbolLayoutHelper.minDim(geometry.size)
                content
                    .frame(width: side, height: side)
                    .background(background)
                    .clipShape(shape)
                    .clipped()
                    .onChange(of: geometry.size) {
                        imageSize = CGSize(
                            width: SymbolLayoutHelper.minDim(geometry.size),
                            height: SymbolLayoutHelper.minDim(geometry.size)
                        )
                    }
                    .onAppear {
                        imageSize = CGSize(
                            width: SymbolLayoutHelper.minDim(geometry.size),
                            height: SymbolLayoutHelper.minDim(geometry.size)
                        )
                    }
            }
            .scaledToFit()

            .frame(
                width: SymbolLayoutHelper.minDim(imageSize),
                height: SymbolLayoutHelper.minDim(imageSize)
            )
        }
    }
}

/// Helper functions used to size and position SF Symbols inside clipped image placeholders.
public struct SymbolLayoutHelper {
    /// Returns the maximum dimension (width or height) of a given CGSize.
    /// - Parameter size: The CGSize to evaluate.
    /// - Returns: The larger of the width or height of the CGSize.
    static func maxDim(_ size: CGSize) -> CGFloat {
        max(size.width, size.height)
    }
    
    /// Returns the minimum dimension (width or height) of a given CGSize.
    /// - Parameter size: The CGSize to evaluate.
    /// - Returns: The smaller of the width or height of the CGSize.
    static func minDim(_ size: CGSize) -> CGFloat {
        min(size.width, size.height)
    }
    
    /// Calculates the radius of the smallest circle that contains the supplied symbol image.
    /// - Parameter systemImage: The SF Symbol name to measure.
    /// - Returns: The radius needed to contain the symbol.
    static func imageRadius(systemImage: String) -> CGFloat {
        if systemImage.contains("circle") {
            return 1.0
        } else {
            #if canImport(UIKit)
                guard let image = UIImage(systemName: systemImage) else {
                    return 1.0
                }
                let imageSize = image.size
            #else
                guard let image = NSImage(
                    systemSymbolName: systemImage,
                    accessibilityDescription: "System image"
                ) else {
                    return 1.0
                }
                let imageSize = image.size
            #endif
            let radius = (
                (imageSize.width * imageSize.width + imageSize.height * imageSize.height)
                .squareRoot()
            ) / 2.0

            return radius
        }
    }

    /// Calculates a scale factor that helps an SF Symbol fit visually inside a circular placeholder.
    /// - Parameter systemImage: The SF Symbol name to scale.
    /// - Returns: A scale factor for the symbol.
    public static func scaleFactor(systemImage: String) -> CGFloat {
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

            return
                (maxDim(imageSize) / 2 / imageRadius(systemImage: systemImage))
                * 0.9
        }
    }
    
    /// Calculates a vertical offset used to visually center some SF Symbols in circular placeholders.
    /// - Parameter systemImage: The SF Symbol name to position.
    /// - Returns: A vertical offset for the symbol.
    public static func offsetFactor(systemImage: String) -> CGFloat {
        if systemImage.contains("circle") {
            return 0.0
        } else if systemImage.contains("triangle") {
            return -3.0
        } else {
            return 0.0
        }
    }
}

extension View {
#if canImport(UIKit)
    /// A `View` extension that applies the ``SquareImageViewModifier`` .
    /// - Parameters:
    ///   - shape: The `Shape` to which the view will be clipped.
    ///   - background: The background color to apply behind the clipped shape. Default is the system background color.
    /// - Returns: A view modified to have a square aspect ratio, clipped to the specified shape, and with the specified background color.
        public func squareImageView<S: Shape>(
            shape: S,
            background: Color = Color(uiColor: UIColor.systemBackground)
        ) -> some View {
            modifier(
                SquareImageViewModifier(shape: shape, background: background)
            )
        }
#else
    /// A `View` extension that applies the ``SquareImageViewModifier`` .
    /// - Parameters:
    ///   - shape: The `Shape` to which the view will be clipped.
    ///   - background: The background color to apply behind the clipped shape. Default is the window background color.
    /// - Returns:  A view modified to have a square aspect ratio, clipped to the specified shape, and with the specified background color.
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
            .background(.green, ignoresSafeAreaEdges: [])
            //.border(.green)
    }
}
