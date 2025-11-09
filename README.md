# Ansible dotfiles setup

## Getting started

- Install [zsh/oh-my-zshell](https://ohmyz.sh/)
- Install [pyenv](https://github.com/pyenv/pyenv-installer)
- Copy `files/.zshrc` -> `~/.zshrc`
- `pyenv install 3.9.6 && pyenv virtualenv 3.9.6 ansible && pyenv activate ansible`
- `ansible-playbook -i inventory.ini -K -e h=mac -e hw_keyboard=ansi all.yml`

## Available Roles

- **huggingface**: Install Hugging Face CLI for AI model management
- **docker**: Install Docker for containerization
- **neovim**: Install Neovim text editor
- **tmux**: Install terminal multiplexer
- **zsh**: Install Zsh shell configuration
- **ollama**: Install Ollama for local LLM management on macOS (opt-in)
- And many more... see `all.yml` for complete list

## Opt-in Roles

Some roles are opt-in and must be run explicitly:

- **ollama**: Install Ollama and download LLM models
  ```bash
  ansible-playbook -i inventory.ini -K -e h=mac all.yml --tags ollama
  ```
