#!/bin/bash

domain="${1}"
echo | openssl s_client -servername "${domain}" -connect "${domain}:443" 2>/dev/null | openssl x509 -text
