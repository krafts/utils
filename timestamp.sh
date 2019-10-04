#!/bin/bash

if [ "$1" == "-u" ]; then
  utc="-u"
else
  utc=
fi

#date_data=$(date $utc +"%Y-%m-%dT%H:%M:%S")
#tz_data=$(date $utc +"%z" | sed 's/\([-+]\)\([0-9]\{2\}\)\(.*\)/\1\2:\3/g')
date_tz=$(date $utc +"%Y-%m-%dT%H:%M:%S%z")
echo "$date_tz"
