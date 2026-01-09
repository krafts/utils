#!/usr/bin/env bash

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



WORKSPACE="${HOME}/workspace/company"
repo=${1}
repo_path="$(echo ${repo} | sed 's|https://company.com/||g' | sed 's|.git||g')"
echo ${repo_path}
repo_name="${repo_path##*/}"
dir_path="${WORKSPACE}/${repo_path%/*}"
dir_path_repo="${dir_path}/${repo_name}"
echo
echo -e "dir_path=${TXT_GREEN}${WORKSPACE}/${TXT_RED}${repo_path%/*}${TXT_CLEAR}"
#echo -e "${TXT_RED}path in red will be created if does not exist${TXT_CLEAR}"
echo
yes_or_no
echo
mkdir -pv "${dir_path_repo}"
cd "${dir_path_repo}"
pwd
echo
git clone "${repo}" main # added this for worktree workflow
echo
cd ${dir_path_repo}/main
echo -e "${TXT_BLUE}Worktrees${TXT_CLEAR}"
git worktree list
echo
cd "${dir_path_repo}"
echo -e "${TXT_GREEN}${dir_path_repo}${TXT_CLEAR}"
echo
