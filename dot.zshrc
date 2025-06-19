# starship prompt
export STARSHIP_CONFIG=~/.config/starship.toml
eval "$(starship init zsh)"

# history settings
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history

# enable completion
autoload -Uz compinit
compinit

# syntax highlighting / auto suggestions
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# aliases
if [ -f ~/.bash_aliases ]; then
  source ~/.bash_aliases
fi

# misc
export PROMPT_COMMAND='echo -ne "\033]0;$(basename "$PWD")\007"'
export DOCKER_HOST="tcp://skynet:2375"

# vim:ft=sh
