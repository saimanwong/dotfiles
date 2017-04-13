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
alias vim='/Applications/MacVim.app/Contents/MacOS/Vim'
alias qsocat='socat TCP-LISTEN:6000,reuseaddr,fork UNIX-CLIENT:\"$DISPLAY\"'

source $ZSH/oh-my-zsh.sh
