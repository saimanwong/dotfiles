# Project Overview

This is an Ansible project for managing dotfiles. It sets up a development environment by installing and configuring various tools. The project is designed to be idempotent and can be run on different operating systems and hardware.

## Building and Running

To run the playbook, you need to have Ansible installed. You can then run the following command:

```bash
ansible-playbook -i inventory.ini -K -e h=<host> -e hw_keyboard=<keyboard_type> all.yml
```

Replace `<host>` with the host you want to provision (e.g., `mac` or `pc`) and `<keyboard_type>` with the keyboard type (e.g., `ansi` or `iso`).

You can also run a specific part of the playbook by using tags. For example, to only run the `git` and `tmux` roles, you can use the following command:

```bash
ansible-playbook -i inventory.ini -K -e h=<host> -e hw_keyboard=<keyboard_type> all.yml --tags "git,tmux"
```

## Tags

Each role in the playbook has a corresponding tag. This allows you to run only specific roles. The following tags are available:

- `aur`
- `awscli`
- `discord`
- `docker`
- `gcloud`
- `gemini-cli`
- `git`
- `go`
- `huggingface`
- `k8s`
- `keybindings`
- `mac_facetimehd`
- `mac_keyboard`
- `neovim`
- `ollama`
- `opencode`
- `opentofu`
- `pulumi`
- `signal`
- `slack`
- `spec-kit`
- `terminal`
- `terraform-ls`
- `tmux`
- `uv`
- `zsh`

## Opt-in Roles

Some roles are opt-in and must be run explicitly:

- **ollama**: Install Ollama and download LLM models
  ```bash
  ansible-playbook -i inventory.ini -K -e h=mac all.yml --tags ollama
  ```

## Development Conventions

The project is structured using Ansible roles. Each role is responsible for installing and configuring a specific tool. The roles are located in the `roles` directory. The `files` directory contains the configuration files that are copied to the home directory.

The main playbook is `all.yml`. This playbook includes all the roles and applies them to the specified host. The `inventory.ini` file defines the hosts that can be provisioned.

The project uses variables to customize the playbook for different operating systems and hardware. For example, the `h` variable is used to specify the host to provision, and the `hw_keyboard` variable is used to specify the keyboard type.