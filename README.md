# Ansible dotfiles setup

## Getting started

- Install [zsh/oh-my-zshell](https://ohmyz.sh/)
- Install [pyenv](https://github.com/pyenv/pyenv-installer)
- Copy `files/.zshrc` -> `~/.zshrc`
- `pyenv install 3.9.6 && pyenv virtualenv 3.9.6 ansible && pyenv activate ansible`
- `ansible-playbook -i inventory.ini -K all.yml`
