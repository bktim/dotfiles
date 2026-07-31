# dotfiles

[![lint](https://github.com/bktim/dotfiles/actions/workflows/lint.yml/badge.svg)](https://github.com/bktim/dotfiles/actions/workflows/lint.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

Bash, Neovim (LazyVim), tmux, Git, Alacritty — managed with [chezmoi](https://www.chezmoi.io/).
macOS / Debian / Arch. Cross-platform, automated, minimal.

## Stack

| Layer | Tooling |
|---|---|
| Shell | Bash 4+, [fzf](https://github.com/junegunn/fzf), [zoxide](https://github.com/ajeetdsouza/zoxide), [fnm](https://github.com/Schniz/fnm), [opencode](https://opencode.ai) |
| Editor | Neovim 0.12+, [LazyVim](https://www.lazyvim.org/), [Mason](https://github.com/mason-org/mason.nvim), LSP/formatter/lint per language |
| Terminal | tmux (vi-mode, pane nav), Alacritty |
| Config | chezmoi source-state, identity via `~/.gitconfig.local` (untracked) |
| Quality | shfmt, shellcheck, stylua, editorconfig — enforced via `scripts/lint`, pre-commit hooks, GitHub Actions |
| Bootstrap | Single `./install` entrypoint: OS detect → packages → tools → chezmoi apply → verify |

## Key bindings

### tmux (prefix `C-b`)

| Key | Action |
|---|---|
| `h` `j` `k` `l` | Navigate panes |
| `s` / `v` | Split below / right |
| `r` | Reload config |
| `^` | Last window |

### Shell

| Key | Action |
|---|---|
| `Ctrl-r` | fzf history |
| `Ctrl-t` | fzf file picker |
| `Alt-c` | fzf cd |

`cd` is zoxide — learns directories, fuzzy matches. `v` → nvim, `gs` → `git status -sb`, `gl` → git log graph.

### Neovim

Stock [LazyVim](https://www.lazyvim.org/keymaps) keymaps. Custom: `<leader>fn` — new buffer.

## Install

```bash
git clone https://github.com/bktim/dotfiles.git ~/git/dotfiles
cd ~/git/dotfiles
./install --verify-only   # audit, no changes
./install                 # full setup
```

Requirements: Bash 4+, Git, internet. OS: macOS, Debian, or Arch. `./install` fetches the rest.

## License

MIT — see [LICENSE](LICENSE).
