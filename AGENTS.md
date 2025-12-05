# Ansible Dotfiles Repository

## Commands
- **Run full playbook**: `ansible-playbook -i inventory.ini -e h=mac -e hw_keyboard=ansi all.yml`
- **Run specific role**: `ansible-playbook -i inventory.ini -e h=mac all.yml --tags <role_name>`
- **Test syntax**: `ansible-playbook -i inventory.ini --syntax-check all.yml`
- **Dry run**: `ansible-playbook -i inventory.ini --check all.yml`

## Available Roles

### Core Roles (included by default)
- **aur**: Arch User Repository setup (Arch Linux only)
- **awscli**: AWS Command Line Interface
- **claude-code**: Claude Code CLI tool
- **discord**: Discord desktop application
- **docker**: Docker containerization platform
- **gcloud**: Google Cloud CLI
- **gemini-cli**: Google Gemini CLI tool
- **git**: Git version control configuration
- **gh**: GitHub CLI tool
- **github-copilot**: Install GitHub Copilot CLI globally via npm
- **go**: Go programming language
- **htop**: Htop process viewer
- **huggingface**: Hugging Face CLI
- **k8s**: Kubernetes tools (kubectl, etc.)
- **keybindings**: System keybinding configuration
- **linear**: Linear CLI
- **neovim**: Neovim text editor configuration
- **opencode**: Install OpenCode CLI tool
- **opentofu**: OpenTofu infrastructure as code
- **pulumi**: Pulumi infrastructure as code
- **signal**: Signal messaging app
- **slack**: Slack desktop application
- **spec-kit**: Specification development tools
- **terminal**: Terminal configuration
- **terraform-ls**: Terraform language server
- **tmux**: Terminal multiplexer
- **uv**: Python package manager
- **zsh**: Zsh shell configuration

### Hardware-Specific Roles
- **mac_keyboard**: Mac keyboard mapping (Arch Linux + Mac hardware)
- **mac_facetimehd**: Mac FaceTime HD camera support (Arch Linux + Mac hardware)

### macOS-Specific Roles
- **macos-terminal**: macOS specific terminal and system settings (macOS only)

### Opt-in Roles
The following roles are available but not included by default:

- **ollama**: Install Ollama for local LLM management
  ```bash
  ansible-playbook -i inventory.ini roles/ollama/tasks/main.yml
  ```

## Code Style Guidelines
- Use YAML with 2-space indentation
- Follow Ansible best practices: use FQCN (ansible.builtin.* modules)
- Role structure: tasks/main.yml, handlers/main.yml, defaults/main.yml, meta/main.yml
- Use descriptive task names with proper capitalization
- Conditional logic: use `when:` with proper quoting for string comparisons
- Variables: use `{{ playbook_dir }}` for relative paths, `{{ ansible_env.HOME }}` for home directory
- File operations: prefer `ansible.builtin.file` with `state: link` for symlinks
- Package installation: use `become: true` for privileged operations, conditional on OS family
- Loop constructs: use `loop:` with `{{ item }}` for iteration

## Secret Configuration Workflow

When adding a new secret/token to the configuration:

1. **Add template to `.zshrc`** in the `else` block (when `.secrets` doesn't exist)
2. **Add check logic** in the `if` block (when `.secrets` exists) to:
   - Use `grep -q "export SECRET_NAME="` to check if secret exists
   - If missing, append the template with proper comments and instructions
   - Provide user feedback about the addition
3. **Include proper comments** with:
   - Purpose of the secret
   - Where to obtain it (URL)
   - Any required scopes/permissions
4. **Use descriptive placeholder** like `PREFIX_YOUR_TOKEN_HERE`

This ensures both new and existing users get the secret template automatically when their shell loads.