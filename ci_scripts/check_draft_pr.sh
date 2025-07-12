#!/bin/zsh
#
#  check_draft_pr.sh
#  
#
#  Created by Michael Logothetis on 13/7/2025.
#  
#

REPO="Technistic/ImageDataPicker"

# If the workflow is triggered by a pull request, we can check if it is a draft PR.
if [[ -n $CI_PULL_REQUEST_NUMBER ]]; then
    GITHUB_API="https://api.github.com/repos/$REPO/pulls/$CI_PULL_REQUEST_NUMBER"
    echo "Checking if $GITHUB_API is a draft PR."
    
    # Fetch PR info using GitHub REST API
    RESPONSE=$(curl -S -H "Authorization: Bearer $GITHUB_TOKEN" "$GITHUB_API")

    # Parse the 'draft' field using jq (install or use inline grep if jq unavailable)
    IS_DRAFT_PR=$(echo "$RESPONSE" | grep -o '"draft": [^,]*' | awk '{print $2}')

    if [[ -z "$IS_DRAFT_PR" ]]; then
        echo "Could not retrieve PR $CI_PULL_REQUEST_NUMBER."
        exit 0
    fi

    # Exit workflow if this is a draft PR.
    if [[ "$IS_DRAFT_PR" = "true" ]]; then
        echo "Draft PR: Exiting Workflow."
        exit 0 # or exit with special code to skip later stages
    fi
fi
