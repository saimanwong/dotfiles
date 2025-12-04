export ZSH="${HOME}/.oh-my-zsh"

case `uname` in
  Darwin)
    BREW_BASEPATH="/opt/homebrew"
    case `uname -m` in
      x86_64)
        BREW_BASEPATH="/usr/local"
        ;;
    esac
    # commands for OS X go here
    export SHELL=/bin/zsh
    export PATH="${PATH}:${BREW_BASEPATH}/bin"
    export PATH="${BREW_BASEPATH}/opt/make/libexec/gnubin:${PATH}"
    export PATH="${BREW_BASEPATH}/opt/go@1.24/bin:${PATH}"
    export PATH="${PATH}:${HOME}/.rd/bin"
    export PATH="${BREW_BASEPATH}/opt/node@16/bin:$PATH"
    export CPPFLAGS="-I${BREW_BASEPATH}/opt/node@16/include"
    export LDFLAGS="-L${BREW_BASEPATH}/opt/node@16/lib"
    export EDITOR=nvim
    alias sed=gsed
  ;;
  Linux)
    # commands for Linux go here
    export EDITOR=/usr/bin/nvim
    eval "$(dircolors ~/.dir_colors)"
  ;;
esac

export GOPATH="${HOME}/go"
export PATH="${PATH}:/usr/local/go/bin"
export PATH="${PATH}:$(go env GOPATH)/bin"
export CDPATH="${HOME}/github:${HOME}/gitlab"
export PATH="${PATH}:${HOME}/.rd/bin"
export PATH="${PATH}:${HOME}/.local/bin"

ZSH_THEME="robbyrussell"

plugins=(
  git
  ssh-agent
)

zstyle :omz:plugins:ssh-agent identities id_github id_gitlab

export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"
eval "$(pyenv virtualenv-init -)"
eval "$(pyenv init -)"

export LANG=en_US.UTF-8

alias vim=nvim
alias sed=gsed
source $ZSH/oh-my-zsh.sh

# Added by LM Studio CLI (lms)
export PATH="$PATH:${HOME}/.lmstudio/bin"
# End of LM Studio CLI section

# Source secure environment variables
if [ -f "${HOME}/.secrets" ]; then
  source "${HOME}/.secrets"
else
  # Create template .secrets file if it doesn't exist
  cat > "${HOME}/.secrets" << 'EOF'
# Secure environment variables
# This file is sourced by .zshrc and should NOT be committed to version control

# Linear API Key for MCP integration
# Get your key from: https://linear.app → Settings → Security & access → New API Key
export LINEAR_API_KEY="linapi_YOUR_TOKEN_HERE"

# Add more environment variables below as needed
# export ANOTHER_API_KEY="your_key_here"
EOF
  chmod 600 "${HOME}/.secrets"
  echo "⚠️  Created template ~/.secrets file. Please edit it to add your Linear API key."
fi

