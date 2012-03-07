# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines in the history. See bash(1) for more options
export HISTCONTROL=ignoredups
# ... and ignore same sucessive entries.
export HISTCONTROL=ignoreboth
# Store a lot history entries in a file for grep-age
shopt -s histappend
export HISTFILE=~/long_history
export HISTFILESIZE=50000
# No reason not to save a bunch in history
# Takes up several more MBs of RAM now, oOOOooh
export HISTSIZE=9999


# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
xterm-color)
PS1="\[\033[1;32m\]\n\n \w \! \u@\h \A \d\n\n$\[\033[0m\] "
#    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
    ;;
*)
PS1="\[\033[1;32m\]\n\n \w \! \u@\h \A \d\n\n$\[\033[0m\] "
#    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
    ;;
esac

# Comment in the above and uncomment this below for a color prompt
#PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD/$HOME/~}\007"'
    ;;
*)
    ;;
esac

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

#if [ -f ~/.bash_aliases ]; then
#    . ~/.bash_aliases
#fi

# enable color support of ls and also add handy aliases
if [ "$TERM" != "dumb" ]; then
    eval "`dircolors -b`"
    alias ls='ls --color=auto'
    #alias dir='ls --color=auto --format=vertical'
    #alias vdir='ls --color=auto --format=long'
fi


# Sets the Mail Environment Variable
MAIL=/var/spool/mail/brian && export MAIL

export LEDGER=/home/brian/Documents/money/ledger.dat

# some more ls aliases
alias ll='ls -l'
alias la='ls -lA'

alias ncsu='ssh -Y bpcottin@remote-linux.eos.ncsu.edu'

alias trilug='ssh -Y spiffytech@pilot.trilug.org'
alias xa='ssh -Y -p 1122 ncsuxa@xa-ncsu.com'
alias sbox='ssh root@files.spiffyte.ch'
alias short='ssh spiffytech@short.csc.ncsu.edu'

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi

alias s='sudo su -'
alias grep='grep --color="auto"'
alias ssh='ssh -Y'

alias gcc='gcc -Wall -std=c99'

function duf {  
    # This function mimics `du` but sorts by human-readable size
    # From here: http://www.earthinfo.org/linux-disk-usage-sorted-by-size-and-human-readable/
    du -k "$@" | sort -n | while read size fname; do for unit in k M G T P E Z Y; do if [ $size -lt 1024 ]; then echo -e "${size}${unit}\t${fname}"; break; fi; size=$((size/1024)); done; done
}


source /etc/bash_completion
fortune
