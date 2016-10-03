# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Virtualenvwrapper (Python)
export WORKON_HOME="$HOME/Envs"
source /usr/local/bin/virtualenvwrapper.sh

# Deactivate CTRL+S 
stty -ixon

# Color
ZSH_THEME="bureau"

# Plugin
plugins=(git)

# Aliases (macOS)
alias vim="/Applications/MacVim.app/Contents/MacOS/Vim"
alias macchanger="$HOME/.macchanger/bin/macchanger"

source $ZSH/oh-my-zsh.sh
