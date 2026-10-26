
#!/bin/bash

# GitHub API URL
API_URL="https://api.github.com"

# GitHub username and personal access token
USERNAME="${username:-Akhila6612}"
TOKEN="${TOKEN:-$token}"

# Repository information
REPO_OWNER="$1"
REPO_NAME="$2"

# Ubuntu version information
NAME="Ubuntu"
VERSION_ID="26.04"


# Function to make a GET request to GitHub API
github_api_get() {
    local endpoint="$1"
    local url="${API_URL}/${endpoint}"

    curl -s -H "Authorization: Bearer ${TOKEN}" \
         -H "Accept: application/vnd.github+json" \
         "$url"
}


# Function to list users with read access
list_users_with_read_access() {
    local endpoint="repos/${REPO_OWNER}/${REPO_NAME}/collaborators"

    
response="$(github_api_get "$endpoint")"

collaborators="$(echo "$response" | jq -r '
    if type == "array" then
        .[] | select(.permissions.pull == true) | .login
    else
        empty
    end
')"


    if [[ -z "$collaborators" ]]; then
        echo "No users with read access found for ${REPO_OWNER}/${REPO_NAME}."
    else
        echo "Users with read access to ${REPO_OWNER}/${REPO_NAME}:"
        echo "$collaborators"
    fi
}

# Main script
echo "OS: $NAME"
echo "Version: $VERSION_ID"
echo "Listing users with read access to ${REPO_OWNER}/${REPO_NAME}..."

list_users_with_read_access
