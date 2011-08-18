#=======================================================================================================================================================
# global settings
#=======================================================================================================================================================
export GREP_OPTIONS="--color=auto"
export GREP_COLOR="4;31"
export HISTCONTROL=ignoredups:ignorespace
export HISTSIZE=1000
export HISTFILESIZE=2000
#export PS1="\[\033[01;32m\]\u@\h:\[\033[01;34m\]\w\[\033[31m\]\$(git_branch_name)\[\033[m\]$ "
export PS1='\[\e[01;33m\]\u\[\e[01;37m\]@\[\e[01;36m\]\h\[\e[01;37m\]:\[\e[01;34m\]\w\[\033[31m\]$(git_branch_name)\[\e[0m\]\$ ' 
export CLICOLOR="auto"
shopt -s histappend
shopt -s checkwinsize
shopt -s cdspell

#=======================================================================================================================================================
# system settings                                                               
#=======================================================================================================================================================
if [[ $OSTYPE == 'linux-gnu' ]]; then
	#===================================================================================================================================================
	# linux settings                                                               
	#===================================================================================================================================================
	# see /usr/share/doc/bash/examples/startup-files for examples
	export EDITOR="gvim"
	export GIT_EDITOR="gvim"
	alias myip='ifconfig $ETHERNET_NAME |grep inet| cut -d : -f 2 | cut -d B -f 1 | head -n1'

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

	# enable color support of ls and also add handy aliases
	if [ -x /usr/bin/dircolors ]; then
		test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
		alias ls='ls --color=auto'
		alias grep='grep --color=auto'
		alias fgrep='fgrep --color=auto'
		alias egrep='egrep --color=auto'
	fi

	# Add an "alert" alias for long running commands.  Use like so: sleep 10; alert
	alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

	# enable programmable completion features (you don't need to enable this, if it's already enabled in /etc/bash.bashrc and /etc/profile sources /etc/bash.bashrc).
	if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
		. /etc/bash_completion
	fi
else
	#===================================================================================================================================================
	# macbook settings                                                               
	#===================================================================================================================================================
	# exports                                                                     
	export EDITOR="mvim"
	export GIT_EDITOR="mvim"
	export ARCHFLAGS="-arch x86_64"                
	export PATH="/usr/local/bin:/usr/local/sbin:/opt/local/bin:/usr/local/mysql/bin:$PATH"

        # colours for coreutils 
        export LS_COLORS='rs=0:di=01;34:ln=06;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=5;31;01:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.dz=01;31:*.gz=01;31:*.lz=01;31:*.xz=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.rar=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.axv=01;35:*.anx=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.axa=00;36:*.oga=00;36:*.spx=00;36:*.xspf=00;36:';

        # colours for mac default bash tools
	export LSCOLORS="ExGxFxFxCxdAdAabagacEC"
	#                | | o o | | | o o o |_ directory writable to others, without sticky bit     # a  black
	#                | | | | | | | | | |_ directory writable to others, with sticky bit          # b  red
	#                | | | | | | | | |_ executable with setgid bit set                           # c  green
	#                | | | | | | | |_ executable with setuid bit set                             # d  brown
	#                | | | | | | |_ character special                                            # e  blue
	#                | | | | | |_ block special                                                  # f  magenta
	#                | | | | |_ executable                                                       # c  cyan
	#                | | | |_ pipe                                                               # h  light grey
	#                | | |_ socket                                                               # A  block black, usually shows up as dark grey
	#                | |_ symbolic link                                                          # B  bold red
	#                |_ directory                                                                # C  bold green
	#                                                                                            # D  bold brown, usually shows up as yellow
	#                                                                                            # E  bold blue
	#                                                                                            # F  bold magenta
	#                                                                                            # G  bold cyan
	#                                                                                            # H  bold light grey; looks like bright white
	#                                                                                            # x  default foreground or background

	# functions  
	function pkill() {
		local pid
		pid=$(ps ax | grep $1 | grep -v grep | awk '{ print $1 }')
		kill -9 $pid
	}
    
	# All commands have been installed with the prefix 'g'.
	# But note that sourcing these aliases will cause them to be used instead of Bash built-in commands, which may cause problems in shell scripts.
	# The Bash "printf" built-in behaves differently than gprintf, for instance, which is known to cause problems with "bash-completion".
	# The man pages are still referenced with the g-prefix    
        source /usr/local/Cellar/coreutils/8.7/aliases

	# auto complete
	source ~/.git_completion
	complete -cf sudo
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

