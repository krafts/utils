#!/bin/bash

set -euo pipefail

source colors.sh

function yes_or_no {
    while true; do
        #read -p $'\e[31mFoobar\e[0m: ' foo
        read -p $'Continue [\e[32my\e[0m/\e[31mn\e[0m]: ' yn
        case $yn in
            [Yy]*) return 0  ;;
            [Nn]*) echo -e "${TXT_RED}Aborted${TXT_CLEAR}" ; return  1 ;;
        esac
    done
}

function check_worktree_with_branch {
    local dir_path_repo_branch="${1}"
    local dir_path_repo="${dir_path_repo_branch%/*}"
    local branch="${dir_path_repo_branch##*/}"
    if [ -d "${1}" ]; then
        echo -e "${TXT_YELLOW}${dir_path_repo}${TXT_CLEAR} is already on ${TXT_GREEN}git worktree workflow${TXT_CLEAR} with ${TXT_RED}${branch}${TXT_CLEAR} branch"
        echo
        cd ${dir_path_repo_branch}
        echo -e "${TXT_BLUE}Worktrees${TXT_CLEAR}"
        git worktree list
        exit 0
    fi
}

DIR_PATH_REPO="$(readlink -f ${1})"
DIR_PATH_REPO_TMP="${DIR_PATH_REPO}_worktree_tmp"
DIR_PATH_REPO_MAIN="${DIR_PATH_REPO}/main"
DIR_PATH_REPO_MASTER="${DIR_PATH_REPO}/master"

check_worktree_with_branch "${DIR_PATH_REPO_MAIN}"
check_worktree_with_branch "${DIR_PATH_REPO_MASTER}"

if [ ! -d "${DIR_PATH_REPO}" ]; then
    echo -e "${TXT_YELLOW}${DIR_PATH_REPO}${TXT_CLEAR} ${TXT_RED}is not a dir!${TXT_CLEAR}"
    exit 1
fi

if [ ! -d "${DIR_PATH_REPO}/.git" ]; then
    echo -e "${TXT_YELLOW}${DIR_PATH_REPO}${TXT_CLEAR} ${TXT_RED}is NOT a git repo dir!${TXT_CLEAR}"
    exit 1
fi

# currently only setup for main branch, needs more work for master branch support
echo -e "${TXT_RED}${DIR_PATH_REPO}${TXT_CLEAR} ${TXT_YELLOW}->${TXT_CLEAR} ${TXT_GREEN}${DIR_PATH_REPO_TMP}${TXT_CLEAR}"
yes_or_no
mv -v ${DIR_PATH_REPO} ${DIR_PATH_REPO_TMP}
echo -e "Creating dir ${TXT_GREEN}${DIR_PATH_REPO_TMP}${TXT_CLEAR}..."
mkdir -pv ${DIR_PATH_REPO}
echo -e "${TXT_RED}${DIR_PATH_REPO_TMP}${TXT_CLEAR} ${TXT_YELLOW}->${TXT_CLEAR} ${TXT_GREEN}${DIR_PATH_REPO_MAIN}${TXT_CLEAR}"
yes_or_no
mv -v ${DIR_PATH_REPO_TMP} ${DIR_PATH_REPO_MAIN}
echo
cd ${DIR_PATH_REPO_MAIN}
echo -e "${TXT_BLUE}Worktrees${TXT_CLEAR}"
git worktree list

# repo_name="${repo_path##*/}"
# dir_path="${WORKSPACE}/${repo_path%/*}"
# dir_path_repo="${dir_path}/${repo_name}"
# echo
# echo -e "dir_path=${TXT_GREEN}${WORKSPACE}/${TXT_RED}${repo_path%/*}${TXT_CLEAR}"
# #echo -e "${TXT_RED}path in red will be created if does not exist${TXT_CLEAR}"
# echo
# yes_or_no
# echo
# mkdir -pv "${dir_path_repo}"
# cd "${dir_path_repo}"
# pwd
# echo
# git clone "${repo}" main # added this for worktree workflow
# echo
# cd "${dir_path_repo}"
# echo -e "${TXT_GREEN}${dir_path_repo}${TXT_CLEAR}"
# echo
