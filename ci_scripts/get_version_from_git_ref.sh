#!/bin/bash
#
#  get_version_from_git_ref.sh
#
#
#  Updated by Michael Logothetis on 16/7/2025.
#
#
#  Set the marketing version and release channel based on the branch or tag name.
#
#  Branch names should follow the format:
#    CHANNEL_vMAJOR.MINOR.PATCH
#
#  Tag names should follow the format:
#    CHANNEL-vMAJOR.MINOR.PATCH
#
#
#  Example Branch Names:
#  alpha_v1.2.3 -> Alpha release channel build
#  beta_v1.2.3 -> Beta release channel build
#  main -> Production release channel build
#
#  Example Tag Names:
#  alpha-v1.2.3 -> Alpha prerelease publication
#  beta-v1.2.3 -> Beta prerelease publication
#  v1.2.3 -> Production release publication
#

set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
repo_root="${CI_PRIMARY_REPOSITORY_PATH:-$(cd "${script_dir}/.." && pwd)}"

framework_version_file="${repo_root}/ImageDataPicker/Configuration/BundleConfig.xcconfig"
sample_version_file="${repo_root}/EmployeeFormExample/Configuration/BundleConfig.xcconfig"

read_marketing_version() {
    local file_path="$1"
    sed -nE 's/^[[:space:]]*MARKETING_VERSION[[:space:]]*=[[:space:]]*([0-9]+\.[0-9]+\.[0-9]+)[[:space:]]*$/\1/p' "$file_path" | head -n 1
}

validate_repo_versions() {
    local framework_version
    local sample_version

    framework_version="$(read_marketing_version "$framework_version_file")"
    sample_version="$(read_marketing_version "$sample_version_file")"

    if [[ -z "$framework_version" || -z "$sample_version" ]]; then
        echo "Error: Unable to read MARKETING_VERSION from project configuration."
        exit 1
    fi

    if [[ "$framework_version" != "$sample_version" ]]; then
        echo "Error: MARKETING_VERSION mismatch between framework ($framework_version) and sample app ($sample_version)."
        exit 1
    fi

    repo_marketing_version="$framework_version"
}

CI_TAG="${CI_TAG:-}"
CI_BRANCH="${CI_BRANCH:-}"
CI_PULL_REQUEST_SOURCE_BRANCH="${CI_PULL_REQUEST_SOURCE_BRANCH:-}"
CI_PULL_REQUEST_TARGET_BRANCH="${CI_PULL_REQUEST_TARGET_BRANCH:-}"
CI_PRODUCTION_BRANCH="${CI_PRODUCTION_BRANCH:-main}"

if [[ -n "$CI_TAG" ]]; then
    # $CI_TAG should align with the branch name.
    BRANCH=$(echo "$CI_TAG" | tr '-' '_')
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
    if [[ "$BRANCH" == "$CI_PRODUCTION_BRANCH" ]]; then
        validate_repo_versions
        if [[ "$repo_marketing_version" =~ ^([[:digit:]]+)\.([[:digit:]]+)\.([[:digit:]]+)$ ]]; then
            major=${BASH_REMATCH[1]}
            minor=${BASH_REMATCH[2]}
            patch=${BASH_REMATCH[3]}
            ver_type=""
            build=""
            release_channel="production"
            prerelease="false"
            tag_name="v${major}.${minor}.${patch}"
        else
            echo "Error: Repository MARKETING_VERSION $repo_marketing_version does not match expected semantic version format."
            exit 1
        fi
    elif [[ "$BRANCH" =~ ^((alpha|beta|rc)?(\.{1}([[:digit:]]+))?)?[\-|_]?v([[:digit:]]+)\.([[:digit:]]+)\.([[:digit:]]+)$ ]]; then
        major=${BASH_REMATCH[5]}
        minor=${BASH_REMATCH[6]}
        patch=${BASH_REMATCH[7]}
        ver_type=${BASH_REMATCH[2]}
        build=${BASH_REMATCH[4]}

        validate_repo_versions
        branch_version="${major}.${minor}.${patch}"
        if [[ "$branch_version" != "$repo_marketing_version" ]]; then
            echo "Error: Branch/TAG version $branch_version does not match repo MARKETING_VERSION $repo_marketing_version."
            exit 1
        fi

        case "$ver_type" in
            alpha)
                release_channel="alpha"
                prerelease="true"
                tag_name="alpha-v${branch_version}"
                ;;
            beta)
                release_channel="beta"
                prerelease="true"
                tag_name="beta-v${branch_version}"
                ;;
            rc)
                release_channel="rc"
                prerelease="true"
                tag_name="rc-v${branch_version}"
                ;;
            *)
                release_channel="production"
                prerelease="false"
                tag_name="v${branch_version}"
                ;;
        esac
    else
        echo "Error: BRANCH/TAG $BRANCH does not match expected format."
        exit 1
    fi
else
    echo "Error: BRANCH undefined."
    exit 1
fi

product_version="v${major}.${minor}.${patch}"

if [[ -n "$ver_type" ]]; then
    product_version="${product_version}-${ver_type}"
fi

if [[ -n "$build" ]]; then
    product_version="${product_version}.${build}"
fi

if [[ -z "${release_channel:-}" ]]; then
    release_channel="production"
fi

if [[ -z "${prerelease:-}" ]]; then
    prerelease="false"
fi

if [[ -z "${tag_name:-}" ]]; then
    tag_name="$product_version"
fi

echo "CI_TAG: $CI_TAG"
echo "CI_BRANCH: $CI_BRANCH"
echo "CI_PULL_REQUEST_SOURCE_BRANCH: $CI_PULL_REQUEST_SOURCE_BRANCH"
echo "CI_PULL_REQUEST_TARGET_BRANCH: $CI_PULL_REQUEST_TARGET_BRANCH"
echo "CI_PRODUCTION_BRANCH: $CI_PRODUCTION_BRANCH"
echo
echo "BRANCH: $BRANCH"
echo "VER_TYPE: $ver_type"
echo "BUILD: $build"
echo "MAJOR: $major"
echo "MINOR: $minor"
echo "PATCH: $patch"
echo "PRODUCT_VERSION: $product_version"
echo "RELEASE_CHANNEL: $release_channel"
echo "PRERELEASE: $prerelease"
echo "TAG_NAME: $tag_name"
