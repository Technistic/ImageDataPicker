#!/bin/sh -x

#  ci_site_deploy.sh
#  ImageDataPicker
#
#  Created by Michael Logothetis on 26/5/2025.
#
#  Refer to https://medium.com/kinandcartacreated/host-and-automate-your-docc-documentation-c6ac29dc0feb
#
git config user.name "$DOCC_GITHUB_NAME"
git config user.email "$DOCC_GITHUB_EMAIL"
# Change the GitHub URL to your repository
git remote set-url origin https://$DOCC_GITHUB_USERNAME:$DOCC_GITHUB_API_TOKEN@github.com/Technistic/ImageDataPicker
git fetch
cp -R $CI_WORKSPACE_PATH/doc_archives $CI_PRIMARY_REPOSITORY_PATH/doc_archives
git stash push -u  -- $CI_PRIMARY_REPOSITORY_PATH/docs $CI_PRIMARY_REPOSITORY_PATH/doc_archives
git checkout feature/docc-hosting
rm -rf $CI_PRIMARY_REPOSITORY_PATH/docs $CI_PRIMARY_REPOSITORY_PATH/doc_archives
git stash apply
git add $CI_PRIMARY_REPOSITORY_PATH/docs $CI_PRIMARY_REPOSITORY_PATH/doc_archives
git commit -m "Updated DocC documentation"
git push --set-upstream origin feature/docc-hosting
