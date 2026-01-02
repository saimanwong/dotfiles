# Ansible Dotfiles Repository

## Commands
- **Run full playbook**: `ansible-playbook -i inventory.ini -e h=mac -e hw_keyboard=ansi all.yml`
- **Run specific role**: `ansible-playbook -i inventory.ini -e h=mac all.yml --tags <role_name>`
- **Test syntax**: `ansible-playbook -i inventory.ini --syntax-check all.yml`
- **Dry run**: `ansible-playbook -i inventory.ini --check all.yml`

## Getting started

- Install [zsh/oh-my-zshell](https://ohmyz.sh/)
- Install [pyenv](https://github.com/pyenv/pyenv-installer)
- Copy `files/.zshrc` -> `~/.zshrc`
- `pyenv install 3.9.6 && pyenv virtualenv 3.9.6 ansible && pyenv activate ansible`
- `ansible-playbook -i inventory.ini -K -e h=mac -e hw_keyboard=ansi all.yml`

## Available Roles

### Core Roles (included by default)
- **alacritty**: Alacritty terminal emulator
- **aur**: Arch User Repository setup (Arch Linux only)
- **awscli**: AWS Command Line Interface
- **azure-cli**: Azure Command Line Interface
- **chrome**: Google Chrome browser
- **claude-code**: Claude Code CLI tool
- **discord**: Discord desktop application
- **docker**: Docker containerization platform
- **gcloud**: Google Cloud CLI
- **gemini-cli**: Google Gemini CLI tool
- **gh**: GitHub CLI
- **git**: Git version control configuration
- **github-copilot**: Install GitHub Copilot CLI globally via npm
- **go**: Go programming language
- **htop**: Interactive process viewer
- **huggingface**: Hugging Face CLI
- **k8s**: Kubernetes tools (kubectl, etc.)
- **keybindings**: System keybinding configuration
- **linear**: Linear CLI
- **macos-terminal**: macOS Terminal configuration
- **neovim**: Neovim text editor configuration
- **nodejs**: Node.js JavaScript runtime
- **ocrmypdf**: OCR tool for PDFs
- **openai-cli**: OpenAI CLI tool
- **opencode**: Install OpenCode CLI tool with Linear MCP integration configured
- **opentofu**: OpenTofu infrastructure as code
- **pdftotext**: PDF to text converter
- **psql**: PostgreSQL client (libpq)
- **pulumi**: Pulumi infrastructure as code
- **signal**: Signal messaging app
- **slack**: Slack desktop application
- **sops**: Mozilla SOPS for secrets management
- **spec-kit**: Specification development tools
- **spotify**: Spotify desktop application
- **temporal**: Temporal workflow engine CLI
- **terminal**: Terminal configuration
- **terraform-ls**: Terraform language server
- **tesseract**: Tesseract OCR engine
- **tmux**: Terminal multiplexer
- **tree**: Directory tree listing utility
- **uv**: Python package manager
- **watch**: Watch command for running commands periodically
- **zsh**: Zsh shell configuration

### Hardware-Specific Roles
- **mac_keyboard**: Mac keyboard mapping (Arch Linux + Mac hardware)
- **mac_facetimehd**: Mac FaceTime HD camera support (Arch Linux + Mac hardware)

### Opt-in Roles
The following roles are available but not included by default:

- **ollama**: Install Ollama for local LLM management
  ```bash
  ansible-playbook -i inventory.ini roles/ollama/tasks/main.yml
  ```
