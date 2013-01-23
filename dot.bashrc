#=======================================================================================================================================================
# system settings
#=======================================================================================================================================================
if [[ $OSTYPE == 'linux-gnu' ]]; then
    #===================================================================================================================================================
    # specific linux settings
    #===================================================================================================================================================
    # see /usr/share/doc/bash/examples/startup-files for examples
    export EDITOR="gvim"

    # Add an "alert" alias for long running commands.  Use like so: sleep 10; alert
    alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
else
    #===================================================================================================================================================
    # specific macbook settings
    #===================================================================================================================================================
    export EDITOR="mvim"
    export ARCHFLAGS="-arch x86_64"
    export PATH="/usr/local/opt/coreutils/libexec/gnubin:~/.gem/bin:$PATH"
    export MANPATH="/usr/local/opt/coreutils/libexec/gnuman:$MANPATH"

    # Load RVM function
    [[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm"

    # jmeter
    alias jmeter='~/Documents/jmeter/2.8/bin/jmeter &'

    # functions
    function pkill() {
        local pid
        pid=$(ps ax | grep $1 | grep -v grep | awk '{ print $1 }')
        kill -9 $pid
    }

    # auto complete
    source ~/.git_completion
    source $(brew --repository)/Library/Contributions/brew_bash_completion.sh
fi

#=======================================================================================================================================================
# global settings
#=======================================================================================================================================================
export GREP_OPTIONS="--color=auto"
export GREP_COLOR="4;31"
export HISTCONTROL=ignoredups:ignorespace
export HISTSIZE=1000
export HISTFILESIZE=2000
export PS1='\[\e[01;33m\]\u\[\e[01;37m\]@\[\e[01;36m\]\h\[\e[01;37m\]:\[\e[01;34m\]\w\[\033[31m\]$(dev_environment)\[\e[0m\]\$ '
export GIT_EDITOR=$EDITOR
export GEM_HOME=~/.gem
export CLICOLOR="auto"
shopt -s histappend    # append to the history file, don't overwrite it
shopt -s checkwinsize  # check the window size after each command and, if necessary, update the values of LINES and COLUMNS.
shopt -s cdspell       # corrects dir names mistakes in the cd command
complete -cf sudo

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# enable color support to coreutils and darwin default shell
if [ -f ~/.dircolors ]; then
    . ~/.dircolors;
fi

#=======================================================================================================================================================
# global aliases
#=======================================================================================================================================================
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

#=======================================================================================================================================================
# global auto complete
#=======================================================================================================================================================
if [ -f ~/.bash_completion ]; then
    . ~/.bash_completion;
fi

# enable programmable completion features (you don't need to enable this, if it's already enabled in /etc/bash.bashrc and /etc/profile sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

#complete -C ~/.rake_cap_bash_completion -o default rake

#=======================================================================================================================================================
# global functions
#=======================================================================================================================================================
#function rake() {
#    if [ -e ./Gemfile.lock ]; then
#        bundle exec rake "$@";
#    else 
#        /usr/bin/env rake "$@";
#    fi;
#}

function ws() {
    if [[ $1 = 'update_all' ]]; then
        echo -e '\e[1;33m========>>>>>>>>>>-------------------------------<<<<<<<<<<========\e[0m'
        echo -e '\e[1;33m========>>>>>>>>>>\e[0m \e[5;31mAtualizando TODOS os projetos\e[0m \e[1;33m<<<<<<<<<<========\e[0m'
        echo -e '\e[1;33m========>>>>>>>>>>-------------------------------<<<<<<<<<<========\e[0m'
        cd ~/workspace
        ls -1 | while read line; do cd $line; pwd; git pull; cd ..; done;
        echo -e '\e[1;33m========>>>>>>>>>>-------------------------------<<<<<<<<<<========\e[0m'
    else
        cd ~/workspace/$1
    fi
}

function dev_environment() {
    local git_branch=$(git branch 2>/dev/null | grep -e '^*' | sed -E 's/^\* (.+)$/\1/')
    local rvm_prompt=$(rvm-prompt i v)

    if [[ ! -z $git_branch ]]; then
        if [[ ! -z $rvm_prompt ]]; then
            echo "($git_branch$(detect_git_dirty)|$rvm_prompt)"
        else
            echo "($git_branch$(detect_git_dirty))"
        fi
    fi
}

function detect_git_dirty {
  local git_status=$(git status 2>&1 | tail -n1)
  [[ $git_status != "fatal: Not a git repository (or any of the parent directories): .git" ]] && [[ $git_status != "nothing to commit, working directory clean" ]] && echo "*"
}

##=========================
#function detect_rvm_version {
#  local gemset=$(echo $GEM_HOME | awk -F'@' '{print $2}')
#  [ "$gemset" != "" ] && gemset="@$gemset"
#  local version=$(echo $MY_RUBY_HOME | awk -F'-' '{print $2}')
#  [ "$version" != "" ] && version="$version"
#  local full="$version$gemset"
#  [ "$full" != "" ] && echo "$full"
#}
#
#function detect_git_branch {
#  git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/\1/"
#}
#
#function dev_info {
#  echo "[$(detect_rvm_version) $(detect_git_branch)$(detect_git_dirty)]"
#}

## Colors
#txtred='\e[0;31m' # Red
#txtwht='\e[0;37m' # White
#txtrst='\e[0m'    # Text Reset
#
# Custom command prompt
#export PS1="\[$txtwht\]\w \[$txtred\]\$(dev_info) \[$txtrst\]"

# vim:ft=sh:tabstop=4:shiftwidth=4:
