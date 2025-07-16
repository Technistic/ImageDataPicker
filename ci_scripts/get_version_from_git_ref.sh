#!/bin/sh
#
#  get_version_from_git_ref.sh
#
#
#  Updated by Michael Logothetis on 16/7/2025.
#
#
#  Set the marketing version and build type based on the branch or tag name.
#
#  Branch names should follow the format:
#    [TYPE(.BUILD)]_vMAJOR.MINOR.PATCH
#
#  Tag names should follow the format:
#    [TYPE(.BUILD)]-vMAJOR.MINOR.PATCH
#
#
#  Example Branch Names:
#  features-featureA -> No Xcode Cloud Build
#  bugs-bugA -> No Xcode Cloud Build
#  alpha.2_v1.2.3 -> v1.2.3-alpha.2 (Xcode Cloud Integration Build)
#  beta.1_v1.2.3 -> v1.2.3-beta.1 (Xcode Cloud Staging Build)
#  rc.1_v1.2.3 -> v1.2.3-rc.1 (Xcode Cloud Release Candidate Build)
#  production_v1.2.3 -> v1.2.3 (Xcode Cloud Production Build)
#
#  Example Tag Names:
#  alpha.2-v1.2.3 -> v1.2.3-alpha.2 (Xcode Cloud Integration Release)
#  beta.1-v1.2.3 -> v1.2.3-beta.1 (Xcode Cloud Staging Release)
#  rc.1-v1.2.3 -> v1.2.3-rc.1 (Xcode Cloud Release Candidate)
#  v1.2.3 -> v1.2.3 (Xcode Cloud Production Release)
#

set -e

if [[ -n "$CI_TAG" ]]; then
    # $CI_TAG should align with the branch name.
    BRANCH=$(echo $"$CI_TAG" | tr '-' '_')
    if [[ "$CI_TAG" =~ ^v ]]; then
        BRANCH="production_${BRANCH}"
    fi
else
    # For a PR targeting a branch, we use the target branch as the version branch.
    if [[ -n "$CI_PULL_REQUEST_TARGET_BRANCH" ]]; then
        BRANCH="$CI_PULL_REQUEST_TARGET_BRANCH"
    else
        BRANCH="$CI_BRANCH"
    fi
fi

# As CI_TAG must match CI_BRANCH, we derive the version from BRANCH.
if [[ -n "$BRANCH" ]]; then
    if [[ "$BRANCH" =~ ^((alpha|beta|rc|production)?(\.{1}([[:digit:]]+))?)?[\-|_]?v([[:digit:]]+)\.([[:digit:]]+)\.([[:digit:]]+)$ ]]; then
        major=${BASH_REMATCH[5]}
        minor=${BASH_REMATCH[6]}
        patch=${BASH_REMATCH[7]}
        ver_type=${BASH_REMATCH[2]}
        build=${BASH_REMATCH[4]}
    else
        echo "Error: BRANCH/TAG $BRANCH does not match expected format."
        exit 1
    fi
else
    echo "Error: BRANCH undefined."
    exit 1
fi

product_version="v${major}.${minor}.${patch}"

if [[ -n "$ver_type" && "$ver_type" != 'production' ]]; then
    product_version="${product_version}-${ver_type}"
fi

if [[ -n "$build" ]]; then
    product_version="${product_version}.${build}"
fi

echo "CI_TAG: $CI_TAG"
echo "CI_BRANCH: $CI_BRANCH"
echo "CI_PULL_REQUEST_SOURCE_BRANCH: $CI_PULL_REQUEST_SOURCE_BRANCH"
echo "CI_PULL_REQUEST_TARGET_BRANCH: $CI_PULL_REQUEST_TARGET_BRANCH"
echo
echo "BRANCH: $BRANCH"
echo "VER_TYPE: $ver_type"
echo "BUILD: $build"
echo "MAJOR: $major"
echo "MINOR: $minor"
echo "PATCH: $patch"
echo "PRODUCT_VERSION: $product_version"
