#!/bin/bash


if ! command -v kubectl &> /dev/null; then
  exit 0
fi

context=$(kubectl config current-context)
environment=$(echo ${context} | awk -F_ '{print $2}')
cluster=$(echo ${context} | awk -F_ '{print $4}')

## backgrounds
bg_default="\e[49m"
bg_red="\e[48;5;196m"
bg_yellow="\e[48;5;11m"
bg_purple="\e[48;5;200m"

## foregrounds
fg_default="\e[39m"
fg_black="\e[38;5;0m"

## extras
bold="\e[1m"
blink="\e[5m"
clear_all="\e[0m"

if [ $environment == 'dabl-prod' ]; then
  bg="${bg_red}"
  fg="${fg_black}${bold}${blink}"
fi

if [ $environment == 'dabl-staging' ]; then
  bg="${bg_yellow}"
  fg="${fg_black}${bold}"
fi

if [ $environment == 'dabl-dev' ]; then
  u=$(echo ${cluster} |  awk -F- '{print $1}')
  if [ "${u}" == "${USER}" ]; then
    exit 0
  fi

  bg="${bg_purple}"
  fg="${fg_black}${bold}"
fi


printf "${fg}${bg}${cluster}${clear_all}"
