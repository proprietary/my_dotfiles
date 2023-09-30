# Set up the prompt

autoload -Uz promptinit
promptinit
prompt adam1

setopt histignorealldups sharehistory

# Use emacs keybindings even if our EDITOR is set to vi
bindkey -e

# Keep 1000 lines of history within the shell and save it to ~/.zsh_history:
HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.zsh_history

# Use modern completion system
autoload -Uz compinit
compinit

zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select=2
eval "$(dircolors -b)"
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' menu select=long
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true

zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

# Use system-wide shell configs 
source /etc/profile

. "$HOME/.cargo/env"

# Ruby
export GEM_HOME="$(ruby -e 'puts Gem.user_dir')"
export PATH="$GEM_HOME/bin:$PATH"

# postgresql 15
export PATH="/usr/lib/postgresql/15/bin:$PATH"

export PATH="$HOME/.local/bin:$PATH"

# direnv
eval "$(direnv hook zsh)"

# less
#export LESS="--color"
# ls
alias ls='ls --color -lah'

# fast node manager
# https://github.com/Schniz/fnm
eval "$(fnm env --use-on-cd)"

export EDITOR=emacs


# edit command line
autoload -z edit-command-line
zle -N edit-command-line
bindkey "^X^E" edit-command-line

# navigate word boundaries like bash
autoload -U select-word-style
select-word-style bash

# enable shell completions
autoload -U compinit
compinit -i