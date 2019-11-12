#!/bin/bash

NAMESPACE="${1}"

if [ -z "${NAMESPACE}" ]; then
  namespace="--all-namespaces"
else
  namespace="-n ${NAMESPACE}"
fi

requests=$(kubectl get pods ${namespace} -o=jsonpath='{.items[*].spec.containers[*].resources.requests.cpu}' | xargs -n 1 | while read i; do if [[ $i == *m ]]; then i=${i%%m}; i=$(awk "BEGIN {printf \"%.2f\",${i}/1000}"); fi; echo $i; done | awk '{SUM+=$1} END {print SUM}')
limits=$(kubectl get pods ${namespace} -o=jsonpath='{.items[*].spec.containers[*].resources.limits.cpu}' | xargs -n 1 | while read i; do if [[ $i == *m ]]; then i=${i%%m}; i=$(awk "BEGIN {printf \"%.2f\",${i}/1000}"); fi; echo $i; done | awk '{SUM+=$1} END {print SUM}')
top=$(kubectl top pods --no-headers ${namespace}| awk '{print $2}' | while read i; do if [[ $i == *m ]]; then i=${i%%m}; i=$(awk "BEGIN {printf \"%.2f\",${i}/1000}"); fi; echo $i; done | awk '{SUM+=$1} END {print SUM}')

echo "requests: ${requests}"
echo "limits: ${limits}"
echo "top: ${top}"
