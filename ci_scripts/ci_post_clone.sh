#!/bin/zsh
#
#  ci_post_clone.sh
#  ImageDataPicker
#
#  Updated by Michael Logothetis on 13/7/2025.
#

set -e

# Exit workflow if this is a draft PR.
./check_draft_pr.sh

#  Update WhatToTest files when creating an archive.
if [[ $CI_XCODEBUILD_ACTION = 'archive' ]];
then
    ./testflight_test_info.sh
fi
