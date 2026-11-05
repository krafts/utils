#!/usr/bin/env bash
#
# Default identity for every repo, krafts for repos under ~/workspace/krafts/.
#
# Usage: git_set_author.sh <default name> <default email> <krafts name> <krafts email>

### ~/.ssh/config entries

### Host github.com
###    HostName github.com
###    User git
###    IdentityFile ~/.ssh/id_rsa
###    CheckHostIP no
###    StrictHostKeyChecking no

### Host github.com-username_home
###    HostName github.com
###    User git
###    IdentityFile ~/.ssh/id_rsa_username_home
###    CheckHostIP no
###    StrictHostKeyChecking no

set -euo pipefail

if [ $# -ne 4 ]; then
  echo "Usage: $(basename "$0") <default name> <default email> <krafts name> <krafts email>" >&2
  exit 1
fi

mkdir -p ~/.config/git
git config -f ~/.config/git/default user.name "$1"
git config -f ~/.config/git/default user.email "$2"
git config -f ~/.config/git/krafts user.name "$3"
git config -f ~/.config/git/krafts user.email "$4"

# git keeps the last value it reads, so the includeIf has to come after the
# default include: remove it and add it again at the end
git config --global include.path "~/.config/git/default"
git config --global --remove-section "includeIf.gitdir:~/workspace/krafts/" 2> /dev/null || true
git config --global "includeIf.gitdir:~/workspace/krafts/.path" "~/.config/git/krafts"
