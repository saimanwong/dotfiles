# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin

# Do not send stats
export COCOAPODS_DISABLE_STATS=1

# Deactivate CTRL+S
stty -ixon

# Color
ZSH_THEME="bureau"

# Plugin
plugins=(git)

# Aliases (macOS)
alias vim='/Applications/MacVim.app/Contents/MacOS/Vim'

source $ZSH/oh-my-zsh.sh
