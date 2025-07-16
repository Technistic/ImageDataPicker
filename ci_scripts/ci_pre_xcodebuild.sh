#!/bin/sh

#  ci_pre_xcodebuild.sh
#  ImageDataPicker
#
#  Updated by Michael Logothetis on 13/7/2025.
#

echo "Configuring build for $CI_BRANCH"

# Set version information based on branch or tag name.
. ./get_version_from_git_ref.sh

# Copy DocC assets for alpha and beta versions.
if [[ -n "$ver_type" && "$ver_type" != "production" ]]; then
    echo "Copying $ver_type DocC Assets for alpha and beta versions."
    cp -R $ver_type/* ${CI_PRIMARY_REPOSITORY_PATH}/ImageDataPicker/ImageDataPicker/ImageDataPicker.docc/Resources
    cp -R $ver_type/* ${CI_PRIMARY_REPOSITORY_PATH}/EmployeeFormExample/EmployeeFormExample/EmployeeFormExample.docc/Resources
fi
