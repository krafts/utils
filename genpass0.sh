#!/bin/bash

set -e
set -u

length="${1:-16}"

length=$((length - 1))

p=
c="abcdefghjiklmopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVQXYZ0123456789"
c_len=$(echo $c | wc -c)
c_len=$((c_len - 1)) ## index start at 0

## double random, is it really neccessary?
for i in $(seq 128); do
  d=$((RANDOM % $c_len))
  a="${c:$d}"
  b="${c:0:$d}"
  a_len=$(echo $a | wc -c)
  b_len=$(echo $b | wc -c)
  ar=$((RANDOM % $a_len))
  br=$((RANDOM % $b_len))
  c="${a:0:$ar}${b:$br}${b:0:$br}${a:$ar}"
done

for i in $(seq $length); do
  d=$((RANDOM % 61));
  p="${c:$d:1}$p"
done
echo $p
