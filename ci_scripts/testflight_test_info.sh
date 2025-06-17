#!/bin/sh -e

#  testflight_test_info.sh
#  
#
#  Created by Michael Logothetis on 16/6/2025.
#  
echo "Setting up TestFlight test info"
echo "CI_APP_STORE_SIGNED_APP_PATH: $CI_APP_STORE_SIGNED_APP_PATH"
echo "CI_AD_HOC_SIGNED_APP_PATH: $CI_AD_HOC_SIGNED_APP_PATH"
echo "CI_DEVELOPMENT_SIGNED_APP_PATH: $CI_DEVELOPMENT_SIGNED_APP_PATH"

if [[ -d "$CI_APP_STORE_SIGNED_APP_PATH" || -d "$CI_AD_HOC_SIGNED_APP_PATH" || -d "$CI_DEVELOPMENT_SIGNED_APP_PATH" ]]; then
    TESTFLIGHT_DIR_PATH=../TestFlight
    mkdir -p $TESTFLIGHT_DIR_PATH
    git fetch --deepen 3 && git log -3 --pretty=format:"%s" >! $TESTFLIGHT_DIR_PATH/WhatToTest.en-US.txt
    git fetch --deepen 3 && git log -3 --pretty=format:"%s" >! $TESTFLIGHT_DIR_PATH/WhatToTest.en-AU.txt
    git fetch --deepen 3 && git log -3 --pretty=format:"%s" >! $TESTFLIGHT_DIR_PATH/WhatToTest.en-GB.txt
fi
