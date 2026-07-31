# dotfiles

[![lint](https://github.com/bktim/dotfiles/actions/workflows/lint.yml/badge.svg)](https://github.com/bktim/dotfiles/actions/workflows/lint.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

Personal working environment for Bash, Neovim, tmux, and Git, managed with [chezmoi](https://www.chezmoi.io/)
across macOS, Debian, and Arch.

This repo keeps my machines consistent and serves as a code sample for small
automation and developer tooling. It is not a universal dotfiles framework.
Read it, borrow useful parts, and adapt them to your own machine.

Chezmoi source files use `dot_` prefix (renders to `.`) and `executable_`
prefix (renders as executable). See [Local settings](#local-settings-and-extensions)
for extending.

## How I work

- Keep configuration small enough to read in one sitting.
- Prefer portable behavior where practical, with explicit OS branches where it is not.
- Fail clearly when a required step cannot complete. Optional integrations may degrade gracefully.
- Automate repeated setup without hiding what the automation changes.
- Keep identity, credentials, and machine-specific data local.

## Requirements

- macOS, Debian, or Arch Linux
- Bash 4+
- Git
- Internet connection

`./install` fetches everything else (Neovim, chezmoi, Homebrew, packages, tools).

## Tour

### Bootstrap

`install` is the entry point. It detects macOS, Debian, or Arch, refuses to run
as root, and delegates focused work to `lib/install/`:

- `package_managers.sh` installs platform packages.
- `tools.sh` installs or locates Neovim, chezmoi, fnm, OpenCode, Rust, and the
  macOS login shell.
- `verify.sh` syncs Neovim plugins, runs health checks, and verifies required
  commands.
- `common.sh` holds shared command, path, version, and OS helpers.

Failures such as an unsupported platform, missing required command, outdated
Neovim, or failed Lazy plugin sync stop setup. Neovim `checkhealth` remains
advisory because it can report host-specific recommendations that do not make
the editor unusable.

### Terminal and tools

Alacritty config (`dot_config/alacritty/alacritty.toml`) sets font, colors,
and window behavior. A global gitignore (`dot_config/git/ignore`) covers
editor temp files, OS junk, and environment files. The `fd` wrapper
(`dot_local/bin/executable_fd`) delegates to `fdfind` or `fd` depending on
what is installed.

### Shell, tmux, and Git

Shell files keep startup defensive: interactive work is gated, optional tools
are checked before use, paths are added without duplicates, and Linux and
macOS variants are handled where needed. The tmux config adds vi-style copy
mode, portable clipboard commands, predictable pane movement, and little else.

Git defaults favor rebasing, automatic remote setup, rerere, pruned fetches,
and readable diffs. Personal identity and signing settings stay outside this
repo in `~/.gitconfig.local`.

### Neovim

Neovim uses LazyVim with local plugin specs under
`dot_config/nvim/lua/plugins/`. Mason installs and manages editor tooling,
while LSP, formatting, linting, and Treesitter settings remain visible in Lua.
`dot_config/nvim/lazy-lock.json` is tracked so plugin versions are reproducible.

### Quality checks

`scripts/lint` runs shfmt, ShellCheck, StyLua, and a headless Neovim startup
check. `scripts/lint --fix` formats shell and Lua files. If a checker is absent,
the script prints `PARTIAL`, names missing tools, and exits successfully after
running available checks. A real check failure prints `FAIL` and exits nonzero.

GitHub Actions installs those lint tools and Neovim before running the script.
CI also runs EditorConfig validation as a separate job, so local lint is not an
exact copy of CI. Optional pre-commit hooks add EditorConfig checks and file
hygiene such as trailing whitespace, merge markers, line endings, large files,
and executable shebang checks.

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

## Inspect, verify, install

Clone first. Review `install`, `lib/install/`, `Brewfile`, and the files chezmoi would apply before running setup.

```bash
git clone https://github.com/bktim/dotfiles.git ~/git/dotfiles
cd ~/git/dotfiles
```

Audit the current environment next:

```bash
./install --verify-only
```

`--verify-only` skips package installation and chezmoi apply. It checks required tools and Neovim health.
This is not a promise of zero side effects: starting Neovim may initialize editor state or plugin data.

Run full setup only after reviewing the changes:

```bash
./install
```

Full setup may:

- install packages with Homebrew, apt, or pacman;
- run a full Arch system upgrade through `pacman -Syu`;
- install Homebrew and download tool installers or release archives;
- register Homebrew Bash and change the macOS login shell;
- create a chezmoi config, then apply this repo to the home directory;
- download and synchronize Neovim plugins.

If `~/.config/chezmoi/chezmoi.toml` exists without the exact expected root
`sourceDir` for this clone, the installer leaves it unchanged, prints the value
to set manually, and fails.

## Daily workflow

```bash
chezmoi diff              # preview source changes against home
chezmoi apply             # apply reviewed changes
chezmoi edit ~/.bashrc    # edit a managed file through chezmoi
chezmoi status            # show source and destination drift
chezmoi cd                # open the active source directory
scripts/lint              # run available repository checks
pre-commit run --all-files
```

Enable hooks once per clone if `pre-commit` is installed:

```bash
pre-commit install
```

## Local settings and extensions

Put machine-specific Git settings in `~/.gitconfig.local`; `dot_gitconfig`
includes it automatically and the file is never tracked here.

```gitconfig
[user]
    name = Your Name
    email = you@example.com
```

To add a dotfile, use chezmoi source naming, such as `dot_foo` for `~/.foo`,
then inspect `chezmoi diff` before applying it. Add private or host-specific
values through local files rather than committing them.

Package lists live in two obvious places:

- macOS: edit `Brewfile`, then rerun `./install`.
- Debian or Arch: edit `lib/install/package_managers.sh`.

Extend Neovim through the existing `lua/config/` and `lua/plugins/` split.
Extend bootstrap behavior in the matching `lib/install/` module rather than
growing the entry point.

## License

Released under the [MIT License](LICENSE).
