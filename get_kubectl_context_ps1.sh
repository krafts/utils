#!/bin/bash


if ! command -v kubectl &> /dev/null; then
  exit 0
fi

context=$(kubectl config current-context 2>/dev/null)
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

## CLEAR
CLEAR_ALL='\[\033[00m\]'

## BACKGROUNDS
BG_RED='\[\033[41m\]'
BG_GREEN='\[\033[42m\]'
BG_YELLOW='\[\033[43m\]'
BG_BLUE='\[\033[44m\]'
BG_PURPLE='\[\033[45m\]'
BG_CYAN='\[\033[46m\]'
BG_WHITE='\[\033[47m\]'

## FOREGROUNDS
FG_BLACK='\[\033[1;30m\]'
FG_BLUE='\[\033[1;34m\]'
FG_GREEN='\[\033[1;32m\]'
FG_CYAN='\[\033[1;36m\]'
FG_RED='\[\033[1;31m\]'
FG_PURPLE='\[\033[1;35m\]'
FG_BROWN='\[\033[1;33m\]'
FG_YELLOW='\[\033[1;33m\]'

source ~/.kubectl_context_ps1_domains

if [ "$environment" == "${PROD}" ]; then
  BG="${BG_RED}"
  FG="${FG_BLACK}"
  extra_chars_b="PROD->>!!! "
  extra_chars_e=" !!!<<-PROD"
fi

if [ "$environment" == "${STAGING}" ]; then
  BG="${BG_YELLOW}"
  FG="${FG_BLACK}"
  extra_chars_b="STAGING "
  extra_chars_e=" STAGING"
fi

if [ "$environment" == "${DEV}" ]; then
  u=$(echo ${cluster} |  awk -F- '{print $1}')
  if [ "${u}" == "${USER}" ]; then
    exit 0
  fi

  BG="${BG_PURPLE}"
  FG="${FG_BLACK}"
  extra_chars_b="DEV "
  extra_chars_e=" DEV"
fi

## adding extra space at the end for PS1
##printf "${fg}${bg} ${cluster} ${clear_all}"
##printf "${extra_chars_b}${cluster}${extra_chars_e}"
#echo  "${BG}${FG} ${extra_chars_b}${cluster}${extra_chars_e} ${CLEAR_ALL}"
printf "${extra_chars_b}${cluster}${extra_chars_e}"
