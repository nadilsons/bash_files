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
    #export ARCHFLAGS="-arch x86_64"
    export PATH="/usr/local/opt/coreutils/libexec/gnubin:~/.gem/bin:$PATH"
    export MANPATH="/usr/local/opt/coreutils/libexec/gnuman:$MANPATH"

    # mac docker setup
    [[ $(docker-machine status) == 'Running' ]] && eval $(docker-machine env default);

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
#export GEM_HOME=~/.gem
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
        echo -e '\033[1;33m========>>>>>>>>>>-------------------------------<<<<<<<<<<========\033[0m'
        echo -e '\033[1;33m========>>>>>>>>>>\033[0m \033[5;31mAtualizando TODOS os projetos\033[0m \033[1;33m<<<<<<<<<<========\033[0m'
        echo -e '\033[1;33m========>>>>>>>>>>-------------------------------<<<<<<<<<<========\033[0m'
        cd ~/workspace
        ls -1 | while read line; do cd $line; pwd; git pull; cd ..; done;
        echo -e '\033[1;33m========>>>>>>>>>>-------------------------------<<<<<<<<<<========\033[0m'
    else
        cd ~/workspace/$1
    fi
}

function server() {
    ruby -e '
    require "yaml"

    applications = YAML.load_file("#{Dir.home}/.servers.yml")
    app_name = ARGV.shift
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

    exit_with_message "usage: server [application] [environment{index}]" if app_name.nil? or env_name.nil?

    application = applications[app_name]
    exit_with_message "#{red("application not found")}\navaliable applications are #{yellow(applications.keys)}" if application.nil?

    servers = application[env_name]
    if servers.nil?
      msg = "environment #{red(env_name)} not found for application #{yellow(app_name)}\navaliable environments are #{yellow(application.keys)}"

      server_and_index = env_name.match(/^(\D{1,})(\d{1,}$)/)
      exit_with_message msg if server_and_index.nil?

      servers = Array(application[server_and_index[1]][server_and_index[2].to_i.pred]) rescue nil
      exit_with_message msg if servers.nil? or servers.empty?
    end

    cmd = servers.one? ? :ssh : :csshX
    puts "accessing server(s) #{yellow(servers)}..."
    system "#{cmd} #{(servers + ARGV).join(" ")}"' $@
}

function dev_environment() {
    local git_branch=$(git branch 2>/dev/null | grep -e '^*' | sed -E 's/^\* (.+)$/\1/')

    if which rvm-prompt >/dev/null; then
        local rvm_prompt=$(rvm-prompt i v)
    fi

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

# vim:ft=sh:tabstop=4:shiftwidth=4:
