if [ -z "$ZDOTDIR" ]; then 
    ZDOTDIR=$HOME
fi

export CLICOLOR=1;

## Load Antigen package manager
#source "$HOME/.antigen.zsh"
#antigen-use oh-my-zsh
#antigen-bundle arialdomartini/oh-my-git
##antigen theme arialdomartini/oh-my-git-themes oppa-lana-style
#antigen theme arialdomartini/oh-my-git-themes arialdo-granzestyle
#antigen-apply
#plugins=(oh-my-git)

# zsh options
# ===========
# history stuff
echo 1
export HISTFILE=$ZDOTDIR/.zsh_history
export HISTSIZE=100000
export SAVEHIST=100000
setopt appendhistory  # Append to history
setopt inc_append_history  # Append immediately
setopt hist_expire_dups_first # expire duplicates in history first
setopt hist_ignore_dups # don't add dupes to history
echo 2


# completion and expansion stuff
setopt PROMPT_SUBST
setopt EXTENDED_GLOB  # Needed to permit case-insensitive globbing. see `man zshexpn` for more info.
setopt correct  # Offer to correct mistyped commands
setopt auto_list  # Automatically list choices on an ambiguous completion
setopt AUTO_CD # If you type a dir whose name isn't a command, automatically cd into the dir
setopt cdspell  # Correct spelling mistakes when changing directories
setopt EXTENDED_HISTORY  # Save each command’s beginning timestamp (in seconds since the epoch) and the duration (in seconds) to the history file
zstyle ':completion:*:functions' ignored-patterns '_*'  # Ignore completion functions for commands you don't have
zstyle ':completion:*:(rm|kill|diff|vimdiff):*' ignore-line yes
autoload -U compinit
compinit
echo 3

# Tab-complete command parameters from man pages
zstyle ':completion:*:manuals'    separate-sections true
zstyle ':completion:*:manuals.*'  insert-sections   true
zstyle ':completion:*:man:*'      menu yes select
echo 4

# Misc
unsetopt beep && xset b off  # Don't beep
unsetopt hup  # Don't kill background jobs when the shell exits
# Only does user + system time, not wall time, sadly. http://superuser.com/questions/656820/is-there-a-way-to-print-out-execution-time-wall-time-in-zsh-when-it-exceeds-ce
REPORTTIME=10  # Report the time taken by a command that runs longer than n seconds
TIMEFMT="%U user %S system %P cpu %*Es total"  # Format for the time report


# Load the foreground/background color hash table
autoload colors zsh/terminfo
if [[ "$terminfo[colors]" -ge 8 ]]; then
  colors
fi
echo 5


# Personal stuff
# ==============
OS=`uname`

# Paths and files
#export LEDGER=/home/brian/Documents/money/ledger.dat
#export LEDGER_PRICE_DB=/home/brian/Documents/money/stock_quotes.dat
PATH=$PATH:/usr/local/bin:$ZDOTDIR/bin:~/Downloads/terraform_0.6.0_linux_amd64
export PATH=$PATH:/usr/local/go/bin
if [ $OS = 'Darwin' ]; then
    export PATH=/opt/local/bin:/opt/local/sbin:$PATH  # MacPorts stuff
    export PATH=$PATH:$HOME/bin/compiled/mac/x86_64
else
    ARCH=`arch`
    if [ $ARCH = 'i686' ]; then
        export PATH=$PATH:$HOME/bin/compiled/linux/x86
    else
        export PATH=$PATH:$HOME/bin/compiled/linux/x86_64
    fi
fi
PATH=$PATH:/sbin/:/usr/sbin
echo 6


# Aliases
# Command aliases
alias ll='ls -l'
alias la='ls -lA'
alias lah='ls -lAh'
if [ $OS = 'Darwin' ]; then
    alias ls='ls -G'
    alias cssh='~/Downloads/csshX-0.74/csshX'
    #alias weball='cssh --screen 2 brian@web{{1..2},{4..10}}.sourcekit.com'
else
    #alias weball='cssh brian@web{{1..2},{4..10}}.sourcekit.com'
    alias ls='ls --color=auto'
fi

alias s='sudo su -c "/usr/bin/env ZDOTDIR=$HOME zsh"'  # Makes root logins use my personal .zshrc and zsh scripts
alias grep='grep --color="auto"'
alias igrep='grep -i'
#alias ssh='ssh -Y'  # Automatic X forwarding  # Disabled because ssh-ident on sbox doesn't support it
alias gcc='gcc -Wall -std=c99'
alias cronedit='crontab -e'  # Since -e and -r are next to each other, and -r doesn't confirm before clearing your cron entries
alias vi=vim
alias ch='sl'  # Gimme teh trainz!
alias dp='python2.6 ~/Downloads/dreampie-1.1.1/dreampie'
alias hgrep='history | grep -iP'
alias update_dbdo='sudo /campaigns/php/bin/php /campaigns/src/ServerApps/dev_utilities/UpdateDBDO.php'
alias ir='sudo /campaigns/php/bin/php /campaigns/src/ServerApps/InstanceRunner.php'
alias unstick='node ~/bin/unstick.js'

# Location aliases
alias -g ...='../..'
alias -g ....='../../..'
alias -g .....='../../../..'
alias -g L=" | less"
alias -g T=" | tail"
alias -g VG=" | grep -v"
alias -g t2h=" | ansi2html.sh"
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
alias ncsu='mssh -YC bpcottin@remote-linux.eos.ncsu.edu'
alias trilug='mssh -YC spiffytech@pilot.trilug.org'
alias xa='mssh -Y -p 1122 ncsuxa@xa-ncsu.com'
#alias sbox='mssh -XC spiffytech@direct.spiffybox.spiffyte.ch'
alias sbox='mssh spiffytech@sbox.spiffyte.ch'
alias short='mssh spiffytech@short.csc.ncsu.edu'
alias share_file='scp $1 spiffytech@short.csc.ncsu.edu:apache/spiffyte.ch/docroot/applications/init/static/'
# Work aliases
alias mngw='mssh mn_gw'
alias chef11='mssh chef11'
alias dom0='mssh dom0'
alias app1='mssh app1'
echo 7

NW='/home/spiffytech/Documents/programs/npcworld_fsharp/'

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
echo 8

prompt_default_color="%(?.%{${fg[yellow]}%}.%{${fg[red]}%})"  # Red or green based on the exit status of the last command
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

%{$prompt_default_color%}%~ %* %{${fg[$prompt_user]}%}%n%{$prompt_default_color%}@%{${fg[$prompt_host]}%}%M%{$prompt_default_color%} ${vcs_info_msg_0_}_

$ %{${fg[default]}%}'
echo 9


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

spm() {
    /campaigns/php/bin/php /campaigns/src/ServerApps/dev_utilities/GetSendsPerMinute.php -c $1 --campaignid $2
}


export HASTE_SERVER=http://haste.spiffyte.ch
haste() { 
    tmpFile=`mktemp`
    cat > $tmpFile
    curl -X POST -s --data-binary "@$tmpFile" $HASTE_SERVER/documents | awk -F '"' '{print "http://haste.spiffyte.ch/"$4}'
    rm $tmpFile
}


unstick-trigger() {
    instance_run_command.sh $1 "update triggers set lock_id='' where lock_id='$2';"
}


alias ack='ack --type-set tpl=.tpl --type-add tpl=.xtpl --type-add php=.tpl --type-add php=.xtpl --type-add html=.tpl --type-add html=.xtpl --type-set less=.less --ignore-dir=zend --ignore-dir=adodb --ignore-dir=PHPExcel --ignore-dir=cases.nonworking --ignore-dir=phpQuery --ignore-dir=swiftmail --ignore-dir=pear --ignore-dir=languages'

coffeewatch() {
    while true; do
        inotifywait --format '%w' -qe modify -e create **/*.coffee
        for f in `ls **/*.coffee`; do
            echo "Recompiling $f"
            jsfile=${f%.*}.js
            jsfilename=`basename $jsfile`
            jsdirname=`dirname $jsfile`
            coffeefilename=`basename $f`

            coffee --js -i $f > $jsfile && 
            cd $jsdirname
            echo '' >> $jsfilename
            echo '//@ sourceMappingURL='$jsfilename'.map' >> $jsfilename
            coffee --source-map -i $coffeefilename > $jsfilename.map
            cd - >> /dev/null
        done 
        echo 
    done
}


# Sets the tmux window title when you open a file in Vim
function vim {
    has_tmux=`hash tmux 2>/dev/null`
    has_tmux=$?
    if [ $has_tmux -eq 0 ]; then
        filename=`echo ${@:-1} | awk -F'/' '{print $NF}' | cut -d '+' -f 1`  # We don't want the whole path to the file- just the filename. Also, remove Vim line number from filename
        filename=`echo $filename`  # Remove trailing whitespace
        tmux rename-window $filename
    fi

    has_vimx=`hash vimx 2>/dev/null`
    has_vimx=$?
    if [ $has_vimx -eq 0 ]; then
        vimx $@
    else 
        if [ -e /usr/local/bin/vim ]; then
            /usr/local/bin/vim $@
        elif [ -e /usr/bin/vim ]; then
            /usr/bin/vim $@
        else
            $ZDOTDIR/bin/vim $@
        fi
    fi

    if [ $has_tmux -eq 0 ]; then
        #tmux set-window-option automatic-rename on > /dev/null
        tmux set-window-option automatic-rename on
    fi
}
v() {vim $@}

has_keychain=`hash keychain 2>/dev/null`
has_keychain=$?
if [ $has_keychain -eq 0 ]; then
    eval $(keychain --eval --agents ssh -Q --quiet ~/.ssh/id*~*pub ~/.ssh/*.pem)
else
    alias ssh='ssh-ident'
    alias rsync='/usr/bin/rsync -e ssh-ident'
fi
# Sets the tmux window title when you SSH somewhere
mssh() {
    `hash tmux 2>/dev/null`
    has_tmux=$?

    `hash mosh 2>/dev/null`
    has_mosh=$?

    if [ $has_tmux -eq 0 ]; then
        ## Replace tmux window name with host you're connecting to
        # Below trick should replace this, since mssh doesn't take any parameters besides a host
        #host=`echo $@ | sed 's/.* \([[:alnum:].]\{1,\}@[[:alnum:].]\{1,\}\).*/\1/g' | sed 's/.*@\([^.]*\).*/\1/'`
        #if [ ! -n $host ] 
        #then
        #    host="ssh"
        #fi
        host=$1  # mssh doesn't take any parameters besides a host, so this should work

        tmux rename-window $host
    fi

    if [ $has_mosh -eq 0 ]; then
        scp ~/.ssh/config spiffytech@direct.spiffybox.spiffyte.ch:/tmp/tmp_ssh_config
        #mosh spiffytech@direct.spiffybox.spiffyte.ch -- ssh-ident -o StrictHostKeyChecking=no -F /tmp/tmp_ssh_config $@
        mosh spiffytech@direct.spiffybox.spiffyte.ch -- ssh -o StrictHostKeyChecking=no -F /tmp/tmp_ssh_config $@
    else
        #`which -a ssh | tail -n 1` $@
        ssh $@
    fi

    if [ $has_tmux -eq 0 ]; then
        tmux set automatic-rename on > /dev/null
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


function tssh {
    for server in $@
    do
        tmux send-keys "ssh $server"
        tmux send-keys "Enter"
        tmux select-layout tiled
        tmux split-window
    done
    tmux kill-pane
    tmux set-window-option synchronize-panes on 
}

function weball {
    tssh brian@web{{1..2},4,{6..10}}.sourcekit.com $@
}
function apiall {
    tssh brian@web{1,2,7,9,10}.sourcekit.com $@
}
function websome {
    tssh brian@web{7..10}.sourcekit.com $@
}
function sendall {
    tssh brian@send{3..4}.sourcekit.com $@
}
function codeall {
    tssh brian@{web{{1..2},4,{6..10}},{vulcan,mercury,camelot,shangrila}}.sourcekit.com $@
}
function allservers {
    tssh brian@{web{{1..2},4,{6..10}},send{1..4},{vulcan,mercury,camelot,shangrila}}.sourcekit.com $@
}


#$ZDOTDIR/bin/screenfetch.sh

echo 10
#$ZDOTDIR/bin/screenfetch.sh
#echo
PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting
#node $ZDOTDIR/bin/loudbot.js

source $ZDOTDIR/.zsh/git-flow-completion.zsh
echo 11

# These have to come down here for some reason. I presume they get overwritten if you set them higher up.
bindkey '5C' emacs-forward-word
bindkey '5D' emacs-backward-word

export DV=~/devops/chef/solo/

alias foodcritic="foodcritic -t '~FC001'"

source ~/.yd.sh
