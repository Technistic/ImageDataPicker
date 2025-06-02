#!/bin/sh

#  ci_post_xcodebuild.sh
#  MySwiftTestPackage
#
#  Created by Michael Logothetis on 26/5/2025.
#  

rm -rf docsData

echo "Building DocC documentation for ImageDataPicker"

if [[ $CI_XCODEBUILD_ACTION = 'build' && $CI_PRODUCT_PLATFORM = 'iOS' ]]; then
    
then
xcodebuild -workspace $CI_WORKSPACE/ImageDataPicker.xcworkspace -derivedDataPath docsData -scheme EmployeeFormExample -destination 'platform=iOS Simulator,name=iPhone 16' -parallelizeTargets docbuild
xcodebuild -workspace $CI_WORKSPACE/ImageDataPicker.xcworkspace -derivedDataPath docsData -scheme ImageDataPicker -destination 'platform=iOS Simulator,name=iPhone 16' -parallelizeTargets docbuild

echo "Copying DocC archives to doc_archives..."
mkdir $CI_WORKSPACE/doc_archives
cp -R `find docsData -type d -name "*.doccarchive"` $CI_WORKSPACE/doc_archives

mkdir $CI_WORKSPACE/docs

for ARCHIVE in $CI_WORKSPACE/doc_archives/*.doccarchive; do
    cmd() {
        echo "$ARCHIVE" | awk -F'.' '{print $1}' | awk -F'/' '{print tolower($2)}'
    }
    ARCHIVE_NAME="$(cmd)"
    echo "Processing Archive: $ARCHIVE"
    $(xcrun --find docc) process-archive transform-for-static-hosting "$ARCHIVE" --hosting-base-path ImageDataPicker/$ARCHIVE_NAME --output-path $CI_WORKSPACE/docs/$ARCHIVE_NAME
done

./ci_site_deploy.sh
fi
