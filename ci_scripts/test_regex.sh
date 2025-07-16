#!/bin/sh
#
#  test_regex.sh
#
#
#  Created by Michael Logothetis on 16/6/2025.
#
#
#  Test the regex expression for matching CI_BRANCH and CI_TAG
#  and deriving version information.
#

set -e

CI_BRANCH="rc.4_v10.2.3"
CI_TAG="rc.4-v10.2.3"

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

echo "========================================"
echo "CI_TAG: $CI_TAG"
echo "CI_BRANCH: $CI_BRANCH"
echo "========================================"
echo "BRANCH: $BRANCH"
echo "VER_TYPE: $ver_type"
echo "BUILD: $build"
echo "MAJOR: $major"
echo "MINOR: $minor"
echo "PATCH: $patch"
echo "PRODUCT_VERSION: $product_version"
echo

#exit 0

TEST_BRANCHES=(
    alpha.1_v1.2.3
    alpha_v1.12.3
    beta.11_v1.2.3
    beta_v1.2.13
    rc.3_v1.2.3
    rc_v11.2.3
    production_v1.2.3
    production_v22.33.44
)

for TEST_BRANCH in "${TEST_BRANCHES[@]}"; do

    CI_BRANCH="$TEST_BRANCH"

    if [[ "$CI_BRANCH" =~ ^((alpha|beta|rc|production)?(\.{1}([[:digit:]]+))?)?[\-|_]?v([[:digit:]]+)\.([[:digit:]]+)\.([[:digit:]]+)$ ]]; then
         major=${BASH_REMATCH[5]}
         minor=${BASH_REMATCH[6]}
         patch=${BASH_REMATCH[7]}
         ver_type=${BASH_REMATCH[2]}
         build=${BASH_REMATCH[4]}
    else
         echo "Error: BRANCH/TAG $BRANCH does not match expected format."
    fi
    
    product_version="v${major}.${minor}.${patch}"

    if [[ -n "$ver_type" && "$ver_type" != 'production' ]]; then
        product_version="${product_version}-${ver_type}"
    fi

    if [[ -n "$build" ]]; then
        product_version="${product_version}.${build}"
    fi

    echo "========================================"
    echo "$CI_BRANCH"
    echo "========================================"
    echo "VER_TYPE: $ver_type"
    echo "BUILD: $build"
    echo "MAJOR: $major"
    echo "MINOR: $minor"
    echo "PATCH: $patch"
    echo "PRODUCT_VERSION: $product_version"
    echo

done

