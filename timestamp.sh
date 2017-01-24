#!/bin/bash

date_data=$(date +"%Y-%m-%dT%H:%M:%S")
tz_data=$(date +"%z" | sed 's/\([-+]\)\([0-9]\{2\}\)\(.*\)/\1\2:\3/g')

echo "$date_data$tz_data"
