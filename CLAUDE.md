# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a personal dotfiles repository for managing configuration files across macOS and Linux (Debian/Ubuntu/Arch). The repository uses symlinks to maintain dotfiles in a central location (`~/.dotfiles`) and includes installation scripts for provisioning new machines.

## Common Commands

### Testing and Linting
```bash
# Install pre-commit hooks
make install

# Run all tests and linters (shellcheck, black, ruff, vint, etc.)
make test

# Run pre-commit manually
pre-commit run --all-files

# Run specific linters
pre-commit run vint --all-files          # Vim files only
pre-commit run shellcheck --all-files    # Shell scripts only
pre-commit run ruff-check --all-files    # Python linting only

# Update pre-commit plugins
pre-commit autoupdate
```

### Installation and Setup
```bash
# Install dotfiles only (symlink configuration files)
python3 install.py

# Full installation (apps + settings + dotfiles)
python3 install.py --with-all

# Install all packages/apps (macOS or Linux)
./install/install-apps-all.sh

# Install vim plugins (requires vim-plug)
./install/install-vim.sh
```

### Testing Individual Python Scripts
```bash
# Run pytest for specific test files
uvx --with "jinja2" pytest bin/render_template_test.py
```

## Architecture and Structure

### Directory Organization

- `bin/`: Custom scripts and command-line utilities (added to PATH)
- `zsh/`: ZSH configuration files (zshrc, zshenv, aliases, prompt)
- `vim/`: Vim/Neovim configuration and plugins
  - `vimrc`: Main Vim configuration
  - `my_functions.vim`: Custom Vim functions
  - `pluginsrc.vim`: Plugin-specific configurations
  - `plugged/`: Vim plugins installed via vim-plug
- `git/`: Git configuration (gitconfig, gitignore)
  - Includes `gitconfig.local.template` for local overrides
- `config/`: Application-specific configs (cheat, kitty, ghostty, fish, tig, pudb, starship)
- `tmux/`: Tmux configuration
- `install/`: Installation and provisioning scripts
- `system/`: System-level configurations (PATH, colors)
- `helpers/`: Helper scripts for installation (setup.sh, colors.sh)
- `cheatsheets/`: Personal cheatsheets for various tools
- `cookbook/`: Documentation and how-to guides
- `doc/`: Documentation files (vim profiling, git usage, etc.)

### Key Installation Mechanism

The `install.py` script is the main entry point. It:
1. Clones or updates the dotfiles repository to `~/.dotfiles`
2. Creates symlinks from `~/.dotfiles/<file>` to `~/.<file>` for each configuration file
3. Uses the `CONFIGURATION_FILES` tuple to define what gets symlinked
4. Supports various flags: `--with-apps`, `--with-settings`, `--with-espanso`, `--with-clones`
5. Can force symlink creation with `--symlink-force` or do dry runs with `--dry-run`

### Shell Configuration Loading Order

1. `zsh/zshenv`: Sourced first, sets up `$ZSH` variable
2. `system/path.zsh`: Sourced early in zshrc, sets up PATH and environment variables
3. `zsh/zshrc`: Main ZSH configuration, loads:
   - Completion system (compinit)
   - History search
   - Key bindings (Emacs-style Ctrl-A/Ctrl-E in vi mode)
   - External integrations (brew, fzf, asdf, starship, zoxide)
4. `zsh/aliases.zsh`: Command aliases

### Vim Plugin Management

Uses [vim-plug](https://github.com/junegunn/vim-plug) for plugin management. Key plugins include:
- ALE (Asynchronous Lint Engine)
- vim-lsp (Language Server Protocol support)
- fzf.vim (fuzzy finding)
- vim-fugitive (Git integration)
- vim-go (Go development)
- UltiSnips (snippets)

### Pre-commit Hooks

The repository uses pre-commit hooks defined in `.pre-commit-config.yaml`:
- **shellcheck**: Shell script linting
- **vint**: Vim script linting
- **black**: Python code formatting
- **ruff**: Python linting
- **detect-private-key**: Security check
- **doctoc**: Auto-generate TOC for README.md

### Platform-Specific Behavior

The codebase handles both macOS and Linux:
- `install/set-config-osx.sh`: macOS-specific settings
- `install/set-config-linux.sh`: Linux-specific settings
- `system/path.zsh`: Detects Homebrew location (Intel vs Apple Silicon vs Linux)
- ZSH config checks `$OSTYPE` for platform-specific key bindings

### Environment Variables

Key environment variables set in `system/path.zsh`:
- `$ZSH`: Points to `$HOME/.dotfiles`
- `$DOTFILES`: Same as `$ZSH`
- `$VIM_DOTFILES`: Points to `$DOTFILES/vim`
- `$CODE_PATH`: `$HOME/CodePerso` (for personal projects)
- `$GOPATH`: `$CODE_PATH/golang`
- `$CHEAT_CONFIG_PATH`: Points to cheat configuration

## Development Workflow

### Making Changes to Dotfiles

1. Edit files directly in `~/.dotfiles/`
2. Changes are immediately reflected in your environment (via symlinks)
3. For ZSH changes: run `reload_zshrc!` alias or `. ~/.zshrc`
4. For Vim changes: use `:ReloadVimConfig` command or `:source $MYVIMRC`
5. Run `make test` before committing to ensure linting passes
6. Pre-commit hooks will run automatically on commit

### Adding New Configuration Files

1. Add the file to `~/.dotfiles/` in the appropriate directory
2. Add it to the `CONFIGURATION_FILES` tuple in `install.py`
3. Format: `("source/path", ".target/path")` or just `"source/path"` if target is `~/.basename`
4. Re-run `python3 install.py` to create the symlink

### Adding New Scripts

1. Add scripts to `bin/` directory
2. Make them executable: `chmod +x bin/script-name`
3. They'll be available in PATH via `$ZSH/bin` (set in `system/path.zsh`)
4. For shell scripts, run shellcheck via pre-commit: `pre-commit run shellcheck --files bin/script-name.sh`

### Adding New Aliases

When adding new aliases, you MUST update both `system/aliases.zsh` (ZSH) and `config/fish/aliases.fish` (Fish) to keep them in sync.

### Python Scripts

- Use `#!/usr/bin/env python3` shebang
- Follow black and ruff formatting/linting rules
- Add tests with pytest when appropriate (see `bin/render_template_test.py` for example)
- Run with `uvx` for scripts needing dependencies: `uvx --with "jinja2" python script.py`

#### Type Annotations and Docstrings

- **ALWAYS add type annotations** to all function signatures (parameters and return types)
- **Keep docstrings concise**: Only include Args/Returns sections when they explain something beyond what the type hints already convey
  - ❌ Bad: Restating `folder: str` as "Args: folder (str): Directory to create the note in"
  - ✅ Good: Explaining constraints, side effects, or business logic not obvious from the type
  - Example: A simple function like `def create_note(folder: str, title: str) -> Path:` only needs a one-line docstring describing what it does
