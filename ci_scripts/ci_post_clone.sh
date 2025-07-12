#!/bin/zsh
#
#  ci_post_clone.sh
#  ImageDataPicker
#
#  Updated by Michael Logothetis on 11/07/2025.
#

set -e

function strip-v () { echo -n "${1#v}"; }
function strip-pre () { local x="${1#v}"; echo -n "${x%-*}"; }

# PLIST="${BUILT_PRODUCTS_DIR}/${INFOPLIST_PATH%.*}"

if [[ -d "${CI_PRIMARY_REPOSITORY_PATH}/.git" ]];
then

    COMMIT=$(git --git-dir="${CI_PRIMARY_REPOSITORY_PATH}/.git" rev-parse HEAD)

    LATEST=$(git describe --tags --abbrev=0 --match 'v[0-9]*' 2> /dev/null || true)
    STATIC="$(defaults read "${CI_PRIMARY_REPOSITORY_PATH}/${INFOPLIST_FILE}" "CFBundleShortVersionString" 2> /dev/null || true)"
    if [[ -n "$STATIC" ]] && [[ "$STATIC" != $(strip-pre "${LATEST}") ]];
    then
        echo "warning: CFBundleShortVersionString ${STATIC} disagrees with tag ${LATEST}"
    fi

    TAG=$(strip-pre $(git describe --tags --match 'v[0-9]*' --abbrev=0 --exact-match 2> /dev/null || true))
    FULL_VERSION=$(strip-v $(git describe --tags --match 'v[0-9]*' --always --dirty))
    BUILD=$(echo -n $(git rev-list HEAD | wc -l))
    if [[ "${FULL_VERSION}" == *"-dirty" ]];
    then
        echo "warning: There are uncommitted changes in Git"
        SHORT_VERSION="${FULL_VERSION}"
    else
        SHORT_VERSION="${TAG:-${FULL_VERSION}}"
    fi

    defaults write "${PLIST}" "CFBundleShortVersionString" -string "${SHORT_VERSION}"
    defaults write "${PLIST}" "CFBundleVersion"            -string "${BUILD}"
    defaults write "${PLIST}" "Commit"                     -string "${COMMIT}"

else

    echo "warning: Building outside Git. Leaving version number untouched."

fi

echo "CFBundleIdentifier:"         "$(defaults read "${PLIST}" CFBundleIdentifier)"
echo "CFBundleShortVersionString:" "$(defaults read "${PLIST}" CFBundleShortVersionString)"
echo "CFBundleVersion:"            "$(defaults read "${PLIST}" CFBundleVersion)"


echo "Configuring build for $CI_BRANCH"


# if [[ "$CI_BRANCH" =~ ^(alpha|beta)?-?v([[:digit:]]+)\.([[:digit:]]+)\.([[:digit:]]+) ]]; then
#     major=${BASH_REMATCH[2]}
#     minor=${BASH_REMATCH[3]}
#     patch=${BASH_REMATCH[4]}
#     ver_type=${BASH_REMATCH[1]}


echo $(security find-identity -v -p codesigning)

if [[ "$CI_BRANCH" =~ ^v([[:digit:]]+)\.([[:digit:]]+)\.([[:digit:]]+)-{1}(alpha|beta|rc)?(\.{1}([[:digit:]]+))?$ ]]; then
    major=${BASH_REMATCH[1]}
    minor=${BASH_REMATCH[2]}
    patch=${BASH_REMATCH[3]}
    ver_type=${BASH_REMATCH[4]}
    build=${BASH_REMATCH[6]}

    echo "Major: $major"
    echo "Minor: $minor"
    echo "Patch: $patch"
    echo "Type: $ver_type"
    echo "Build: $build"
else
    echo "Invalid Branch"
    exit 1
fi

if [[ -n "$ver_type" ]]; then
    echo "Copying $ver_type DocC Assets"
    cp -R $ver_type/* ${CI_PRIMARY_REPOSITORY_PATH}/ImageDataPicker/ImageDataPicker/ImageDataPicker.docc/Resources
    cp -R $ver_type/* ${CI_PRIMARY_REPOSITORY_PATH}/EmployeeFormExample/EmployeeFormExample/EmployeeFormExample.docc/Resources
fi

#  Update WhatToTest files if we are archiving.
if [[ $CI_XCODEBUILD_ACTION = 'archive' ]];
then
    ./testflight_test_info.sh
fi
