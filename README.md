# dotfiles

chezmoi-managed. Bash, Neovim (LazyVim), tmux, git. macOS · Debian · Arch.

## Install

```bash
git clone <repo> ~/git/dotfiles && ~/git/dotfiles/install
```

Installs missing tools, sets login shell to Homebrew bash (macOS), applies dotfiles. Safe to re-run.

```bash
./install --verify-only   # audit without changing anything
```

## Daily

```bash
chezmoi diff              # preview pending changes
chezmoi apply             # apply dotfiles
chezmoi edit ~/.bashrc    # edit a managed file
chezmoi cd                # open source repo
```

## Machine-specific Git

Put name/email/signing keys in `~/.gitconfig.local` — it's included automatically, never tracked.

```gitconfig
[user]
    name = Your Name
    email = you@example.com
```

## Add a dotfile

Drop it in the repo using chezmoi naming (`dot_foo` → `~/.foo`), then `chezmoi apply`.

## Packages

- macOS: edit `Brewfile` at repo root, then re-run `./install` (runs `brew bundle`).
- Debian / Arch: edit `lib/install/package_managers.sh`.
