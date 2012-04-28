if [ -z "$ZDOTDIR" ]; then 
    ZDOTDIR=$HOME
fi

export CLICOLOR=1;


# zsh options
# ===========
# history stuff
export HISTFILE=$ZDOTDIR/.zsh_history
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
PATH=$PATH:/usr/local/bin:$ZDOTDIR/bin
export PATH=~/Documents/contactology-app/bin:~/Documents/contactology-app/php/bin:$PATH
#export OPCODEDIR64=/usr/local/lib/csound/plugins64

# Aliases
# Command aliases
alias ll='ls -l'
alias la='ls -lA'
alias lah='ls -lAh'
alias s='sudo su -c "/usr/bin/env ZDOTDIR=$HOME zsh"'  # Makes root logins use my personal .zshrc and zsh scripts
alias grep='grep --color="auto"'
alias rm='rm -I'
alias ssh='ssh -Y'  # Automatic X forwarding
alias gcc='gcc -Wall -std=c99'
alias cronedit='crontab -e'  # Since -e and -r are next to each other, and -r doesn't confirm before clearing your cron entries
alias vi=vim
alias ch='sl'  # Gimme teh trainz!
# Location aliases
alias -g ...='../..'
alias -g ....='../../..'
alias -g .....='../../../..'
alias -g L=" | less"
alias -g T=" | tail"
alias history='history 1'  # By default, `history` only shows a handful of recent commands. This shows all of them.
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
alias share_file='scp $1 spiffytech@short.csc.ncsu.edu:apache/spiffyte.ch/docroot/applications/init/static/'
alias avalon='ssh brian@avalon.sourcekit.com'
alias sprint='ssh brian@sprint.testology.net'
alias staging='ssh brian@staging.testology.net'
alias release='ssh brian@release.testology.net'
alias live='ssh brian@live.testology.net'
alias indigo='ssh brian@indigo.testology.net'
alias mercury='ssh brian@mercury.sourcekit.com'
alias vulcan='ssh brian@vulcan.sourcekit.com'
alias web1='ssh brian@web1.sourcekit.com'
alias web2='ssh brian@web2.sourcekit.com'
alias web3='ssh brian@web3.sourcekit.com'
alias web4='ssh brian@web4.sourcekit.com'
alias web5='ssh brian@web5.sourcekit.com'
alias web6='ssh brian@web6.sourcekit.com'
alias web7='ssh brian@web7.sourcekit.com'
alias web8='ssh brian@web8.sourcekit.com'
alias web9='ssh brian@web9.sourcekit.com'
alias web10='ssh brian@web10.sourcekit.com'

has_ack=`which ack`
has_ack=$?
if [ $has_ack -ne 0 ]; then
    has_ack_grep=`which ack-grep`
    has_ack_grep=$?
    if [ $has_ack_grep -ne 0 ]; then
        alias ack='ack-grep'
    fi
fi
alias ack='ack --type-add php=.tpl --type-add html=.tpl'

export EDITOR=vim
bindkey -e  # Override the viins line editor setting the previous line sets with the normal emacs-style line editor

##############
# Prompt stuff
##############

autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git svn  # See this for more info: man zshcontrib | less -p GATHER
function precmd {
    vcs_info
}

prompt_default_color="%(?.%{${fg[green]}%}.%{${fg[red]}%})"  # Red or green based on the exit status of the last command
prompt_user=$prompt_default_color
whoami | grep root > /dev/null
if [ `echo $?` -eq 0 ]; then
    prompt_user="cyan"
fi

prompt_host=$prompt_default_color
hostname | grep spiffy > /dev/null
if [ `echo $?` -ne 0 ]; then
    prompt_host="blue"
fi


# Set the prompt
if [ `whoami` = "root" ]
then
    user_color="red"
else
    usercolor="green"
fi
PROMPT='

%{$prompt_default_color%} %~ %* %{${fg[$prompt_user]}%}%n%{$prompt_default_color%}@%{${fg[$prompt_host]}%}%M%{$prompt_default_color%} ${vcs_info_msg_0_}_

$ %{${fg[default]}%}'


#Autoload zsh functions.
#fpath=($ZDOTDIR/.zsh/functions $fpath)
#autoload -U $ZDOTDIR/.zsh/functions/*(:t)
 
# Enable auto-execution of functions.
#typeset -ga preexec_functions
#typeset -ga precmd_functions
#typeset -ga chpwd_functions
 
## Append git functions needed for prompt.
#preexec_functions+='preexec_update_git_vars'
#precmd_functions+='precmd_update_git_vars'
#chpwd_functions+='chpwd_update_git_vars'


function ack {
    ack_which=`which -a ack | tail -n 1`
    if [ ! -f /usr/bin/ack ]; then
        if [ -f /campaigns/src/bin/codesearch ]; then
            /campaigns/src/bin/codesearch $@
        fi
    else
        ack_which $@
    fi
}
alias ack='ack --type-add php=.tpl --type-add html=.tpl'


# Sets the tmux window title when you open a file in Vim
function vim {
    has_tmux=`which tmux`
    has_tmux=$?
    if [ $has_tmux -eq 0 ]; then
        filename=`echo ${@:-1} | awk -F'/' '{print $NF}' | cut -d '+' -f 1`  # We don't want the whole path to the file- just the filename. Also, remove Vim line number from filename
        filename=`echo $filename`  # Remove trailing whitespace
        tmux rename-window $filename
    fi

    has_vimx=`which vimx`
    has_vimx=$?
    if [ $has_vimx -eq 0 ]; then
        vimx $@
    else 
        if [ -e /usr/bin/vim ]; then
            /usr/bin/vim $@

        else
            $ZDOTDIR/bin/vim $@
        fi
    fi

    if [ $has_tmux -eq 0 ]; then
        tmux set-window-option automatic-rename on
    fi
}
v() {vim($@)}


# Sets the tmux window title when you SSH somewhere
ssh() {
    tmux_which=`which tmux`
    has_tmux=$?
    if [ $has_tmux -eq 0 ]; then
        host=`echo $@ | pyp '[foo for foo in w if foo.count("@") > 0][0] | p.partition("@")[2] | p.split(".")[0].strip()'`
        if [ ! -n $host ] 
        then
            host="ssh"
        fi

        tmux rename-window $host
    fi

    `which -a ssh | tail -n 1` $@

    if [ $has_tmux -eq 0 ]; then
        tmux set automatic-rename on
    fi
}


function fix_keyboard {
    # Fix special keys like home, end page-up, page-down
    autoload zkbd
    function zkbd_file() {
        [[ -f $ZDOTDIR/.zkbd/${TERM}-${VENDOR}-${OSTYPE} ]] && printf '%s' $ZDOTDIR/".zkbd/${TERM}-${VENDOR}-${OSTYPE}" && return 0
        [[ -f $ZDOTDIR/.zkbd/${TERM}-${DISPLAY}          ]] && printf '%s' $ZDOTDIR/".zkbd/${TERM}-${DISPLAY}"          && return 0
        return 1
    }

    [[ ! -d $ZDOTDIR/.zkbd ]] && mkdir $ZDOTDIR/.zkbd
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

    # Setup key accordingly
    [[ -n "${key[Home]}"    ]]  && bindkey  "${key[Home]}"    beginning-of-line
    [[ -n "${key[End]}"     ]]  && bindkey  "${key[End]}"     end-of-line
    [[ -n "${key[Insert]}"  ]]  && bindkey  "${key[Insert]}"  overwrite-mode
    [[ -n "${key[Delete]}"  ]]  && bindkey  "${key[Delete]}"  delete-char
    [[ -n "${key[Up]}"      ]]  && bindkey  "${key[Up]}"      up-line-or-history
    [[ -n "${key[Down]}"    ]]  && bindkey  "${key[Down]}"    down-line-or-history
    [[ -n "${key[Left]}"    ]]  && bindkey  "${key[Left]}"    backward-char
    [[ -n "${key[Right]}"   ]]  && bindkey  "${key[Right]}"   forward-char
}

#$ZDOTDIR/bin/screenfetch.sh

has_keychain=`which keychain`
has_keychain=$?
if [ $has_keychain -eq 0 ]; then
    eval $(keychain --eval --agents ssh -Q --quiet id_rsa)
fi
