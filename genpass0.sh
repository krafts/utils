#!/bin/bash

set -e
set -u

length="${1:-16}"
length=$((length - 1))

p=
c="abcdefghjiklmopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVQXYZ0123456789"
for i in $(seq $length); do
  d=$((RANDOM % 61));
  p="${c:$d:1}$p"
done
echo $p
