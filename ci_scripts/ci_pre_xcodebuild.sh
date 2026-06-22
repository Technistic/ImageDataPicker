#!/bin/sh

#  ci_pre_xcodebuild.sh
#  ImageDataPicker
#
#  Updated by Michael Logothetis on 13/7/2025.
#

echo "Configuring build for $CI_BRANCH"

# Set version information based on branch or tag name.
. ./get_version_from_git_ref.sh

# Copy channel-specific DocC assets for prerelease builds.
case "${release_channel}" in
    alpha|beta)
        channel_assets_dir="${CI_PRIMARY_REPOSITORY_PATH}/ci_scripts/${release_channel}"
        echo "Copying ${release_channel} DocC assets from ${channel_assets_dir}."
        cp -R "${channel_assets_dir}/." "${CI_PRIMARY_REPOSITORY_PATH}/ImageDataPicker/ImageDataPicker/ImageDataPicker.docc/Resources"
        cp -R "${channel_assets_dir}/." "${CI_PRIMARY_REPOSITORY_PATH}/EmployeeFormExample/EmployeeFormExample/EmployeeFormExample.docc/Resources"
        ;;
    *)
        echo "No channel-specific DocC assets required for ${release_channel}."
        ;;
esac

case "${release_channel}" in
    alpha)
        echo "Expected framework scheme: ImageDataPicker-alpha"
        echo "Expected sample scheme: EmployeeFormExample-alpha"
        ;;
    beta)
        echo "Expected framework scheme: ImageDataPicker-beta"
        echo "Expected sample scheme: EmployeeFormExample-beta"
        ;;
    *)
        echo "Expected framework scheme: ImageDataPicker"
        echo "Expected sample scheme: EmployeeFormExample-Release"
        ;;
esac
