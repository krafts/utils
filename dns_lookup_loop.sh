#!/usr/bin/env bash

set -uo pipefail

DOMAIN="${1}"

while true; do
  echo "$(gdate -Is) ${DOMAIN} $(dig +short ${DOMAIN})"
  sleep 1
done
