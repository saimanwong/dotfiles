# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Deactivate CTRL+S
stty -ixon

# Color
ZSH_THEME="bureau"

# Plugin
plugins=(git)

# Aliases (macOS)
alias vim='/Applications/MacVim.app/Contents/MacOS/Vim'

source $ZSH/oh-my-zsh.sh
