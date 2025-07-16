#!/bin/sh

set -e

CI_BRANCH="rc.4-v10.2.3"
CI_TAG="rc.4-v10.2.3"

if [[ -n "$CI_TAG" ]]; then
    # $CI_TAG should match the branch name.
    if [[ -n "$CI_BRANCH" && "$CI_TAG" != "$CI_BRANCH" ]]; then
        echo "Error: CI_TAG $CI_TAG does not match CI_BRANCH ${CI_BRANCH}."
        exit 1
    fi
fi

# As CI_TAG must match CI_BRANCH, we derive the version from CI_BRANCH.
if [[ -n "$CI_BRANCH" ]]; then
    if [[ "$CI_BRANCH" =~ ^((alpha|beta|rc)?(\.{1}([[:digit:]]+))?)?\-?v([[:digit:]]+)\.([[:digit:]]+)\.([[:digit:]]+)$ ]]; then
        major=${BASH_REMATCH[5]}
        minor=${BASH_REMATCH[6]}
        patch=${BASH_REMATCH[7]}
        ver_type=${BASH_REMATCH[2]}
        build=${BASH_REMATCH[4]}
    else
        echo "Error: BRANCH $CI_BRANCH does not match expected format."
        exit 1
    fi
else
    echo "Error: CI_BRANCH undefined."
    exit 1
fi

echo "CI_TAG: $CI_TAG"
echo "CI_BRANCH: $CI_BRANCH"
echo "VER_TYPE: $ver_type"
echo "BUILD: $build"
echo "MAJOR: $major"
echo "MINOR: $minor"
echo "PATCH: $patch"

exit 0 

BRANCHES=(
    alpha.1-v1.2.3
    alpha-v1.12.3
    beta.11-v1.2.3
    beta-v1.2.13
    rc.3-v1.2.3
    rc-v11.2.3
    v1.2.3	
    v22.33.44
)

for BRANCH in "${BRANCHES[@]}"; do

    CI_BRANCH="$BRANCH"

    if [[ "$CI_BRANCH" =~ ^((alpha|beta|rc)?(\.{1}([[:digit:]]+))?)?\-?v([[:digit:]]+)\.([[:digit:]]+)\.([[:digit:]]+)$ ]]; then
         major=${BASH_REMATCH[5]}
         minor=${BASH_REMATCH[6]}
         patch=${BASH_REMATCH[7]}
         ver_type=${BASH_REMATCH[2]}
         build=${BASH_REMATCH[4]}
    else
         echo "No Match"
    fi

    echo "$CI_BRANCH"
    echo "VER_TYPE: $ver_type"
    echo "BUILD: $build"
    echo "MAJOR: $major"
    echo "MINOR: $minor"
    echo "PATCH: $patch"

done

