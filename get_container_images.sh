#!/usr/bin/env bash

set -euo pipefail

if [ $# -ne 1 ]; then
  echo usage: $0 namespace
  exit 1
fi

NAMESPACE="${1}"

kubectl -n $NAMESPACE get pods -o jsonpath="{.items[*].spec.containers[*].image}" \
  | tr -s '[[:space:]]' '\n' \
  | sort \
  | uniq -c
