#!/bin/sh

#  ci_post_xcodebuild.sh
#  ImageDataPicker
#
#  Created by Michael Logothetis on 26/5/2025.
#  

rm -rf docsData

echo "Building DocC documentation for ImageDataPicker"

if [[ $CI_XCODEBUILD_ACTION = 'build' && $CI_PRODUCT_PLATFORM = 'iOS' ]];
then
xcodebuild -workspace $CI_PRIMARY_REPOSITORY_PATH/ImageDataPicker.xcworkspace -derivedDataPath $CI_WORKSPACE_PATH/docsData -scheme EmployeeFormExample -destination 'platform=iOS Simulator,name=iPhone 16' -parallelizeTargets docbuild
# xcodebuild -workspace $CI_PRIMARY_REPOSITORY_PATH/ImageDataPicker.xcworkspace -derivedDataPath docsData -scheme ImageDataPicker -destination 'platform=iOS Simulator,name=iPhone 16' -parallelizeTargets docbuild

echo "Copying DocC archives to doc_archives..."
mkdir $CI_WORKSPACE_PATH/doc_archives
cp -R `find $CI_WORKSPACE_PATH/docsData -type d -name "*.doccarchive"` $CI_WORKSPACE_PATH/doc_archives

mkdir $CI_PRIMARY_REPOSITORY_PATH/docs

for ARCHIVE in $CI_WORKSPACE_PATH/doc_archives/*.doccarchive; do
    cmd() {
        echo "$ARCHIVE" | awk -F'.' '{print $1}' | awk -F'/' '{print tolower($5)}'
    }
    ARCHIVE_NAME="$(cmd)"
    echo "Processing Archive: $ARCHIVE"
    $(xcrun --find docc) process-archive transform-for-static-hosting "$ARCHIVE" --hosting-base-path ImageDataPicker/$ARCHIVE_NAME --output-path $CI_PRIMARY_REPOSITORY_PATH/docs/$ARCHIVE_NAME
done

./ci_site_deploy.sh

fi
