#!/bin/bash

for f in `ls -A ~/dotfiles-public | grep -v '^.git$' | grep -v activate_dotfiles.sh`; do rm -rf ~/$f; ln -s ~/dotfiles-public/$f ~/; done

# tmux plugin manager
has_git=`hash git 2>/dev/null`
has_git=$?
if [[ $has_git && ! -d ~/.tmux/plugins/tpm ]]; then
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi
if [[ $has_git && ! -d ~/.config/base16-shell ]]; then
    git clone https://github.com/chriskempson/base16-shell.git ~/.config/base16-shell
fi
