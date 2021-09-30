export ZSH="${HOME}/.oh-my-zsh"
export GOPATH="${HOME}/ext/go"
export PATH="${PATH}:$(go env GOPATH)/bin"
export EDITOR=/usr/bin/nvim

ZSH_THEME="half-life"

plugins=(
  git
  ssh-agent
)

export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"
eval "$(pyenv virtualenv-init -)"
eval "$(pyenv init -)"

eval "$(dircolors ~/.dir_colors)"

alias vim=nvim
source $ZSH/oh-my-zsh.sh
