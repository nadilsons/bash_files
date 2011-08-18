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
	# export
	export EDITOR="mvim"
	export ARCHFLAGS="-arch x86_64"                
	export PATH="/usr/local/bin:/usr/local/sbin:/opt/local/bin:/usr/local/mysql/bin:$PATH"

	# functions
	function pkill() {
		local pid
		pid=$(ps ax | grep $1 | grep -v grep | awk '{ print $1 }')
		kill -9 $pid
	}

	# auto complete
	source ~/.git_completion
	complete -cf sudo
fi

#=======================================================================================================================================================
# global settings
#=======================================================================================================================================================
export GREP_OPTIONS="--color=auto"
export GREP_COLOR="4;31"
export HISTCONTROL=ignoredups:ignorespace
export HISTSIZE=1000
export HISTFILESIZE=2000
export PS1='\[\e[01;33m\]\u\[\e[01;37m\]@\[\e[01;36m\]\h\[\e[01;37m\]:\[\e[01;34m\]\w\[\033[31m\]$(git_branch_name)\[\e[0m\]\$ ' 
#export PS1="\[\033[01;32m\]\u@\h:\[\033[01;34m\]\w\[\033[31m\]\$(git_branch_name)\[\033[m\]$ "
#export CLICOLOR="auto"
export GIT_EDITOR=$EDITOR
shopt -s histappend
shopt -s checkwinsize
shopt -s cdspell

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

# uncomment for a colored prompt, if the terminal has the capability; turned off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt force_color_prompt=yes
#if [ -n "$force_color_prompt" ]; then
#	if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
#		# We have color support; assume it's compliant with Ecma-48 (ISO/IEC-6429). (Lack of such support is extremely rare, and such
#		# a case would tend to support setf rather than setaf.)
#		color_prompt=yes
#	else
#		color_prompt=
#	fi
#fi

#=======================================================================================================================================================
# global aliases
#=======================================================================================================================================================
if [ -f ~/.bash_aliases ]; then
	. ~/.bash_aliases
fi

# All commands have been installed with the prefix 'g'.
# But note that sourcing these aliases will cause them to be used instead of Bash built-in commands, which may cause problems in shell scripts.
# The Bash "printf" built-in behaves differently than gprintf, for instance, which is known to cause problems with "bash-completion".
# The man pages are still referenced with the g-prefix
if [ -f /usr/local/Cellar/coreutils/8.7/aliases ]; then
	source /usr/local/Cellar/coreutils/8.7/aliases
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
function ws() {
	cd ~/workspace/$1
}

function git_branch_name() {
	git branch 2>/dev/null | grep -e '^*' | sed -E 's/^\* (.+)$/(\1)/'
}
