export ZSH="${HOME}/.oh-my-zsh"
export GOPATH="${HOME}/go"
export PATH="${PATH}:/usr/local/go/bin"
export PATH="${PATH}:$(go env GOPATH)/bin"
export PATH="${PATH}:${HOME}/.rd/bin"
case `uname` in
  Darwin)
    # commands for OS X go here
    export EDITOR=/usr/local/bin/nvim
  ;;
  Linux)
    # commands for Linux go here
    export EDITOR=/usr/bin/nvim
    eval "$(dircolors ~/.dir_colors)"
  ;;
esac

ZSH_THEME="robbyrussell"

plugins=(
  git
  ssh-agent
)

export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"
eval "$(pyenv virtualenv-init -)"
eval "$(pyenv init -)"

alias vim=nvim
source $ZSH/oh-my-zsh.sh
