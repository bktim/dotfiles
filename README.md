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

## Lint / format

All shell, Lua, and whitespace checks are enforced by one script:

```bash
scripts/lint              # check everything (same as CI / pre-commit)
scripts/lint --fix        # auto-format shell (shfmt) and Lua (stylua)
```

Enable pre-commit hooks once per clone:

```bash
pre-commit install
```

Tool flags live in one place per tool and are kept in sync across
`scripts/lint`, `.pre-commit-config.yaml`, `.github/workflows/lint.yml`, and
the Neovim `conform.nvim` config. Editor behavior is pinned via
`.editorconfig`, `.shellcheckrc`, and `stylua.toml`.

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
