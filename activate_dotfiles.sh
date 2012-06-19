#!/bin/bash

for f in `ls -A ~/dotfiles-public | grep -v .git | grep -v activate_dotfiles.sh`; do rm -rf ~/$f; ln -s ~/dotfiles-public/$f ~/; done
