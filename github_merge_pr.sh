#!/bin/bash

PR_NUMBER="${1}"
ACCOUNT="${2:-ACCOUNT}"
REPO="${3:-REPO}"
GITHUB_TOKEN=$(cat ~/.github_git_alias_auth_token)
PR_URL="https://api.github.com/repos/${ACCOUNT}/${REPO}/pulls/${PR_NUMBER}"

while true; do
    ## TODO figure out auto merge/rebase
    # curl -X PUT \
    #     -H "Authorization: token ${GITHUB_TOKEN}" \
    #     -H "Content-Type: application/json" \
    #     "${PR_URL}/update-branch"

    status_code=$(curl -o /dev/null -s -w "%{http_code}" -X PUT \
        -H "Authorization: token ${GITHUB_TOKEN}" \
        -H "Content-Type: application/json" \
        --data '{"merge_method": "squash"}' \
        "${PR_URL}/merge")

    case ${status_code} in
        200) echo "merged!"; break;;
        405) echo "cannot merge... check for approvals or update branch";;
        409) echo "cannot merge... CONFLICT!!!";;
        *) echo "something went wrong with the merge";;
    esac

    sleep 1
done
