#=======================================================================================================================================================
# system settings
#=======================================================================================================================================================
if [[ $OSTYPE == 'linux-gnu' ]]; then
    #===================================================================================================================================================
    # specific linux settings
    #===================================================================================================================================================
    # see /usr/share/doc/bash/examples/startup-files for examples
    export EDITOR="gvim"
    PATH=$PATH:$HOME/.rvm/bin

    # Add an "alert" alias for long running commands.  Use like so: sleep 10; alert
    alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
else
    #===================================================================================================================================================
    # specific macbook settings
    #===================================================================================================================================================
    export EDITOR="mvim"
    export PATH="/usr/local/opt/coreutils/libexec/gnubin:~/.gem/bin:/usr/local/sbin:$PATH"
    export MANPATH="/usr/local/opt/coreutils/libexec/gnuman:$MANPATH"

    export ORACLE_HOME=~/instantclient
    export DYLD_LIBRARY_PATH=$ORACLE_HOME:$LD_LIBRARY_PATH
    export NLS_LANG=American_America.UTF8
    export PATH=$ORACLE_HOME:$PATH

    # nvm config
    if [ -f "$(brew --prefix nvm)/nvm.sh"  ]; then
        source $(brew --prefix nvm)/nvm.sh;
        export NVM_DIR=~/.nvm
    fi

    # Load RVM function
    [[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm"

    # functions
    function pkill() {
        local pid
        pid=$(ps ax | grep $1 | grep -v grep | awk '{ print $1 }')
        kill -9 $pid
    }

    # auto complete
    [[ -f $(brew --prefix)/etc/bash_completion ]] && . $(brew --prefix)/etc/bash_completion
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
[[ -f ~/.dircolors ]] && . ~/.dircolors;

# set github api token for homebrew
[[ -f ~/.github_api_token ]] && . ~/.github_api_token

#=======================================================================================================================================================
# global aliases
#=======================================================================================================================================================
[[ -f ~/.bash_aliases ]] && . ~/.bash_aliases

#=======================================================================================================================================================
# global auto complete
#=======================================================================================================================================================
[[ -f ~/.bash_completion ]] && . ~/.bash_completion;

# enable programmable completion features (you don't need to enable this, if it's already enabled in /etc/bash.bashrc and /etc/profile sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

#=======================================================================================================================================================
# global functions
#=======================================================================================================================================================

function ws() {
    if [[ $1 = 'update_all' ]]; then
        echo -e '\033[1;33m========>>>>>>>>>>---------------------------<<<<<<<<<<========\033[0m'
        echo -e '\033[1;33m========>>>>>>>>>>\033[0m \033[5;31m  Updating ALL projects  \033[0m \033[1;33m<<<<<<<<<<========\033[0m'
        echo -e '\033[1;33m========>>>>>>>>>>---------------------------<<<<<<<<<<========\033[0m'
        cd ~/workspace
        ls -1 | while read line; do
            if [[ -d "$line/.git" ]]; then
                cd $line; pwd; git pull; cd ..;
            else
                echo "$line is not git repo";
           fi
        done;
        echo -e '\033[1;33m========>>>>>>>>>>-------------------------------<<<<<<<<<<========\033[0m'
    else
        cd ~/workspace/$1
    fi
}

function token() {
    local _secret=`_config token $1`
    ruby -e "require 'rotp'; puts ROTP::TOTP.new('$_secret').now"
}

function mfa() {
    source ~/.aws/mfa.sh -p $1 `token $1`
}

function cluster() {
    local _jumpbox=`_config jumpbox $1`
    local pem="$HOME/.ssh/cluster_$1.pem"

    ssh-add $pem
    ssh -i $pem -A ec2-user@$_jumpbox
}

function vpn() {
    local VPNName='TapInfluence VPN'
    local isnt_connected=`scutil --nc status "$VPNName" | sed -n 1p | grep -v Connected`

    if [[ ! -z $isnt_connected ]]; then
        scutil --nc start "$VPNName"
    else
        echo "Already Connected to VPN..."
    fi
}

function _config() {
    ruby -e '
    require "yaml"

    yaml_file = YAML.load_file("#{Dir.home}/.servers.yml")
    type_name = ARGV.shift
    env_name = ARGV.shift

    def yellow(msg)
      "\033[33;33m#{msg}\033[0m"
    end

    def red(msg)
      "\033[33;31m#{msg}\033[0m"
    end

    def exit_with_message(msg)
      puts msg
      exit 1
    end

    exit_with_message "usage: server [type] [environment]" if type_name.nil? or env_name.nil?

    type = yaml_file[type_name]
    exit_with_message "#{red("type not found")}\navaliable types are #{yellow(yaml_file.keys)}" if type.nil?

    value = type[env_name]
    if value.nil?
      msg = "environment #{red(env_name)} not found for type #{yellow(type_name)}\navaliable environments are #{yellow(type.keys)}"
      exit_with_message msg if value.nil? or value.empty?
    end

    puts value' $@
}

function dev_environment() {
    local git_branch=$(git branch 2>/dev/null | grep -e '^*' | sed -E 's/^\* (.+)$/\1/')

    if [[ ! -z $git_branch ]]; then
        echo "($git_branch$(detect_git_dirty))"
    fi
}

function detect_git_dirty {
  local git_status=$(git status 2>&1 | tail -n1)
  [[ $git_status != "fatal: Not a git repository (or any of the parent directories): .git" ]] && [[ $git_status != "nothing to commit, working tree clean" ]] && echo "*"
}

# vim:ft=sh:tabstop=4:shiftwidth=4:
