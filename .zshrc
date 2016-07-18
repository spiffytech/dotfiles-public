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
export HISTFILE=$ZDOTDIR/.zsh_history
export HISTSIZE=100000
export SAVEHIST=100000
setopt appendhistory  # Append to history
setopt histignorespace  # Don't store commands beginning with a space in the history file
setopt inc_append_history  # Append immediately
setopt hist_expire_dups_first # expire duplicates in history first
setopt hist_ignore_dups # don't add dupes to history


# completion and expansion stuff
setopt PROMPT_SUBST
setopt EXTENDED_GLOB  # Needed to permit case-insensitive globbing. see `man zshexpn` for more info.
setopt correct  # Offer to correct mistyped commands
setopt auto_list  # Automatically list choices on an ambiguous completion
setopt AUTO_CD # If you type a dir whose name isn't a command, automatically cd into the dir
setopt EXTENDED_HISTORY  # Save each command’s beginning timestamp (in seconds since the epoch) and the duration (in seconds) to the history file
zstyle ':completion:*:functions' ignored-patterns '_*'  # Ignore completion functions for commands you don't have
zstyle ':completion:*:(rm|kill|diff|vimdiff):*' ignore-line yes
autoload -U compinit
compinit

# Tab-complete command parameters from man pages
zstyle ':completion:*:manuals'    separate-sections true
zstyle ':completion:*:manuals.*'  insert-sections   true
zstyle ':completion:*:man:*'      menu yes select

# OS detection
OS=`uname`

# Misc
if [[ $OS != 'Darwin' ]]; then
    `hash xset 2>/dev/null`
    has_xset=$?
    if [ $has_xset -eq 0 ]; then
        unsetopt beep && xset b off  # Don't beep
    fi
fi
unsetopt hup  # Don't kill background jobs when the shell exits
# Only does user + system time, not wall time, sadly. http://superuser.com/questions/656820/is-there-a-way-to-print-out-execution-time-wall-time-in-zsh-when-it-exceeds-ce
REPORTTIME=10  # Report the time taken by a command that runs longer than n seconds
TIMEFMT="%U user %S system %P cpu %*Es total"  # Format for the time report


# Load the foreground/background color hash table
autoload colors zsh/terminfo
if [[ "$terminfo[colors]" -ge 8 ]]; then
  colors
fi


# Personal stuff
# ==============
OS=`uname`

# Paths and files
if [ $OS = 'Darwin' ]; then
else
    ARCH=`arch`
    if [ $ARCH = 'i686' ]; then
    else
    fi
fi
PATH=$PATH:/sbin/:/usr/sbin


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
alias hgrep='history | grep -iP'

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


export HASTE_SERVER=http://haste.spiffyte.ch
haste() { 
    tmpFile=`mktemp`
    cat > $tmpFile
    curl -X POST -s --data-binary "@$tmpFile" $HASTE_SERVER/documents | awk -F '"' '{print ENVIRON["HASTE_SERVER"]"/"$4}'
    rm $tmpFile
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

has_keychain=`hash keychain 2>/dev/null`
has_keychain=$?
if [ $has_keychain -eq 0 ]; then
    eval $(keychain --eval --agents ssh -Q --quiet ~/.ssh/id*~*pub)
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

    remote_ssh_config_dir=/tmp/tmp_ssh_config_`hostname`
    proxy_host=sbox.spiffy.tech

    if [ $has_mosh -eq 0 ]; then
        rsync -avhP ~/.ssh/ spiffytech@$proxy_host:$remote_ssh_config_dir/
        mosh spiffytech@$proxy_host -- /bin/bash -c "cd $remote_ssh_config_dir && ssh -o StrictHostKeyChecking=no -F $remote_ssh_config_dir/config $@"
        ssh $proxy_host rm -rf $remote_ssh_config_dir
    else
        ssh $@
    fi

    if [ $has_tmux -eq 0 ]; then
        tmux set automatic-rename on > /dev/null
    fi
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

if [ -r $HOME/.dircolors ]; then
    eval `dircolors -b $HOME/.dircolors`
fi

#$ZDOTDIR/bin/screenfetch.sh
#node $ZDOTDIR/bin/loudbot.js


# These have to come down here for some reason. I presume they get overwritten if you set them higher up.
bindkey '5C' emacs-forward-word
bindkey '5D' emacs-backward-word

export DV=~/devops/chef/solo/

alias foodcritic="foodcritic -t '~FC001'"

alias npm-exec='PATH=$(npm bin):$PATH'

export YDFOLDER=~/Documents/youthdigital/ws/
export YDKEYSDIR=~/.ssh/youthdigital
[[ -e $YDfOLDER/misc/yd.sh ]] && source $YDFOLDER/misc/yd.sh
[[ -e ~/.local.sh ]] && source ~/.local.sh

autoload zargs  # zsh alternative to xargs that accepts zsh globs instead of relying on 'find'

export TERM=konsole-256color

function lintDirty {
    for f in `git status --short | grep -P '.php$' | awk -F' ' '{print $2}'`; do dockerrun php -l $f; done
}

# Support latest version of git, if available
gitpath=`ls -d ~/Documents/programs/cloned/git*(om[1])`
export PATH=$gitpath:$gitpath/contrib/diff-highlight:$PATH
export PATH=~/bin:$PATH
