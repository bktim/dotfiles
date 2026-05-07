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

## Key bindings

### tmux (prefix: `C-b`)

| Key | Action |
|---|---|
| `prefix r` | Reload tmux config |
| `prefix ^` | Last window |
| `prefix h/j/k/l` | Navigate panes (vim-style) |
| `prefix s` | Split below (keeps cwd) |
| `prefix v` | Split right (keeps cwd) |
| `v` / `y` in copy mode | Begin selection / yank (vi mode) |

### fzf (shell)

| Key | Action |
|---|---|
| `Ctrl-r` | Fuzzy history search |
| `Ctrl-t` | Fuzzy file picker (insert path) |
| `Alt-c` | Fuzzy cd into directory |

### zoxide

`cd` is replaced by zoxide — it learns from usage and fuzzy-matches directories. `cdi` opens an interactive picker.

### Shell aliases

| Alias | Expands to |
|---|---|
| `v` / `vim` | `nvim` |
| `gs` | `git status -sb` |
| `gl` | `git log --oneline --decorate --graph -20` |
| `ll` / `la` / `l` | `ls -lh` / `ls -lA` / `ls -CF` |
| `oc` | `opencode` |

### Neovim

Stock [LazyVim](https://www.lazyvim.org/keymaps) keymaps. Custom addition: `<leader>fn` — new buffer.

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
scripts/lint              # check shell (shellcheck, shfmt) and Lua (stylua)
scripts/lint --fix        # auto-format shell (shfmt) and Lua (stylua)
```

Pre-commit hooks and CI run additional checks (trailing whitespace, EOF,
editorconfig). Enable pre-commit hooks once per clone:

```bash
pre-commit install
```

Tool flags live in one place per tool and are kept in sync across
`scripts/lint`, `.pre-commit-config.yaml`, and `.github/workflows/lint.yml`.
Editor behavior is pinned via `.editorconfig`, `.shellcheckrc`, and
`stylua.toml`.

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
