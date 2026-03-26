# dotfiles

Personal development environment managed with chezmoi.

## Layout

This repository is the chezmoi source state, with a small `.chezmoiignore` for repo-only files such as `README.md` and `install`.

- `dot_bashrc`, `dot_bash_aliases`, `dot_bash_profile`, `dot_profile` - shell startup files
- `dot_gitconfig` - Git configuration
- `dot_tmux.conf` - tmux configuration with portable clipboard support
- `dot_config/nvim/` - LazyVim-based Neovim configuration
- `dot_local/bin/` - small helper scripts in `~/.local/bin`

The repo keeps most files as plain source-state files and relies on templates only when rendered output truly needs to differ.

## Bootstrap a machine

If the repo is already cloned locally, the bootstrap script installs the required tools and then applies the dotfiles:

```bash
./install
```

That same entrypoint is safe to call from VM or host provisioning when you want the dotfiles repo to remain the source of truth.

If you only want to audit the machine without changing it:

```bash
./install --verify-only
```

The bootstrap currently supports Debian, Arch Linux, and macOS.

- Debian: uses `apt-get`
- Arch Linux: uses `pacman`
- macOS: installs Homebrew first if needed, then uses `brew`

On macOS, the bootstrap also changes your login shell to the Homebrew-installed bash (adding it to `/etc/shells` if needed). This is necessary because macOS defaults to zsh, which means the bash startup files managed by this repo would never load otherwise.

Core tools installed automatically include:

- `chezmoi`
- `git`
- `tmux`
- `neovim`
- `opencode`
- `nvm`
- `node` / `npm`
- `python3` / `pip3`
- `go`
- `rustc` / `cargo` via `rustup`
- `fzf`
- `zoxide`
- `fd` / `fdfind`
- `ripgrep`
- `shellcheck`
- `shfmt`
- `bash-completion`
- `curl`
- clipboard helpers (`wl-clipboard`, `xclip`) on Linux

`opencode` is installed with the official install script, which places the binary in a user-local location such as `~/.opencode/bin`.
`nvm` is cloned into `~/.nvm` and sourced by Bash startup files so interactive shells can use it immediately. Re-running `./install` updates nvm in place instead of destroying the existing clone.
Rust is installed with `rustup` so the standard `cargo` toolchain is available consistently across platforms.
Neovim is checked for a minimum supported version of `0.11.2`; if the system package is missing or too old, bootstrap installs the current official Neovim release into `~/.local`. Upgrades swap the old install atomically so a failed download never leaves you without a working `nvim`.

## Apply this repo

If the repo is already cloned locally:

```bash
./install
```

That bootstrap flow installs missing dependencies, then on first run:

```bash
chezmoi init --apply "$PWD"
```

On subsequent runs, it uses `chezmoi update` to pull the latest changes from
the repo and apply them. This keeps your current clone as the active chezmoi
source directory, so commands like `chezmoi edit ~/.bashrc` work against this
repo directly.

If you want to initialize directly with chezmoi from another machine, use your git remote with:

```bash
chezmoi init --apply <repo-url>
```

That path assumes `chezmoi` is already available. For a fresh machine, using the repo-local `./install` script is the fully automated option.

If you want to work on the managed source tree directly later:

```bash
chezmoi cd
```

When you install from this clone, `chezmoi cd` should take you back to the same
repository path.

## Daily use

```bash
chezmoi diff
chezmoi apply
chezmoi edit ~/.bashrc
chezmoi cd
chezmoi status
```

## Machine-specific Git settings

This repo manages a shared baseline `~/.gitconfig` and now includes an optional per-machine file:

```gitconfig
[include]
    path = ~/.gitconfig.local
```

Use `~/.gitconfig.local` for sensitive or machine-specific values such as:

- `user.email`
- `user.name`
- signing keys
- work-only Git settings

Example:

```gitconfig
[user]
    name = Tim Example
    email = tim@example.com
```

Leave `~/.gitconfig.local` absent on machines that do not need extra settings.

## Neovim

The Neovim config uses the LazyVim starter structure.

On first launch, LazyVim bootstraps `lazy.nvim` and downloads plugins automatically.

Useful commands:

```bash
nvim
nvim --headless "+Lazy! sync" +qa
```

The bootstrap script also attempts a headless Lazy sync after applying the dotfiles.
It ensures Neovim is at least `0.11.2` first, because current LazyVim requires that baseline.
It then runs:

```bash
nvim --headless "+checkhealth" +qa
```

and prints a small verification summary for the core CLI tools it expects to be available. If a required tool is still missing after bootstrap, `./install` exits non-zero.
The `--verify-only` mode runs the same verification checks without installing packages or applying dotfiles.

## Add a new dotfile

1. Add the file to the repo using chezmoi naming conventions, for example `dot_bashrc` or `dot_config/alacritty/alacritty.toml`.
2. Use `.tmpl` only when the rendered output must differ by OS, host, or user data.
3. Run `chezmoi diff` and `chezmoi apply` to verify the change.
