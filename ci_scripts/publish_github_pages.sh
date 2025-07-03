#!/bin/sh -e

#  publish_github_pages.sh
#  
#  This Xcode Cloud CI script automatically publishes the DocC archives generated
#  by your build to a GitHub Pages repository.
#
#  Created by Michael Logothetis on 4/6/2025.
#
#  This script is intended to be run in an Xcode Cloud environment after the build and will publish any
#  DocC archives found in the derived data path to a GitHub Pages repository.
#
#  Your Xcode projects should be configured to:
#  1. Generate DocC documentation during the build process and;
#  2. Configure the DocC archive hosting base path.
#
#  This is done using the following Xcode project build settings.
#  - Build Settings/Documentation Compiler - Options/Build Documenation During Build: Yes
#  - Build Settings/Documentation Compiler - Options/DocC Archive Hosting Base Path: <GITHUB_PAGES_REPO>/<ArchiveName>
#
#  This script assumes the repository includes a branch "feature/docc-hosting".
#  This can be configured via the GITHUB_PAGES_BRANCH variable below.
#  It will creates "/docs" and "/doc_archives" directories in the repository root of this branch.
#  You should configure a GitHub Pages deployment to be triggered when you push to this branch.
#  https://docs.github.com/en/pages/getting-started-with-github-pages/configuring-a-publishing-source-for-your-github-pages-site
#
#  The name of the branch and directory that will trigger the GitHub Pages deployment.
GITHUB_PAGES_BRANCH="feature/docc-hosting"
GITHUB_PAGES_DIR="docs"

#  The script assumes that you have already set up the following environment variables in Xcode Cloud:
#  See: https://developer.apple.com/documentation/xcode/xcode-cloud-workflow-reference#Custom-environment-variables
#  - DOCC_GITHUB_USERNAME: Your GitHub username.
#  - DOCC_GITHUB_EMAIL: Your email for the Git commit.
#  - DOCC_GITHUB_API_TOKEN: Your GitHub API token with permissions to push to the repository.
#  - DOCC_GITHUB_NAME: Your name for the Git commit.
#
#  If your Github Pages repository belongs to an organization, set the organization name here.
#  Otherwise the script will use your GitHub username.
#  GITHUB_ORGANIZATION="${DOCC_GITHUB_USERNAME}"
GITHUB_ORGANIZATION="Technistic"

#  The name of the repository where the DocC documentation will be published.
#  https://<GITHUB_ORGANIZATION.github.io>/<GITHUB_PAGES_REPO>/<archiveName>/documenation/<archiveName>
GITHUB_PAGES_REPO="ImageDataPicker"

echo "Publishing DocC documentation for $CI_PRODUCT"

# Check that this script is running in an Xcode Cloud environment and optionally
# for a specific $CI_XCODEBUILD_ACTION and $CI_PRODUCT_PLATFORM.
#
# Use the following line to always run this script in Xcode Cloud, regardless of the action or platform.
# if [[ $CI && $CI_XCODEBUILD_ACTION = 'build' && $CI_PRODUCT_PLATFORM = 'iOS' || true ]];
if [[ $CI && $CI_XCODEBUILD_ACTION = 'archive' && $CI_PRODUCT_PLATFORM = 'iOS' ]];
then
    # Copy any *.doccarchive build artifacts to the workspace doc_archives directory.
    mkdir -p ${CI_WORKSPACE_PATH}/doc_archives
    cp -R `find $CI_DERIVED_DATA_PATH -type d -name "*.doccarchive"` ${CI_WORKSPACE_PATH}/doc_archives

    #  Configure git and change branch to $GITHUB_PAGES_BRANCH
    git config user.name "$DOCC_GITHUB_NAME"
    git config user.email "$DOCC_GITHUB_EMAIL"
    
    # Stash any uncommitted changes in the primary repository path so that we can safely switch branches.
    git stash
    
    # Change the GitHub URL to your repository
    git remote set-url origin https://${DOCC_GITHUB_USERNAME}:${DOCC_GITHUB_API_TOKEN}@github.com/${GITHUB_ORGANIZATION}/${GITHUB_PAGES_REPO}
    git fetch
    git checkout ${GITHUB_PAGES_BRANCH}

    #  Delete existing documentation directories and create new ones.
    rm -rf ${CI_PRIMARY_REPOSITORY_PATH}/${GITHUB_PAGES_DIR} ${CI_PRIMARY_REPOSITORY_PATH}/doc_archives
    mkdir -p ${CI_PRIMARY_REPOSITORY_PATH}/doc_archives
    mkdir -p ${CI_PRIMARY_REPOSITORY_PATH}/${GITHUB_PAGES_DIR}/

    #  Process each DocC archive and copy it to the GitHub Pages directory.
    for ARCHIVE in ${CI_WORKSPACE_PATH}/doc_archives/*.doccarchive; do
        ARCHIVE_FILE=$(basename "${ARCHIVE}")
        ARCHIVE_NAME=$(echo $ARCHIVE_FILE | awk -F '.' '{print tolower($1)}')

        echo "Processing Archive: $ARCHIVE"
        mkdir -p ${CI_PRIMARY_REPOSITORY_PATH}/${GITHUB_PAGES_DIR}/${ARCHIVE_NAME}
        mv $ARCHIVE ${CI_PRIMARY_REPOSITORY_PATH}/doc_archives/
        cp -R ${CI_PRIMARY_REPOSITORY_PATH}/doc_archives/${ARCHIVE_FILE}/* ${CI_PRIMARY_REPOSITORY_PATH}/${GITHUB_PAGES_DIR}/${ARCHIVE_NAME}
    done

    #  Commit and push the changes to the GitHub Pages branch.
    git add ${CI_PRIMARY_REPOSITORY_PATH}/${GITHUB_PAGES_DIR} ${CI_PRIMARY_REPOSITORY_PATH}/doc_archives
    git commit -m "Updated DocC documentation"
    git push --set-upstream origin ${GITHUB_PAGES_BRANCH}

    echo "Publishing DocC documentation for ${CI_PRODUCT} completed successfully."
    
    echo "Returning to the primary repository branch ${CI_BRANCH}."
    git checkout ${CI_BRANCH}
    git stash pop || true  # Pop the stash, ignore if it fails (e.g., no stash available)
fi
