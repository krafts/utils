#!/bin/bash

NAMESPACE="${1}"

if [ -z ${NAMESPACE} ]; then
  kubectl_command="kubectl --all-namespaces"
else
  kubectl_command="kubectl -n ${NAMESPACE}"
fi

requests=$(${kubectl_command} get pods -o json | jq '.items[] | .spec.containers[].resources.requests.cpu' | grep -v null | sed 's/"//g'| while read i; do if [[ $i == *m ]]; then i=${i%%m}; i=$(awk "BEGIN {printf \"%.2f\",${i}/1000}"); fi; echo $i; done | awk '{SUM+=$1} END {print SUM}')
limits=$(${kubectl_command} get pods -o json | jq '.items[] | .spec.containers[].resources.requests.cpu' | grep -v null | sed 's/"//g'| while read i; do if [[ $i == *m ]]; then i=${i%%m}; i=$(awk "BEGIN {printf \"%.2f\",${i}/1000}"); fi; echo $i; done | awk '{SUM+=$1} END {print SUM}')
top=$(${kubectl_command} top pods --no-headers | awk '{print $2}' | while read i; do if [[ $i == *m ]]; then i=${i%%m}; i=$(awk "BEGIN {printf \"%.2f\",${i}/1000}"); fi; echo $i; done | awk '{SUM+=$1} END {print SUM}')


echo "requests: ${requests}"
echo "limits: ${limits}"
echo "top: ${top}"
