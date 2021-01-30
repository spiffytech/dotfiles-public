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
PATH=$PATH:/sbin/:/usr/sbin:$HOME/bin

# Aliases
# Command aliases
alias ll='ls -l'
alias la='ls -lA'
alias lah='ls -lAh'
if [ $OS = 'Darwin' ]; then
    alias ls='ls -G'
else
    alias ls='ls --color=auto'
fi

alias gs='git status'
alias gd='git diff'
alias gdc='git diff --cached'
alias gc='git commit'
alias ga='git add'
alias gl='git log'
alias gp='git push'
alias gpu='git pull'

alias s='sudo su -c "/usr/bin/env ZDOTDIR=$HOME zsh"'  # Makes root logins use my personal .zshrc and zsh scripts
alias grep='grep --color="auto"'
alias gcc='gcc -Wall -std=c99'

alias versionsort='sort -t. -k 1,1n -k 2,2n -k 3,3n -k 4,4n'

# Always do PCRE grep, except on Mac (BSD grep doesn't have that)
if [[ $OS == 'Darwin' ]]; then
    alias hgrep='history | rg'
else
    alias hgrep='history | grep -iP'
fi

# This breaks Windows WSL, ChromeOS terminal
#alias tmux='TERM=screen-256color tmux -2'
alias tmuxinator='TERM=xterm-256color tmuxinator'
alias ag='ag --path-to-ignore ~/.agignore'
alias rg='rg --smart-case'

# Location aliases
alias -g L=" | less"
alias -g T=" | tail"
alias -g t2h=" | ansi2html.sh"
alias history='history 1'  # Shows complete shell history instead of a limited number of results

# Server aliases
alias trilug='mssh -YC spiffytech@pilot.trilug.org'
#alias sbox='mssh -XC spiffytech@direct.spiffybox.spiffyte.ch'
alias sbox='mssh spiffytech@sbox.spiffyte.ch'
alias short='mssh spiffytech@short.csc.ncsu.edu'

# EC2 API utils
alias awstags="jq 'map(.Tags = (.Tags // [] | from_entries))'"
alias extractinstances="jq '.Reservations | map(.Instances) | flatten'"
function checkAwsCredentials() {
    aws sts get-caller-identity > /dev/null
    if [[ $? -ne 0 ]]; then echo "invalid credentials"; return 1; fi
}
function getinstances() {
    checkAwsCredentials &&
    CACHEPERIOD=${CACHEPERIOD:-300} runcached aws ec2 describe-instances $@ |
    extractinstances |
    awstags |
    jq 'sort_by(.Tags?.Name)'
}
function byname() {
    local name=$1
    jq 'map(select(.Tags.Name // "" | test("^'$name'$"; "i")))'
}
function bygroup () {
    local group=$1
    jq 'map(select(.SecurityGroups | map(.GroupName | test("'$group'"; "i")) | any))'
}
# Pass in extra map keys/values items in $@
# If an argument is a simple property (e.g., .Tags?.Name), you don't need to provide a key
function simpleinstance() {
    extraStr=""
    for extra in "$@"; do
        # Simple properties
        if [[ $extra =~ "^\.[^ ]+$" ]]; then
            extraStr+=", $(echo $extra | tr "." "_" | tr "?" "_"): $extra"
        else
            extraStr+=", ${extra}"
        fi
    done
    jq 'map({Name: .Tags?.Name, Environment: .Tags?.Environment, IP: (.NetworkInterfaces[] | .PrivateIpAddresses[] | .PrivateIpAddress) '$extraStr'})';
}
function findinstances() {
    local name=$1
    local group=${2:-}
    byname $name | bygroup $group
    byname $name
}

##############
# Prompt stuff
##############

autoload -Uz vcs_info
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' enable git svn  # See this for more info: man zshcontrib | less -p GATHERw

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


has_tmux=`hash kubectl 2>/dev/null`
if [[ $? -eq 0 ]]; then
    kubeprompt="($(kubectl config current-context))"
else
    kubeprompt=
fi

# Set the prompt
zstyle ':vcs_info:git*' formats "%r %b %m%{$fg[red]%}%u%{$fg[green]%}%c%{$prompt_default_color%}"

if [ `whoami` = "root" ]
then
    user_color="red"
else
    usercolor="green"
fi
PROMPT='

%{$prompt_default_color%}%~ %* %{${fg[$prompt_user]}%}%n%{$prompt_default_color%}@%{${fg[$prompt_host]}%}%M%{$prompt_default_color%} ${vcs_info_msg_0_}%{$prompt_default_color%} ${kubeprompt}

$ %{${fg[default]}%}'


export HASTE_SERVER=http://haste.spiffyte.ch
haste() { 
    tmpFile=`mktemp`
    cat > $tmpFile
    curl -X POST -s --data-binary "@$tmpFile" $HASTE_SERVER/documents | awk -F '"' '{print ENVIRON["HASTE_SERVER"]"/"$4}'
    rm $tmpFile
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

function ag {
    echo "Tried using ag. Use ripgrep"
    return 1
}

function tssh {
    for server in $@
    do
        tmux send-keys "ssh $server"
        #tmux send-keys "Enter"
        tmux select-layout tiled
        tmux split-window
    done
    tmux kill-pane
    tmux set-window-option synchronize-panes on 
}

`hash dircolors 2>/dev/null`
has_dircolors=$?
if [[ -r $HOME/.dircolors && $has_dircolors -eq 0 ]]; then
    eval `dircolors -b $HOME/.dircolors`
fi

#$ZDOTDIR/bin/screenfetch.sh

export EDITOR=vim
bindkey -e  # Override the viins line editor setting the previous line sets with the normal emacs-style line editor

# Fix Ctrl-arrow keys
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word

alias foodcritic="foodcritic -t '~FC001'"

[[ -e ~/.local.sh ]] && source ~/.local.sh

autoload zargs  # zsh alternative to xargs that accepts zsh globs instead of relying on 'find'

#export TERM=konsole-256color

# Support latest version of git, if available
gitpath=`ls -d ~/cloned_programs/git*(om[1]N)`
if [[ $gitpath != "" ]]; then
    export PATH=$gitpath:$gitpath/contrib/diff-highlight:$PATH
fi
if [[ -d ~/.rbenv ]]; then
    export PATH="$HOME/.rbenv/shims:$PATH"
	source '/usr/local/Cellar/rbenv/1.1.0/libexec/../completions/rbenv.zsh'
	export RBENV_SHELL=zsh
	command rbenv rehash 2>/dev/null
fi

rbenv() {
  local command
  command="$1"
  if [ "$#" -gt 0 ]; then
    shift
  fi

  case "$command" in
  rehash|shell)
    eval "$(rbenv "sh-$command" "$@")";;
  *)
    command rbenv "$command" "$@";;
  esac
}

### MUST BE FINAL
# Add `npm bin` to path every time we change directories
OLDPATH=$PATH
LASTPATH=""
precmd() {
    vcs_info

    if [[ $LASTPATH != `pwd` ]]; then
        LASTPATH=`pwd`
        npm_bin=`npm bin`
        npm_exit=$?
        if [[ $npm_exit -eq 0 ]]; then
            export PATH=$OLDPATH:$npm_bin
        fi
    fi
}

# Set terminal colors _without_ relying on the terminal itself!
BASE16_SHELL=$HOME/.config/base16-shell/
[ -n "$PS1" ] && [ -s $BASE16_SHELL/profile_helper.sh ] && eval "$($BASE16_SHELL/profile_helper.sh)"
sh ~/.config/base16-shell/scripts/base16-harmonic-dark.sh  # Enables this theme

# Makes watch work with shell aliases
alias watch='watch '

vault-readwrite() {
    vault read -format json "$@" | jq -r '.data' > /tmp/data.json
    vim /tmp/data.json
    vault write "$@" @/tmp/data.json
    rm /tmp/data.json
}

ssl-verify() {
    HOST=$1
    PORT=$2
    openssl s_client -connect $HOST:$PORT -servername $HOST
}

ansible-make-role() {
    mkdir $1 && cd $1
    mkdir tasks handlers templates files defaults meta
    echo "---" > {handlers,meta,tasks,defaults}/main.yml
    cd ..
}

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_DEFAULT_COMMAND='rg --files --hidden --follow -g "!{.git,node_modules}/*" 2> /dev/null'

# Johnny Decimal tab completion
CDPATH=$(find $HOME/Documents* -maxdepth 0 -type d -print0 | xargs -0 printf "%s:")
