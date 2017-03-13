#!/bin/bash

set -o nounset
set -o errexit
#set -o xtrace

export PATH="/usr/local/sbin:/sbin:/bin:/usr/sbin:/usr/bin:/root/bin"


function usage() {
  cat << EOF
usage: $(basename $0) -n <num> -l <len>
  n: num
  l: len
  h: printing help
EOF
}

typeset NUM=4096
typeset LEN=255

while getopts ":n:l:h" opt; do
  case $opt in
    n)
      NUM="$OPTARG"
      ;;
    l)
      LEN="$OPTARG"
      LEN=$((LEN-1))
      if [ $LEN -gt 255 ]
      then
        LEN=255
      fi
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


rows=$(openssl rand -base64 $NUM | base64 | grep -oe ".\{$LEN\}" | wc -l | awk '{print $1}')
rand=$(awk "BEGIN{srand();print int(rand()*($rows-1))+1 }")
openssl rand -base64 $NUM | base64 | grep -oe ".\{$LEN\}" | head -$rand | tail -1
