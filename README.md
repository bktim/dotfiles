# dotfiles

Personal development environment

This repo uses GNU Stow to manage files in `$HOME`.

## Structure

- `shell/` - shell startup files
- `git/` - Git configuration
- `tmux/` - tmux configuration
- `nvim/` - LazyVim-based Neovim configuration
- `bin/` - small helper scripts in `~/.local/bin`

## Install

```bash
./install
```

The installer uses `stow --restow`.

## Neovim

The `nvim/` package uses the LazyVim starter structure.

On first launch, LazyVim bootstraps `lazy.nvim` and downloads plugins automatically.

This repo expects the VM provisioning layer to install a modern Neovim release compatible with LazyVim.

Useful commands:

```bash
nvim
nvim --headless "+Lazy! sync" +qa
```

## Add a new package

1. Create a new top-level directory such as `zsh/` or `direnv/`.
2. Put files inside it using their target home-relative paths.
3. Add the package name to `packages=(...)` in `install`.
4. Re-run `./install`.
