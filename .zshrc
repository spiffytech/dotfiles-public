# zsh options
# ===========
# history stuff
export HISTFILE=~/.zsh_history
export HISTSIZE=100000
export SAVEHIST=100000
setopt appendhistory  # Append to history
setopt inc_append_history  # Append immediately
setopt hist_expire_dups_first # expire duplicates in history first
setopt hist_ignore_dups # don't add dupes to history


# completion and expanstion stuff
setopt PROMPT_SUBST
setopt EXTENDED_GLOB  # Needed to permit case-insensitive globbing. see `man zshexpn` for more info.
setopt correct  # Offer to correct mistyped commands
setopt auto_list  # Automatically list choices on an ambiguous completion
setopt AUTO_CD # If you type a dir whose name isn't a command, automatically cd into the dir
zstyle ':completion:*:functions' ignored-patterns '_*'  # Ignore completion functions for commands you don't have
zstyle ':completion:*:(rm|kill|diff|vimdiff):*' ignore-line yes
autoload -U compinit
compinit


#bindkey '^' reverse-menu-complete  # Shift-tab
#bindkey "^${key[Left]}" emacs-backward-word
#bindkey '^^[[5C' emacs-forward-word


# Misc
unsetopt beep  # Don't beep
unsetopt hup  # Don't kill background jobs when the shell exits
REPORTTIME=10  # Report the time taken by a command that runs longer than n seconds
TIMEFMT="%U user %S system %P cpu %*Es total"  # Format for the time report


# Load the foreground/background color hash table
autoload colors zsh/terminfo
if [[ "$terminfo[colors]" -ge 8 ]]; then
  colors
fi


# Personal stuff
# ==============

# Paths and files
export LEDGER=/home/brian/Documents/money/ledger.dat
export LEDGER_PRICE_DB=/home/brian/Documents/money/stock_quotes.dat
PATH=$PATH:/usr/local/bin:~/bin
#export OPCODEDIR64=/usr/local/lib/csound/plugins64

# Aliases
# Command aliases
alias ls='ls --color=auto'
alias ll='ls -l'
alias la='ls -lA'
alias s='sudo su -'
alias grep='grep --color="auto"'
alias rm='rm -I'
alias ssh='ssh -Y'  # Automatic X forwarding
alias gcc='gcc -Wall -std=c99'
alias cronedit='crontab -e'  # Since -e and -r are next to each other, and -r doesn't confirm before clearing your cron entries
alias vi=vim
alias ack='ack --type-add php=.tpl'
alias dc='sl'  # Gimme teh trainz!
# Location aliases
alias -g ...='../..'
alias -g ....='../../..'
alias -g .....='../../../..'
alias -g L=" | less"
alias -g T=" | tail"
alias history='history 1000'  # By default, `history` only shows a handful of recent commands
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
alias share_file='scp $1 spiffytech@short.csc.ncsu.edu:apache/spiffyte.ch/docroot/applications/init/static/'

export EDITOR=vim
bindkey -e  # Override the viins line editor setting the previous line sets with the normal emacs-style line editor


#Autoload zsh functions.
fpath=(~/.zsh/functions $fpath)
autoload -U ~/.zsh/functions/*(:t)
 
# Enable auto-execution of functions.
typeset -ga preexec_functions
typeset -ga precmd_functions
typeset -ga chpwd_functions
 
## Append git functions needed for prompt.
#preexec_functions+='preexec_update_git_vars'
#precmd_functions+='precmd_update_git_vars'
#chpwd_functions+='chpwd_update_git_vars'


# Set the prompt
PROMPT="

%(?.%{${fg[green]}%}.%{${fg[red]}%}) %~ %* %n@%M

$(prompt_git_info)$ %{${fg[default]}%}"



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

# Fix special keys like home, end page-up, page-down
autoload zkbd
function zkbd_file() {
    [[ -f ~/.zkbd/${TERM}-${VENDOR}-${OSTYPE} ]] && printf '%s' ~/".zkbd/${TERM}-${VENDOR}-${OSTYPE}" && return 0
    [[ -f ~/.zkbd/${TERM}-${DISPLAY}          ]] && printf '%s' ~/".zkbd/${TERM}-${DISPLAY}"          && return 0
    return 1
}

[[ ! -d ~/.zkbd ]] && mkdir ~/.zkbd
keyfile=$(zkbd_file)
ret=$?
if [[ ${ret} -ne 0 ]]; then
    zkbd
    keyfile=$(zkbd_file)
    ret=$?
fi
if [[ ${ret} -eq 0 ]] ; then
    source "${keyfile}"
else
    printf 'Failed to setup keys using zkbd.\n'
fi
unfunction zkbd_file; unset keyfile ret

# setup key accordingly
[[ -n "${key[Home]}"    ]]  && bindkey  "${key[Home]}"    beginning-of-line
[[ -n "${key[End]}"     ]]  && bindkey  "${key[End]}"     end-of-line
[[ -n "${key[Insert]}"  ]]  && bindkey  "${key[Insert]}"  overwrite-mode
[[ -n "${key[Delete]}"  ]]  && bindkey  "${key[Delete]}"  delete-char
[[ -n "${key[Up]}"      ]]  && bindkey  "${key[Up]}"      up-line-or-history
[[ -n "${key[Down]}"    ]]  && bindkey  "${key[Down]}"    down-line-or-history
[[ -n "${key[Left]}"    ]]  && bindkey  "${key[Left]}"    backward-char
[[ -n "${key[Right]}"   ]]  && bindkey  "${key[Right]}"   forward-char
