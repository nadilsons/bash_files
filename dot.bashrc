# System-specific settings
if [[ $OSTYPE == 'linux-gnu' ]]; then
    # Linux-specific configurations
    export EDITOR="vim"

    [[ -f ~/.dircolors ]] && . ~/.dircolors;
else
    # macOS-specific configurations (MacBook)
    eval "$(/opt/homebrew/bin/brew shellenv)"

    export EDITOR="mvim"
    export PATH="`brew --prefix coreutils`/libexec/gnubin:$PATH"
    export DOCKER_HOST="tcp://skynet:2375"
    export PROMPT_COMMAND='echo -ne "\033]0;$(basename "$PWD")\007"'
    export BASH_SILENCE_DEPRECATION_WARNING=1

    # Enable Homebrew's Bash completion
    [[ -f $(brew --prefix)/etc/bash_completion ]] && . $(brew --prefix)/etc/bash_completion
fi

# Global settings
export GREP_OPTIONS="--color=auto"
export HISTCONTROL=ignoredups:ignorespace
export HISTSIZE=1000
export HISTFILESIZE=2000
export PS1='\[\e[01;33m\]\u\[\e[01;37m\]@\[\e[01;36m\]\h\[\e[01;37m\]:\[\e[01;34m\]\w\[\033[31m\]$(dev_environment)\[\e[0m\]\$ '
export GIT_EDITOR=$EDITOR
shopt -s histappend    # append to the history file, don't overwrite it
shopt -s checkwinsize  # check the window size after each command and, if necessary, update the values of LINES and COLUMNS.
shopt -s cdspell       # corrects dir names mistakes in the cd command
complete -cf sudo

# global aliases
[[ -f ~/.bash_aliases ]] && . ~/.bash_aliases

# global auto complete
[[ -f ~/.bash_completion ]] && . ~/.bash_completion;

# global functions
[[ -f ~/.bash_functions ]] && . ~/.bash_functions;

# vim:ft=sh:tabstop=4:shiftwidth=4:
