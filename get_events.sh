#!/bin/bash

set -euo pipefail

if [ $# -ne 2 ]; then
  echo "usage: ${0} zone service"
  exit 1
fi


ZONE="${1}"
SERVICE="${2}"
NAMESPACE="${ZONE}-${SERVICE}"

function _spacer() {
  echo -e "\n\n"
}

# function get_events_pod() {
#   local pod_name="${1}"
#   echo "----- ALL events ${pod_name} -----"
#   kubectl -n ${NAMESPACE} get events --field-selector involvedObject.kind=Pod,involvedObject.name=${pod_name}
#   _spacer
#   echo "----- ABNORMAL events ${pod_name} -----"
#   kubectl -n ${NAMESPACE} get events --field-selector involvedObject.kind=Pod,type!=Normal,involvedObject.name=${pod_name}
#   _spacer
# }

# function get_events_vmi() {
#   local vmi_name="${1}"
#   virt_launcher_pod_name="$(kubectl -n ${NAMESPACE} get pods --selector instance=${vmi_name} -o jsonpath='{.items[0].metadata.name}')"
#   get_events_pod ${virt_launcher_pod_name}
#   echo "----- ALL events for VMI ${vmi_name} -----"
#   kubectl -n ${NAMESPACE} get events --field-selector involvedObject.kind=VirtualMachineInstance,involvedObject.name=${vmi_name}
#   _spacer
#   echo "----- ABNORMAL for VMI ${vmi_name} -----"
#   kubectl -n ${NAMESPACE} get events --field-selector involvedObject.kind=VirtualMachineInstance,type!=Normal,involvedObject.name=${vmi_name}
#   _spacer
# }


function get_events() {
  local kind="${1}"
  kubectl -n ${NAMESPACE} get ${kind} -o jsonpath='{range .items[*]}{.metadata.name}{"\n"}{end}' | while read kind_name; do
    echo "----- ${kind}/${kind_name} -----"
    kubectl -n ${NAMESPACE} get events --field-selector involvedObject.kind=${kind},involvedObject.name=${kind_name}
    _spacer
    # echo "----- ABNORMAL events ${field_selector} -----"
    # kubectl -n ${NAMESPACE} get events --field-selector "type!=Normal,${field_selector}"
    # _spacer
  done
}

get_events Secret
get_events PersistentVolumeClaim
get_events Pod
get_events VirtualMachineInstance

# kubectl -n ${NAMESPACE} get vmi -o jsonpath='{range .items[*]}{.metadata.name}{"\n"}{end}' | while read vmi_name; do
#   get_events involvedObject.kind=VirtualMachineInstance,involvedObject.name=${vmi_name}
# done

# kubectl -n ${NAMESPACE} get pods -o jsonpath='{range .items[*]}{.metadata.name}{"\n"}{end}' | while read pod_name; do
#   get_events involvedObject.kind=Pod,involvedObject.name=${pod_name}
# done

# kubectl -n ${NAMESPACE} get pvc -o jsonpath='{range .items[*]}{.metadata.name}{"\n"}{end}' | while read pvc_name; do
#   get_events involvedObject.kind=PersistentVolumeClaim,involvedObject.name=${pvc_name}
# done
