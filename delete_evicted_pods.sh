#!/usr/bin/env bash

set -euo pipefail

if [ $# -ne 1 ]; then
  echo usage: $0 namespace
  exit 1
fi

NAMESPACE="${1}"

kubectl -n ${NAMESPACE} delete pods $(kubectl -n ${NAMESPACE} get pods -o=jsonpath='{.items[?(@.status.reason=="Evicted")].metadata.name}')
