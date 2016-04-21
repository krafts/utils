#!/bin/bash

if [ $# -lt 1 ]
then
  echo "$(basename $0) <url> [frequency_in_secs]"
  exit 1
fi

url="$1"
time_wait=${2:-1}

while true; do d=$(timestamp.sh); s=$(curl -Is  "$url" | grep "^HTTP" | grep -o "[[:digit:]]\{3\}"); echo $d $url $s; sleep $time_wait; done;
