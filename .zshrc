# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin
export LANGUAGE=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
if command -v pyenv 1>/dev/null 2>&1; then
    eval "$(pyenv init -)"
fi
if which pyenv-virtualenv-init > /dev/null; then eval "$(pyenv virtualenv-init -)"; fi

# Do not send stats
export COCOAPODS_DISABLE_STATS=1

# Deactivate CTRL+S
stty -ixon

# Color
ZSH_THEME="bureau"

# Plugin
plugins=(
  git
  ssh-agent
  svn
)

# Aliases (macOS)
alias vim='/Applications/MacVim.app/Contents/MacOS/Vim'
alias kc='kubectl'
alias gll='git log --decorate --graph --date=short --format="%C(auto)%h%C(reset) %C(green)%ar%C(reset) %C(blue)(%an)%C(reset) %C(auto)%d%C(reset) - %s"'

source $ZSH/oh-my-zsh.sh
