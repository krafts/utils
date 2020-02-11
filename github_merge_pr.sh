#!/bin/bash

set -ue

PULL_NUMBER="${1}"
ACCOUNT="${2:-ACCOUNT}"
REPO="${3:-REPO}"
GITHUB_TOKEN=$(cat ~/.github_git_alias_auth_token)
GITHUB_API_URL="https://api.github.com/repos/${ACCOUNT}/${REPO}"
PR_URL="${GITHUB_API_URL}/pulls/${PULL_NUMBER}"

while true; do
    ## check if PR is already merged.
    status_code=$(curl -o /dev/null -s -w "%{http_code}" -X GET \
        -H "Authorization: token ${GITHUB_TOKEN}" \
        "${PR_URL}/merge")
    case ${status_code} in
        204) echo "PR is already merged."; break;;
        404) ;; ## not merged
        *) echo "something went wrong with the GET call";;
    esac

    ## merge
    status_code=$(curl -o /dev/null -s -w "%{http_code}" -X PUT \
        -H "Authorization: token ${GITHUB_TOKEN}" \
        -H "Content-Type: application/json" \
        --data '{"merge_method": "squash"}' \
        "${PR_URL}/merge")
    case ${status_code} in
        200) echo "merged!"; break;;
        405) echo "cannot merge... check for approvals or waiting on checks to complete...";;
        409) echo "cannot merge... CONFLICT!!!"; break;;
        *) echo "something went wrong with the merge";;
    esac

    ## check if the branch is outdated. if it is then update the branch.
    master_sha=$(curl -s -X GET \
        -H "Authorization: token ${GITHUB_TOKEN}" \
        -H "Accept: application/vnd.github.VERSION.sha" \
        "${GITHUB_API_URL}/commits/master")

    ## this returns only 250 commits on the branch/PR, if more than 250 commits,
    ## then need to use the commits api.
    if ! curl -s -X GET \
        -H "Authorization: token ${GITHUB_TOKEN}" \
        "${PR_URL}/commits" \
    | grep '"sha"' \
    | awk -F: '{print $2}' \
    | sed -e 's/[", ]//g' \
    | grep -q "${master_sha}"; then
        echo "updating branch, merging master into the branch..."
        curl -X PUT \
            -H "Authorization: token ${GITHUB_TOKEN}" \
            -H "Accept: application/vnd.github.lydian-preview+json"\
            "${PR_URL}/update-branch"
    fi

    sleep 1
done
