#!/bin/bash

if [ `whoami` = "root" ]; then
    echo "running as root, aborting"
    exit 1
fi

for f in `ls -A ~/dotfiles-public | grep -v .git | grep -v activate_dotfiles.sh`; do rm -rf ~/$f; ln -s ~/dotfiles-public/$f ~/; done
