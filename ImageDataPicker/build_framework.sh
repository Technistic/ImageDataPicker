#!/bin/sh

#  build_framework.sh
#  ImageDataPicker
#
#  Created by Michael Logothetis on 21/6/2025.
#  
# A shell script for creating an XCFramework for iOS.
#
# Credit: https://dev.to/erezhod/creating-a-swift-framework-the-practical-story-2jj4

FRAMEWORK_NAME="ImageDataPicker"

# Starting from a clean slate
# Removing the build and output folders
rm -rf ./build &&\
rm -rf ./output &&\
rm -rf ./framework/${FRAMEWORK_NAME}.xcframework

# Cleaning the workspace cache
xcodebuild \
    clean \
    -project "${FRAMEWORK_NAME}".xcodeproj \
    -scheme ${FRAMEWORK_NAME}

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
            -project "${FRAMEWORK_NAME}".xcodeproj \
            -scheme ${FRAMEWORK_NAME} \
            -configuration Release \
            -destination "generic/platform=${destination}" \
            -archivePath build/${FRAMEWORK_NAME}-${output_archive}.xcarchive
    
    archives="${archives} -archive build/${FRAMEWORK_NAME}-${output_archive}.xcarchive -framework ${FRAMEWORK_NAME}.framework"
done

# Create an archive for iOS simulators
# xcodebuild \
#     archive \
#         SKIP_INSTALL=NO \
#         BUILD_LIBRARY_FOR_DISTRIBUTION=YES \
#         -project "${FRAMEWORK_NAME}".xcodeproj \
#         -scheme ${FRAMEWORK_NAME} \
#         -configuration Release \
#         -destination "generic/platform=iOS Simulator" \
#         -archivePath build/${FRAMEWORK_NAME}-iOS_Simulator.xcarchive
        
# Create an archive for iOS simulators
# xcodebuild \
#     archive \
#         SKIP_INSTALL=NO \
#         BUILD_LIBRARY_FOR_DISTRIBUTION=YES \
#         -project "${FRAMEWORK_NAME}".xcodeproj \
#         -scheme ${FRAMEWORK_NAME} \
#         -configuration Release \
#         -destination "generic/platform=macOS" \
#         -archivePath build/${FRAMEWORK_NAME}-macOS.xcarchive

# Convert the archives to .framework
# and package them both into one xcframework
xcodebuild \
    -create-xcframework \
    -archive build/${FRAMEWORK_NAME}-iOS.xcarchive -framework ${FRAMEWORK_NAME}.framework \
    -archive build/${FRAMEWORK_NAME}-iOS_Simulator.xcarchive -framework ${FRAMEWORK_NAME}.framework \
    -archive build/${FRAMEWORK_NAME}-macOS.xcarchive -framework ${FRAMEWORK_NAME}.framework \
    -output framework/${FRAMEWORK_NAME}.xcframework &&\
    rm -rf build

codesign --timestamp -s "Apple Development: Michael Logothetis (J8XH79BD3A)" framework/${FRAMEWORK_NAME}.xcframework
