#!/bin/bash

#  build_framework.sh
#  ImageDataPicker
#
#  Created by Michael Logothetis on 21/6/2025.
#  
# A shell script for creating an XCFramework for iOS.
#
# Credit: https://dev.to/erezhod/creating-a-swift-framework-the-practical-story-2jj4

set -euo pipefail

FRAMEWORK_NAME="ImageDataPicker"
FRAMEWORK_PROJECT="../${FRAMEWORK_NAME}/${FRAMEWORK_NAME}.xcodeproj"

. ./get_version_from_git_ref.sh

case "${release_channel}" in
    alpha)
        FRAMEWORK_SCHEME="ImageDataPicker-alpha"
        ;;
    beta)
        FRAMEWORK_SCHEME="ImageDataPicker-beta"
        ;;
    *)
        FRAMEWORK_SCHEME="ImageDataPicker"
        ;;
esac

echo "Building ${FRAMEWORK_NAME} using scheme ${FRAMEWORK_SCHEME} for ${release_channel}."

# Starting from a clean slate
# Removing the build and output folders
rm -rf "${CI_WORKSPACE_PATH}/build" &&\
rm -rf "${CI_WORKSPACE_PATH}/framework/${FRAMEWORK_NAME}.xcframework"

# Cleaning the workspace cache
xcodebuild \
    clean \
    -project "${FRAMEWORK_PROJECT}" \
    -scheme "${FRAMEWORK_SCHEME}"

destinations=('iOS' 'iOS Simulator' 'macOS')
archives=""

# Create an archive for iOS devices
for destination in "${destinations[@]}"; do
    echo "Creating archive for ${destination}..."
    
    output_archive=$(echo "${destination}" | tr ' ' '_')

    xcodebuild \
        archive \
            SKIP_INSTALL=NO \
            BUILD_LIBRARY_FOR_DISTRIBUTION=YES \
            -project "${FRAMEWORK_PROJECT}" \
            -scheme "${FRAMEWORK_SCHEME}" \
            -destination "generic/platform=${destination}" \
            -archivePath "${CI_WORKSPACE_PATH}/build/${FRAMEWORK_NAME}-${output_archive}.xcarchive"
done

# Convert the archives to .framework
# and package them both into one xcframework
xcodebuild \
    -create-xcframework \
    -archive "${CI_WORKSPACE_PATH}/build/${FRAMEWORK_NAME}-iOS.xcarchive" -framework "${FRAMEWORK_NAME}.framework" \
    -archive "${CI_WORKSPACE_PATH}/build/${FRAMEWORK_NAME}-iOS_Simulator.xcarchive" -framework "${FRAMEWORK_NAME}.framework" \
    -archive "${CI_WORKSPACE_PATH}/build/${FRAMEWORK_NAME}-macOS.xcarchive" -framework "${FRAMEWORK_NAME}.framework" \
    -output "${CI_WORKSPACE_PATH}/framework/${FRAMEWORK_NAME}.xcframework" &&\
    rm -rf build

# Update the Info.plist file for the xcframework
#
# Uncomment the following lines to modify the Info.plist file prior to signing.
# However, the following keys are not required for the xcframework bundle type.
#
# plutil -insert CFBundleName -string ImageDataPicker ${CI_WORKSPACE_PATH}/framework/${FRAMEWORK_NAME}.xcframework/Info.plist
# plutil -insert CFBundleShortVersionString -string $major.$minor.$patch ${CI_WORKSPACE_PATH}/framework/${FRAMEWORK_NAME}.xcframework/Info.plist
# plutil -insert CFBundleVersion -string $major.$minor.$patch ${CI_WORKSPACE_PATH}/framework/${FRAMEWORK_NAME}.xcframework/Info.plist
# plutil -insert CFBundleIdentifier -string com.technistic.ImageDataPicker ${CI_WORKSPACE_PATH}/framework/${FRAMEWORK_NAME}.xcframework/Info.plist
# plutil -insert CFBundleExecutable -string ImageDataPicker ${CI_WORKSPACE_PATH}/framework/${FRAMEWORK_NAME}.xcframework/Info.plist

if [[ -n "${XCFRAMEWORK_SIGNING_IDENTITY}" ]]; then
    codesign --timestamp -s "${XCFRAMEWORK_SIGNING_IDENTITY}" "${CI_WORKSPACE_PATH}/framework/${FRAMEWORK_NAME}.xcframework"
fi

ls -l "${CI_WORKSPACE_PATH}/framework/${FRAMEWORK_NAME}.xcframework"
