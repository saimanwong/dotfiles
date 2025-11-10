# Ansible Dotfiles Repository

## Commands
- **Run full playbook**: `ansible-playbook -i inventory.ini -K -e h=mac -e hw_keyboard=ansi all.yml`
- **Run specific role**: `ansible-playbook -i inventory.ini -K -e h=mac all.yml --tags <role_name>`
- **Test syntax**: `ansible-playbook -i inventory.ini --syntax-check all.yml`
- **Dry run**: `ansible-playbook -i inventory.ini -K --check all.yml`

## Opt-in Roles

The following roles are opt-in and must be run explicitly:

- **ollama**: Install Ollama for local LLM management
  ```bash
  ansible-playbook -i inventory.ini -K -e h=mac all.yml --tags ollama
  ```

- **openai-cli**: Install OpenAI CLI for interacting with OpenAI APIs
  ```bash
  ansible-playbook -i inventory.ini -K -e h=mac all.yml --tags openai-cli
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