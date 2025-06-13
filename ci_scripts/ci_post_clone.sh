#!/bin/sh

#  ci_post_clone.sh
#  ImageDataPicker
#
#  Created by Michael Logothetis on 26/5/2025.
#  
echo "Configuring build for $CI_BRANCH"

if [[ "$CI_BRANCH" =~ ^(alpha|beta)?-?v([[:digit:]]+)\.([[:digit:]]+)\.([[:digit:]]+) ]]; then
    major=${BASH_REMATCH[2]}
    minor=${BASH_REMATCH[3]}
    patch=${BASH_REMATCH[4]}
    ver_type=${BASH_REMATCH[1]}

    echo "Major: $major"
    echo "Minor: $minor"
    echo "Patch: $patch"
    echo "Type: $ver_type"
else
    echo "Invalid Branch"
    exit 1
fi

if [[ -n "$ver_type" ]]; then
    echo "Copying $ver_type DocC Assets"
    cp -R $ver_type/* $CI_WORKSPACE_PATH/ImageDataPicker/ImageDataPicker/ImageDataPicker/ImageDataPicker.docc/Resources
    cp -R $ver_type/* $CI_WORKSPACE_PATH/ImageDataPicker/EmployeeFormExample/EmployeeFormExample/EmployeeFormExample.docc/Resources
fi
