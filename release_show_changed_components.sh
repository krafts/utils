exec git show | grep ^[-+] | grep -v -e +++ -e --- | awk -F: '{print $1}'  | awk '{print $2}' | sed 's/"//g' | sort | uniq
