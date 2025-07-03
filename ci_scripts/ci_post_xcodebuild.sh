#!/bin/sh

#  ci_post_xcodebuild.sh
#  ImageDataPicker
#
#  Created by Michael Logothetis on 26/5/2025.
#  


echo ""

if [[ $CI_XCODEBUILD_ACTION = 'archive' && $CI_PRODUCT_PLATFORM = 'iOS' ]];
then
    ./publish_github_pages.sh
fi
