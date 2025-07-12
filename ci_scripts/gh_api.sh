#!/bin/sh -v
#  gh_api.sh
#  
#
#  Created by Michael Logothetis on 12/7/2025.
#

set -e

# Replace with your repo info or get from ENV
REPO="Technistic/ImageDataPicker"
PR_NUMBER="61" # or get dynamically if part of a trigger
GITHUB_API="https://api.github.com/repos/$REPO/pulls/$PR_NUMBER"

# Fetch PR info using GitHub REST API
RESPONSE=$(curl -vvv -s -H "Authorization: Bearer $GITHUB_TOKEN" "$GITHUB_API")

# Parse the 'draft' field using jq (install or use inline grep if jq unavailable)
IS_DRAFT=$(echo "$RESPONSE" | grep -o '"draft": [^,]*' | awk '{print $2}')

echo "Is draft? $IS_DRAFT"

# Use this value in a condition
if [[ "$IS_DRAFT" = "true" ]]; then
  echo "❌ This is a draft PR — skipping build or deploy step."
  exit 0 # or exit with special code to skip later stages
fi

set +e
