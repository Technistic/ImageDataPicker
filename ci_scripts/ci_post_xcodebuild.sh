#!/bin/sh

#  ci_post_xcodebuild.sh
#  ImageDataPicker
#
#  Created by Michael Logothetis on 26/5/2025.
#  


#  Publish DocC documentation to GitHub Pages if there is a TAG change or manually triggered workflow.
if [[ -n "$CI_TAG" || ("$CI_WORKFLOW" = "Publish-Pages" && ("$CI_START_CONDITION" = "manual" || "$CI_START_CONDITION" = "manual_rebuild")) ]]; then

    #  Only publish GitHub Pages for iOS archive builds.
    if [[ $CI_XCODEBUILD_ACTION = 'archive' && $CI_PRODUCT_PLATFORM = 'iOS' ]]; then
        ./publish_github_pages.sh
    fi
fi
