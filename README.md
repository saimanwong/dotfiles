# Ansible dotfiles setup

## Getting started

- Install [zsh/oh-my-zshell](https://ohmyz.sh/)
- Install [pyenv](https://github.com/pyenv/pyenv-installer)
- Copy `files/.zshrc` -> `~/.zshrc`
- `pyenv install 3.9.6 && pyenv virtualenv 3.9.6 ansible && pyenv activate ansible`
- `ansible-playbook -i inventory.ini -K -e h=mac -e hw_keyboard=ansi all.yml`

## Available Roles

- **ollama**: Install Ollama for local LLM management on macOS
- **huggingface**: Install Hugging Face CLI for AI model management
- **docker**: Install Docker for containerization
- **neovim**: Install Neovim text editor
- **tmux**: Install terminal multiplexer
- **zsh**: Install Zsh shell configuration
- And many more... see `all.yml` for complete list
