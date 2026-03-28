# Migrate dotfiles to Nix

## Scope

- Package installation (Homebrew → Nix packages)
- Dotfile management (symlinks → `home.file`)
- Shell configuration (zsh, fish)
- Git configuration
- Cross-platform support (macOS + Linux)

**Out of scope for now:** Vim/Neovim migration, `bin/` scripts migration, macOS system defaults (`set-config-osx.sh`).

## Approach

Use **flakes** with **home-manager** as a module (not standalone). On macOS, wire through **nix-darwin**. On Linux, use home-manager standalone or NixOS depending on the machine.

```
~/.dotfiles/
  flake.nix                  # Entry point, defines outputs
  modules/
    home/
      default.nix            # Shared home-manager config
      packages.nix           # Packages available on all platforms
      shell.nix              # zsh + fish config
      git.nix                # Git config
    darwin/
      default.nix            # nix-darwin system config
      packages.nix           # macOS-only packages (casks, etc.)
    linux/
      default.nix            # Linux system config
      packages.nix           # Linux-only packages
```

## Steps

### 1. Bootstrap Nix + flakes

```bash
# Install Nix (Determinate Systems installer — handles macOS quirks)
curl --proto '=https' --tlsv+1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install

# Verify flakes are enabled
nix flake --version
```

### 2. Set up flake.nix

Minimal structure supporting both macOS and Linux:

```nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nix-darwin, home-manager, ... }: {
    # macOS
    darwinConfigurations."<hostname>" = nix-darwin.lib.darwinSystem {
      modules = [
        ./modules/darwin
        home-manager.darwinModules.home-manager
        { home-manager.users.<username> = import ./modules/home; }
      ];
    };

    # Linux (home-manager standalone)
    homeConfigurations."<username>@<hostname>" = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
      modules = [ ./modules/home ./modules/linux ];
    };
  };
}
```

### 3. Migrate packages

Translate `install/install-apps-all.sh` brew/apt lists to `modules/home/packages.nix` (shared) and platform-specific files.

Common packages that map directly:
```nix
home.packages = with pkgs; [
  bat fd fzf ripgrep jq tree wget
  htop tmux pandoc gh git-delta
  difftastic eza zoxide starship
  cloc tokei sd dust procs
  hexyl imagemagick mitmproxy
  go rustup nodejs
  gnupg
];
```

macOS-only (nix-darwin or Homebrew casks where unavailable in nixpkgs):
- `rectangle`, `kitty`, `ghostty`, `shottr` — check nixpkgs first; fall back to `homebrew.casks` in nix-darwin if not available

Linux-only:
```nix
home.packages = with pkgs; [
  xclip strace wireshark
];
```

### 4. Migrate dotfiles (home.file)

Replace `install.py` symlinks with `home.file` declarations:

```nix
home.file = {
  ".config/kitty".source = ../../config/kitty;
  ".config/ghostty".source = ../../config/ghostty;
  ".config/fish/config.fish".source = ../../config/fish/config.fish;
  ".config/cheat".source = ../../config/cheat;
  ".config/tig/config".source = ../../config/tig/config;
  ".tmux.conf".source = ../../tmux/tmux.conf;
  ".ctags".source = ../../ctags/ctags;
  # etc.
};
```

Keep `install.py` working during transition — run both in parallel until confident.

### 5. Migrate shell config

Use `programs.zsh` in home-manager rather than symlinking `zshrc` directly. This composes better with other home-manager modules.

```nix
programs.zsh = {
  enable = true;
  # Pull in existing zshrc content, or break it into initExtra / shellAliases
  initExtra = builtins.readFile ../../zsh/zshrc;
  envExtra = builtins.readFile ../../zsh/zshenv;
};

programs.fish = {
  enable = true;
  shellAliases = { ... };  # Migrate from config/fish/aliases.fish
};

programs.starship.enable = true;
programs.zoxide.enable = true;
programs.fzf.enable = true;
```

The `builtins.readFile` approach lets you keep the existing zsh files unchanged while adopting Nix incrementally. Gradually move content into structured Nix options over time.

### 6. Migrate git config

home-manager has first-class git support:

```nix
programs.git = {
  enable = true;
  userName = "...";
  userEmail = "...";  # from gitconfig.local — keep in separate untracked file
  signing = { key = "..."; signByDefault = true; };
  aliases = { ... };  # migrate from git/gitconfig
  extraConfig = {
    merge.tool = "vimdiff";
    diff.tool = "difftastic";
    rerere.enabled = true;
    # etc.
  };
  includes = [
    { path = "~/.dotfiles/git/gitconfig.local"; }
    { condition = "gitdir:~/Work/"; path = "~/.dotfiles/git/gitconfig.work.local"; }
    { condition = "gitdir:~/CodePerso/"; path = "~/.dotfiles/git/gitconfig.codeperso.local"; }
  ];
};
```

The `.local` files stay untracked as now — Nix manages structure, secrets stay out of the repo.

### 7. Apply and test

```bash
# macOS
darwin-rebuild switch --flake .#<hostname>

# Linux (home-manager standalone)
home-manager switch --flake .#<username>@<hostname>
```

### 8. Decommission install.py (package + symlink parts)

Once home-manager is stable:
- Remove package installation from `install.py`
- Remove symlink entries that are now managed by `home.file`
- Keep `install.py` around for the remaining concerns (espanso cloning, etc.) or remove entirely

## Rollback

Nix keeps generations — roll back any time:

```bash
home-manager generations
home-manager switch --switch-generation <number>
```

## Notes

- Keep `bin/` on `$PATH` via `home.sessionPath` or `home.sessionVariables`:
  ```nix
  home.sessionPath = [ "$HOME/.dotfiles/bin" ];
  ```
- Secrets (gitconfig.local, ssh/config.local) stay untracked as now — Nix doesn't need to own them
- The existing `zsh/aliases.zsh` + `config/fish/aliases.fish` sync requirement goes away once both are driven from a single Nix source
