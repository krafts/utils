#!/usr/bin/env bash

# https://stackoverflow.com/a/1320317
echo "git rebase -r <COMMIT_ID_FOR_N-1_COMMIT> --exec 'git commit --amend --no-edit --reset-author'"
# Reset author since the root of the repo
# https://stackoverflow.com/a/1320317
# echo "To reset from the root of the repo: !!! BE CAREFUL !!!"
# echo "git rebase --root --exec 'git commit --amend --no-edit --reset-author'"
