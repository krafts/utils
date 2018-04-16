#!/bin/bash


set -o nounset
set -o errexit
set -o xtrace


USER_ID=${1:="local"}
SSH_KEY_GEN_TOOL1="/usr/bin/ssh-keygen"
SSH_KEY_GEN_TOOL=""

if [ -e "$SSH_KEY_GEN_TOOL1" ]; then
  SSH_KEY_GEN_TOOL="$SSH_KEY_GEN_TOOL1"
fi

if [ -z "$SSH_KEY_GEN_TOOL" ]; then
  echo "ssh keygen not found!"
  exit 1
fi



"$SSH_KEY_GEN_TOOL" -t rsa -b 4096 -N "" -C "$USER_ID ssh key" -f "${USER_ID}_id_rsa.key"

sed 's/^\(\s*.\)/  \1/g' "${USER_ID}_id_rsa.key" > "${USER_ID}_id_rsa.key.tmp"
sed '1i\
${USER_ID}_ssh_id_rsa_private_key: |'$'\n' "${USER_ID}_id_rsa.key.tmp" > "${USER_ID}_id_rsa.key"
rm -vf "${USER_ID}_id_rsa.key.tmp"
echo "{{${USER_ID}_ssh_id_rsa_private_key | b64f}}" > "${USER_ID}_id_rsa.key.j2"
