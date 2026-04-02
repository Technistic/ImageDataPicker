//
//  ImageDataPickerTests.swift
//  Test suite for the ImageDataPicker framework.
//
//  Created by Michael Logothetis on 30/04/2025.
//
//  MIT License
//  Copyright (c) 2025 Michael Logothetis (Technistic Pty Ltd)
//

import SwiftUI
import Testing

@testable import ImageDataPicker

struct ImageDataPickerTests {

    @MainActor
    @Test func imageDataModelInitializesEmptyStateFromNilImageData() {
        let model = ImageDataModel(imageData: nil)

        #expect(model.imageState == .empty)
    }

    @MainActor
    @Test func imageDataModelInitializesSuccessStateFromImageData() {
        let model = ImageDataModel(imageData: TestImageData.png)

        switch model.imageState {
        case .success(let imageData):
            #expect(imageData == TestImageData.png)
        default:
            Issue.record("Expected success state when initialized with image data.")
        }
    }

    @MainActor
    @Test func imageDataModelResetsToEmptyWhenSelectionClears() {
        let model = ImageDataModel(imageData: TestImageData.png)

        model.imageSelection = nil

        #expect(model.imageState == .empty)
    }

    @MainActor
    @Test func imageDataModelUsesIdentityForEqualityAndHashing() {
        let model = ImageDataModel(imageData: TestImageData.png)
        let sameReference = model
        let differentReference = ImageDataModel(imageData: TestImageData.png)

        #expect(model == sameReference)
        #expect(model != differentReference)
        #expect(model.hashValue == sameReference.hashValue)
    }

    @MainActor
    @Test func imageDataViewRetainsInitializerValuesAndBuildsBody() {
        let view = ImageDataView(
            imageData: TestImageData.png,
            placeholder: Constants.photoPlaceholder
        )

        #expect(view.imageData == TestImageData.png)
        #expect((reflectedValue(named: "placeholder", in: view) as? String) == Constants.photoPlaceholder)

        let body = view.body
        #expect(String(describing: type(of: body)).isEmpty == false)
    }

    @MainActor
    @Test func imageStateViewRetainsInitializerValuesAndBuildsBody() {
        let view = ImageStateView(
            imageState: .failure(TestFailureError.example),
            emptyPlaceholder: Constants.photoPlaceholder,
            errorPlaceholder: Constants.errorPlaceholder
        )

        switch view.imageState {
        case .failure(let error as TestFailureError):
            #expect(error == .example)
        default:
            Issue.record("Expected failure state to be retained by ImageStateView.")
        }

        #expect((reflectedValue(named: "emptyPlaceholder", in: view) as? String) == Constants.photoPlaceholder)
        #expect((reflectedValue(named: "errorPlaceholder", in: view) as? String) == Constants.errorPlaceholder)

        let body = view.body
        #expect(String(describing: type(of: body)).isEmpty == false)
    }

    @MainActor
    @Test func imageDataPickerViewRetainsInitializerValuesAndBuildsBody() {
        var imageData = TestImageData.png
        let binding = Binding<Data?>(
            get: { imageData },
            set: { imageData = $0! }
        )

        let view = ImageDataPickerView(
            imageData: binding,
            emptyPlaceholderImageName: Constants.photoPlaceholder,
            errorPlaceholderImageName: Constants.errorPlaceholder,
            clipShape: Circle()
        )

        #expect((reflectedValue(named: "emptyPlaceholderImageName", in: view) as? String) == Constants.photoPlaceholder)
        #expect((reflectedValue(named: "errorPlaceholderImageName", in: view) as? String) == Constants.errorPlaceholder)
        #expect(reflectedValue(named: "clipShape", in: view) is Circle)

        let body = view.body
        #expect(String(describing: type(of: body)).isEmpty == false)
    }
}

private enum TestFailureError: Error, Equatable {
    case example
}

private enum TestImageData {
    static let png = Data(
        base64Encoded:
            "iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mP8/x8AAusB9sXl16sAAAAASUVORK5CYII="
    )!
}

private func reflectedValue<T>(named name: String, in subject: T) -> Any? {
    Mirror(reflecting: subject).children.first(where: { $0.label == name })?.value
}
