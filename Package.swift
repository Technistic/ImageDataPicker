// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "ImageDataPicker",
    platforms: [
        .iOS(.v17),
        .macOS(.v14),
        .visionOS(.v1),
    ],
    products: [
        .library(
            name: "ImageDataPicker",
            targets: ["ImageDataPicker"]
        ),
    ],
    targets: [
        .target(
            name: "ImageDataPicker",
            path: "ImageDataPicker/ImageDataPicker",
            exclude: [
                "Development Assets",
                "ImageDataPicker.docc",
                "Media.xcassets",
            ]
        ),
        .testTarget(
            name: "ImageDataPickerTests",
            dependencies: ["ImageDataPicker"],
            path: "ImageDataPicker/ImageDataPickerPackageTests"
        ),
    ]
)
