#!/bin/bash

set -o nounset
set -o errexit
#set -o xtrace

export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/root/bin"


function usage() {
  cat << EOF
usage: $(basename $0) -n <num> -l <len>
  n: num
  l: len
  h: printing help
EOF
}

typeset NUM=4096
typeset LEN=32

while getopts ":n:l:h" opt; do
  case $opt in
    n)
      NUM="$OPTARG"
      ;;
    l)
      LEN="$OPTARG"
      ;;
    h)
      usage
      exit 0
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      usage
      exit 1
      ;;
     :)
      echo "Missing option argument for -$OPTARG" >&2
      usage
      exit 1
      ;;
     *)
      echo "Unimplmented option: -$OPTARG" >&2
      usage
      exit 1
      ;;
  esac
done

openssl rand -base64 $((2**20)) | base64 -d | base64 -w 0 | grep -o ".\{$LEN\}" | tail -n 5
