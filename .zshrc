# zsh options
# ===========
export HISTFILE=~/.zsh_history
export HISTSIZE=100000
export SAVEHIST=100000
setopt appendhistory  # Append to history
setopt inc_append_history  # Append immediately
setopt hist_expire_dups_first # expire duplicates in history first
setopt hist_ignore_dups # don't add dupes to history

#bindkey '^[[Z' reverse-menu-complete  # Shift-tab
#bindkey '5D' emacs-backward-word
#bindkey '5C' emacs-forward-word

setopt correct  # Offer to correct mistyped commands
setopt auto_list  # Automatically list choices on an ambiguous completion

unsetopt beep  # Don't beep

zstyle ':completion:*:functions' ignored-patterns '_*'  # Ignore completion functions for commands you don't have
zstyle ':completion:*:(rm|kill|diff|vimdiff):*' ignore-line yes

# If you type a dir whose name isn't a command, automatically cd into the dir
setopt AUTO_CD
autoload -U compinit
compinit

# Load the foreground/background color hash table
autoload colors zsh/terminfo
if [[ "$terminfo[colors]" -ge 8 ]]; then
  colors
fi


# Personal stuff
# ==============

export LEDGER=/home/brian/Documents/money/ledger.dat
export LEDGER_PRICE_DB=/home/brian/Documents/money/stock_quotes.dat

# Command aliases
alias ls='ls --color=auto'
alias ll='ls -l'
alias la='ls -lA'
alias s='sudo su -'
alias grep='grep --color="auto"'
alias rm='rm -I'
alias ssh='ssh -Y'
alias gcc='gcc -Wall -std=c99'
alias cronedit='crontab -e'
alias vi=vim
alias ack='ack --type-add php=.tpl'
alias dc='sl'
# Location aliases
alias -g ...='../..'
alias -g ....='../../..'
alias -g .....='../../../..'
alias -g L=" | less"
alias -g T=" | tail"

# File extension openers
alias -s tex=vim
alias -s txt=vim
alias -s py=python
alias -s pdf=okular
alias -s tc=truecrypt
alias -s rpm="sudo yum install"
alias -s tar.gz=dtrx
alias -s tar.bz2=dtrx
alias -s rar=dtrx
alias -s zip=dtrx
alias -s 7z=dtrx

# Server aliases
alias ncsu='ssh -YC bpcottin@remote-linux.eos.ncsu.edu'
alias trilug='ssh -YC spiffytech@pilot.trilug.org'
alias xa='ssh -Y -p 1122 ncsuxa@xa-ncsu.com'
alias sbox='ssh -XC root@files.spiffyte.ch'
alias short='ssh -XC spiffytech@short.csc.ncsu.edu'
alias char='ssh _XC spiffytech@char.csc.ncsu.edu'
alias bobby='ssh -X spiffytech@bobby.spiffyte.ch -p 7000'

## Ultimus RDP aliases
#alias uss-bpm2008='rdesktop -g 1280x1024 -u bcottingham -d ultimus.com -p - -r "disk:spiffytop=/home/brian" -P -z -x l uss-BPM2008.ultimus.com'
#alias uss-bpm2008-low-res='rdesktop -g 1024x768 -u bcottingham -d ultimus.com -p - -r "disk:spiffytop=/home/brian" -P -z -x l uss-BPM2008.ultimus.com'
#alias uss-bpm2008-native='rdesktop -g 1280x800 -u bcottingham -d ultimus.com -p - -r "disk:spiffytop=/home/brian" -P -z -x l uss-BPM2008.ultimus.com'
#alias ultimus-workstation='rdesktop -f -u bcottingham -d ultimus.com -p - -r "disk:spiffytop=/home/brian" -P -z -x l 192.168.0.109'
##alias connect-ultimus='cd ~/slackbuilds/openconnect/openconnect && sudo ./openconnect -b -s /etc/vpnc/vpnc-script -u bcottingham usvpn.ultimus.com && cd ~/Documents/ultimus/incident_launcher'
#alias connect-ultimus='sudo openconnect --no-cert-check -b -s /etc/vpnc/vpnc-script -u bcottingham usvpn.ultimus.com'
##alias connect-ultimus='cd ~/slackbuilds/openconnect/openconnect && sudo sudo ./openconnect -b -s /etc/vpnc/vpnc-script -u bcottingham usvpn.ultimus.com && cd ~/Documents/ultimus/incident_launcher && sshfs bcottingham@194.168.0.109:/cygdrive/c/Documents\ and\ Settings/bcottingham/My\ Documents /home/brian/Documents/ultimus/incident_launcher/mount/'

PATH=$PATH:/usr/local/bin:~/bin
#export OPCODEDIR64=/usr/local/lib/csound/plugins64

export EDITOR=vim
bindkey -e  # Override the viins line editor setting the previous line sets with the normal emacs-style line editor

setopt PROMPT_SUBST

#Autoload zsh functions.
fpath=(~/.zsh/functions $fpath)
autoload -U ~/.zsh/functions/*(:t)
 
# Enable auto-execution of functions.
typeset -ga preexec_functions
typeset -ga precmd_functions
typeset -ga chpwd_functions
 
# Append git functions needed for prompt.
preexec_functions+='preexec_update_git_vars'
precmd_functions+='precmd_update_git_vars'
chpwd_functions+='chpwd_update_git_vars'


#PROMPT="
#
#%(?.%{${fg[green]}%}.%{${fg[red]}%}) %~ %* %n@%M
#
#$GITBRANCH$FOSSILBRANCH$ %{${fg[default]}%}"
PROMPT="

%(?.%{${fg[green]}%}.%{${fg[red]}%}) %~ %* %n@%M

$(prompt_git_info)$ %{${fg[default]}%}"

REPORTTIME=10  # Report the time taken by a command that runs longer than n seconds
TIMEFMT="%U user %S system %P cpu %*Es total"

vim() {  # Sets the tmux window title when you open a file in Vim
    if [ -e /usr/bin/tmux ]; then
        filename=`echo ${@:-1} | awk -F'/' '{print $NF}'`  # We don't want the whole path to the file- just the filename
        tmux rename-window $filename
    fi

    if [ -e /usr/bin/vimx ]; then 
        /usr/bin/vimx $@
    else 
        if [ -e /usr/bin/vim ]; then
            /usr/bin/vim $@

        else
            ~/bin/vim $@
        fi
    fi

    if [ -e /usr/bin/tmux ]; then
        tmux rename-window zsh
    fi
}
