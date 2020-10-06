#!/bin/bash

while true; do kubectl logs -f $(kubectl get pods -l app="${1}" --no-headers 2>/dev/null | grep Running | head -n 1 | awk '{print $1}') 2>/dev/null || echo "$(date -Is) ERROR: no pod Running."; sleep 1; done
