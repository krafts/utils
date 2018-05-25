#!/bin/bash



### ~/.ssh/config entries

### Host github.com
###    HostName github.com
###    User git
###    IdentityFile ~/.ssh/id_rsa
###    CheckHostIP no
###    StrictHostKeyChecking no

### Host github.com-username_home
###    HostName github.com
###    User git
###    IdentityFile ~/.ssh/id_rsa_username_home
###    CheckHostIP no
###    StrictHostKeyChecking no




if git remote -v | head -n 1 | grep -q "company_repo" 2>&1 > /dev/null; then
  git config user.name "username_company"
  git config user.email "username_company@company.com"
else
  git config user.name "username_home"
  git config user.email "username_home@home.com"
  sed -i.bak  "s/github.com:/github.com-username_home:/g" .git/config
fi

