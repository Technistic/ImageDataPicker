#!/bin/sh
#
#  get_version_from_branch.sh
#  
#
#  Created by Michael Logothetis on 13/7/2025.
#
#
#  Set the marketing version and build type based on the branch or tag name.
#
#  Branch names should follow the format:
#    [TYPE(.BUILD)]-vMAJOR.MINOR.PATCH
#
#  features/featureA -> No Xcode Cloud Build
#  bugs/bugA -> No Xcode Cloud Build
#  alpha.2-v1.2.3 -> v1.2.3-alpha.2 (Xcode Cloud Integration Build)
#  beta.1-v1.2.3 -> v1.2.3-beta.1 (Xcode Cloud Staging Build)
#  rc.1-v1.2.3 -> v1.2.3-rc.1 (Xcode Cloud Release Candidate Build)
#  v1.2.3 -> v1.2.3 (Xcode Cloud Production Build)

set -e

if [[ -n "$CI_TAG" ]]; then
    # $CI_TAG should match the branch name.
    if [[ -n "$CI_BRANCH" && "$CI_TAG" != "$CI_BRANCH" ]]; then
        echo "Error: CI_TAG $CI_TAG does not match CI_BRANCH ${CI_BRANCH}."
        exit 1
    fi
fi

# For a PR targeting a branch, we use the target branch as the version branch.
if [[ -n "$CI_PULL_REQUEST_TARGET_BRANCH" ]]; then
    BRANCH="$CI_PULL_REQUEST_TARGET_BRANCH"
else
    BRANCH="$CI_BRANCH"
fi

# As CI_TAG must match CI_BRANCH, we derive the version from BRANCH.
if [[ -n "$BRANCH" ]]; then
    if [[ "$BRANCH" =~ ^((alpha|beta|rc)?(\.{1}([[:digit:]]+))?)?\-?v([[:digit:]]+)\.([[:digit:]]+)\.([[:digit:]]+)$ ]]; then
        major=${BASH_REMATCH[5]}
        minor=${BASH_REMATCH[6]}
        patch=${BASH_REMATCH[7]}
        ver_type=${BASH_REMATCH[2]}
        build=${BASH_REMATCH[4]}
    else
        echo "Error: BRANCH $BRANCH does not match expected format."
        exit 1
    fi
else
    echo "Error: BRANCH undefined."
    exit 1
fi

echo "CI_TAG: $CI_TAG"
echo "CI_BRANCH: $BRANCH"
echo "CI_PULL_REQUEST_SOURCE_BRANCH: $CI_PULL_REQUEST_SOURCE_BRANCH"
echo "CI_PULL_REQUEST_TARGET_BRANCH: $CI_PULL_REQUEST_TARGET_BRANCH"
echo
echo "BRANCH: $BRANCH"
echo "VER_TYPE: $ver_type"
echo "BUILD: $build"
echo "MAJOR: $major"
echo "MINOR: $minor"
echo "PATCH: $patch"
