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
    @Test func frameworkConstantsExposeExpectedDefaults() {
        #expect(Constants.personPlaceholder == "person.fill")
        #expect(Constants.photoPlaceholder == "photo.fill")
        #expect(Constants.errorPlaceholder == "exclamationmark.circle.fill")
        #expect(buttonPosition == Constants.buttonPosition)
        #expect(Constants.buttonPosition > 0)
        #expect(Constants.buttonPosition < 1)
    }

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
    @Test func imageDataModelInitializesFromBindingValue() {
        var imageData: Data? = TestImageData.png
        let binding = Binding<Data?>(
            get: { imageData },
            set: { imageData = $0 }
        )

        let model = ImageDataModel(imageData: binding)

        switch model.imageState {
        case .success(let resolvedData):
            #expect(resolvedData == TestImageData.png)
        default:
            Issue.record("Expected success state when initialized from a binding with image data.")
        }
    }

    @MainActor
    @Test func imageDataModelRetainsExplicitInitialState() {
        let loadingState = ImageDataModel.ImageState.loading(
            Progress(totalUnitCount: 10)
        )
        let model = ImageDataModel(imageState: loadingState)

        #expect(model.imageState == loadingState)
    }

    @MainActor
    @Test func imageDataModelResetsToEmptyWhenSelectionClears() {
        let model = ImageDataModel(imageData: TestImageData.png)

        model.imageSelection = nil

        #expect(model.imageState == .empty)
    }

    @Test func imageStateEquatableMatchesAssociatedValues() {
        let matchingLoadingLhs = Progress(totalUnitCount: 1)
        let matchingLoadingRhs = Progress(totalUnitCount: 1)
        let differentLoading = Progress(totalUnitCount: 2)

        let sameFailureLhs = ImageDataModel.ImageState.failure(
            NSError(domain: "Example", code: 1, userInfo: [
                NSLocalizedDescriptionKey: "Same failure"
            ])
        )
        let sameFailureRhs = ImageDataModel.ImageState.failure(
            NSError(domain: "DifferentDomain", code: 99, userInfo: [
                NSLocalizedDescriptionKey: "Same failure"
            ])
        )
        let differentFailure = ImageDataModel.ImageState.failure(
            NSError(domain: "Example", code: 2, userInfo: [
                NSLocalizedDescriptionKey: "Different failure"
            ])
        )

        #expect(ImageDataModel.ImageState.empty == .empty)
        #expect(
            ImageDataModel.ImageState.loading(matchingLoadingLhs)
                == .loading(matchingLoadingRhs)
        )
        #expect(
            ImageDataModel.ImageState.loading(matchingLoadingLhs)
                != .loading(differentLoading)
        )
        #expect(ImageDataModel.ImageState.success(TestImageData.png) == .success(TestImageData.png))
        #expect(sameFailureLhs == sameFailureRhs)
        #expect(sameFailureLhs != differentFailure)
    }

    @Test func imageStateDescriptionMatchesCases() {
        #expect(ImageDataModel.ImageState.empty.description() == "empty")
        #expect(
            ImageDataModel.ImageState.loading(Progress(totalUnitCount: 1))
                .description() == "loading"
        )
        #expect(
            ImageDataModel.ImageState.success(TestImageData.png)
                .description() == "success"
        )
        #expect(
            ImageDataModel.ImageState.failure(TestFailureError.example)
                .description() == "failure"
        )
    }

    @Test func dataImageInitializerRejectsNilAndRetainsImageData() {
        #expect(ImageDataModel.DataImage(imageData: nil) == nil)

        let dataImage = ImageDataModel.DataImage(imageData: TestImageData.png)
        #expect(dataImage?.imageData == TestImageData.png)
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
    @Test func clippedImageStateViewRetainsInitializerValuesAndBuildsBody() {
        let view = ClippedImageStateView(
            imageState: .success(TestImageData.png),
            emptyPlaceholder: Constants.photoPlaceholder,
            errorPlaceholder: Constants.errorPlaceholder,
            clipShape: Circle()
        )

        switch view.imageState {
        case .success(let imageData):
            #expect(imageData == TestImageData.png)
        default:
            Issue.record("Expected success state to be retained by ClippedImageStateView.")
        }

        #expect((reflectedValue(named: "emptyPlaceholder", in: view) as? String) == Constants.photoPlaceholder)
        #expect((reflectedValue(named: "errorPlaceholder", in: view) as? String) == Constants.errorPlaceholder)
        #expect(reflectedValue(named: "clipShape", in: view) is Circle)

        let body = view.body
        #expect(String(describing: type(of: body)).isEmpty == false)
    }

    @MainActor
    @Test func imageDataPickerViewRetainsInitializerValues() {
        var imageData: Data? = TestImageData.png
        let binding = Binding<Data?>(
            get: { imageData },
            set: { imageData = $0 }
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
    }

    @MainActor
    @Test func imageDataPickerViewSizingHelpersUseProvidedSize() {
        var imageData: Data? = nil
        let binding = Binding<Data?>(
            get: { imageData },
            set: { imageData = $0 }
        )
        let view = ImageDataPickerView(
            imageData: binding,
            clipShape: Circle()
        )

        let size = CGSize(width: 200, height: 120)
        #expect(view.ratio(size: size) == 120)
        #expect(view.bsize(size: size) == 24)
    }

    @Test func symbolLayoutHelpersReturnExpectedValues() {
        let size = CGSize(width: 320, height: 180)

        #expect(SymbolLayoutHelper.maxDim(size) == 320)
        #expect(SymbolLayoutHelper.minDim(size) == 180)
        #expect(SymbolLayoutHelper.scaleFactor(systemImage: "person.circle") == 1.0)
        #expect(SymbolLayoutHelper.offsetFactor(systemImage: "person.circle") == 0.0)
        #expect(SymbolLayoutHelper.offsetFactor(systemImage: "exclamationmark.triangle") == -3.0)

        let photoScaleFactor = SymbolLayoutHelper.scaleFactor(
            systemImage: Constants.photoPlaceholder
        )
        #expect(photoScaleFactor > 0)
        #expect(photoScaleFactor <= 1)
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
