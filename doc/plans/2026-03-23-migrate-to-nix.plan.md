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

  outputs = { self, nixpkgs, nix-darwin, home-manager, ... }:
  let
    # Helper: build a home-manager config for any Linux system string.
    # system must match the target machine exactly (Nix does not auto-detect it).
    mkHome = system: modules: home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.${system};
      inherit modules;
    };
  in {
    # macOS
    darwinConfigurations."<hostname>" = nix-darwin.lib.darwinSystem {
      modules = [
        ./modules/darwin
        home-manager.darwinModules.home-manager
        { home-manager.users.<username> = import ./modules/home; }
      ];
    };

    # Linux (home-manager standalone) — one entry per machine
    homeConfigurations = {
      "<username>@<x86-hostname>" = mkHome "x86_64-linux"  [ ./modules/home ./modules/linux ];
      "<username>@<pi-hostname>"  = mkHome "aarch64-linux" [ ./modules/home ./modules/linux ];
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
  gnupg
  # go, nodejs, rustup, python/poetry intentionally omitted — see note below
];
```

**Language runtimes belong in per-project devShells, not here.** `go`, `nodejs`,
`rustup`, `python`, and `poetry` are managed by work tooling at the machine level
(specific versions, internal proxies, etc.). Installing them globally via
home-manager would silently shadow the work-managed versions via PATH ordering.

Instead, declare them per project with a `flake.nix` devShell:
```nix
# example: project-level flake.nix
devShells.default = pkgs.mkShell {
  packages = [ pkgs.go_1_23 pkgs.gotools ];
};
```
Then `direnv` + `use flake` activates the right version automatically when you
enter the project directory. This works on both work and personal machines without
conflict — the work machine's global `go` is never touched.

macOS-only (nix-darwin or Homebrew casks where unavailable in nixpkgs):
- `rectangle`, `kitty`, `ghostty`, `shottr` — check nixpkgs first; fall back to `homebrew.casks` in nix-darwin if not available

Linux-only:
```nix
home.packages = with pkgs; [
  xclip  # X11 clipboard — skip on headless Raspberry Pi
  strace wireshark
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

#### Verification checklist

**Before migration:** snapshot git config for later diffing.
```bash
git config --list | sort > /tmp/git-before.txt
```

**Packages resolve to nix store paths** (not `/usr/local/bin` or `/opt/homebrew`):
```bash
which bat fd fzf ripgrep jq eza zoxide starship gh
# Expected: /nix/store/<hash>-<name>/bin/<tool>
```

**Shell — open a brand new terminal window** (not `source ~/.zshrc`; session variables
only initialize on a fresh login shell):
```bash
echo $DOTFILES        # ~/.dotfiles
echo $PATH            # includes ~/.dotfiles/bin and /nix/store paths
type ll               # aliases loaded
zoxide --version      # zoxide integration active
starship --version    # prompt integration active
fzf --version         # fzf integration active
```

**`bin/` scripts still reachable** (out of scope for migration but must stay on PATH):
```bash
which git-rebase-main   # or any other bin/ script
```

**Dotfile symlink targets point to the nix store** (not directly into `~/.dotfiles`):
```bash
ls -la ~/.tmux.conf ~/.config/kitty ~/.config/ghostty
# Before: ~/.dotfiles/tmux/tmux.conf
# After:  /nix/store/<hash>/...
```

**Git config parity:**
```bash
git config --list | sort > /tmp/git-after.txt
diff /tmp/git-before.txt /tmp/git-after.txt
# Diff should be empty or limited to path format changes (store paths vs dotfiles paths)
```

**GPG signing still works:**
```bash
echo test | gpg --clearsign
git commit --allow-empty -m "test gpg signing"
```

**Parallel operation with `install.py`:** running `python3 install.py` after a
`home-manager switch` must not clobber home-manager-managed files. Confirm that any
file listed in both `home.file` and `CONFIGURATION_FILES` in `install.py` has been
removed from one side before both are run together.

**Rollback smoke test:**
```bash
# 1. Introduce a deliberate bad change (e.g. reference a nonexistent package)
# 2. Confirm switch fails without corrupting the active generation
# 3. Roll back:
home-manager generations
home-manager switch --switch-generation <previous-number>
# 4. Verify shell is functional again
```

**Linux (x86_64):** apply on an actual x86_64 machine and confirm the flake key
(`<username>@<x86-hostname>`) matches.

**Linux (aarch64 / Raspberry Pi):** apply on the Pi directly using the
`aarch64-linux` flake key. Confirm store paths resolved to ARM binaries — no
compilation output should appear during `switch` (all packages have pre-built
aarch64 binaries in `cache.nixos.org`):
```bash
file $(which bat)
# Expected: ELF 64-bit LSB executable, ARM aarch64
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

## Raspberry Pi (aarch64-linux)

- **System string:** use `aarch64-linux` in `homeConfigurations` — Nix does not
  detect the host architecture automatically
- **Apply directly on the Pi** — cross-applying from macOS via `--system` is
  possible but error-prone; simpler to SSH in and run `home-manager switch` there
- **Binary cache:** all packages in this plan have pre-built aarch64 binaries on
  `cache.nixos.org`, so the first `switch` is download-heavy but should not
  trigger compilation. Do not disable `substituters`.
- **Storage:** the Nix store grows with each generation. On an SD card, run
  `nix-collect-garbage -d` periodically and keep at most 3 generations to avoid
  filling the card.
- **Headless Pi:** `xclip` requires X11 — skip it in `modules/linux/packages.nix`
  if the Pi has no display.

## Notes

- Keep `bin/` on `$PATH` via `home.sessionPath` or `home.sessionVariables`:
  ```nix
  home.sessionPath = [ "$HOME/.dotfiles/bin" ];
  ```
- Secrets (gitconfig.local, ssh/config.local) stay untracked as now — Nix doesn't need to own them
- The existing `zsh/aliases.zsh` + `config/fish/aliases.fish` sync requirement goes away once both are driven from a single Nix source
