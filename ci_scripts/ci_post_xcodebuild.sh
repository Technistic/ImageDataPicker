#!/bin/sh

#  ci_post_xcodebuild.sh
#  MySwiftTestPackage
#
#  Created by Michael Logothetis on 26/5/2025.
#  

rm -rf docsData

echo "Building DocC documentation for ImageDataPicker"

xcodebuild -workspace ../ImageDataPicker.xcworkspace -derivedDataPath docsData -scheme EmployeeFormExample -destination 'platform=iOS Simulator,name=iPhone 16' -parallelizeTargets docbuild
xcodebuild -workspace ../ImageDataPicker.xcworkspace -derivedDataPath docsData -scheme ImageDataPicker -destination 'platform=iOS Simulator,name=iPhone 16' -parallelizeTargets docbuild

echo "Copying DocC archives to doc_archives..."
mkdir ../doc_archives
cp -R `find docsData -type d -name "*.doccarchive"` ../doc_archives

mkdir ../docs

for ARCHIVE in ../doc_archives/*.doccarchive; do
    cmd() {
        echo "$ARCHIVE" | awk -F'.' '{print $1}' | awk -F'/' '{print tolower($2)}'
    }
    ARCHIVE_NAME="$(cmd)"
    echo "Processing Archive: $ARCHIVE"
    $(xcrun --find docc) process-archive transform-for-static-hosting "$ARCHIVE" --hosting-base-path ImageDataPicker/$ARCHIVE_NAME --output-path ../docs/$ARCHIVE_NAME
done

./ci_site_deploy.sh
