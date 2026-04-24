# This file is sourced by ../../install. `repo_dir` and `minimum_nvim_version`
# are assigned there before sourcing.
# shellcheck disable=SC2154

opencode_bin() {
  if need_cmd opencode; then
    command -v opencode
    return
  fi

  if [[ -x "$HOME/.opencode/bin/opencode" ]]; then
    printf '%s\n' "$HOME/.opencode/bin/opencode"
    return
  fi

  if [[ -x "$HOME/.local/bin/opencode" ]]; then
    printf '%s\n' "$HOME/.local/bin/opencode"
    return
  fi

  return 1
}

install_fnm() {
  if need_cmd fnm; then
    log "fnm already installed at $(command -v fnm)"
    return
  fi

  case $(os_id) in
    macos)
      log "Installing fnm"
      brew install fnm
      ;;
    debian | arch)
      if ! need_cmd curl; then
        printf 'missing required command: curl\n' >&2
        exit 1
      fi

      log "Installing fnm"
      curl -fsSL https://fnm.vercel.app/install | bash -s -- --install-dir "$HOME/.local/bin" --skip-shell
      prepend_path_if_dir "$HOME/.local/bin"
      ;;
  esac

  if ! need_cmd fnm; then
    printf 'fnm installation completed but binary not found\n' >&2
    exit 1
  fi
}

nvim_bin() {
  if need_cmd nvim; then
    command -v nvim
    return
  fi

  if [[ -x "$HOME/.local/bin/nvim" ]]; then
    printf '%s\n' "$HOME/.local/bin/nvim"
    return
  fi

  if [[ -x "$HOME/.local/opt/nvim/bin/nvim" ]]; then
    printf '%s\n' "$HOME/.local/opt/nvim/bin/nvim"
    return
  fi

  return 1
}

nvim_version() {
  local nvim_path
  local version_line

  if ! nvim_path=$(nvim_bin); then
    return 1
  fi

  version_line=$("$nvim_path" --version 2>/dev/null || true)
  version_line=${version_line%%$'\n'*}
  version_line=${version_line#NVIM }
  version_line=${version_line#v}

  if [[ -z "$version_line" ]]; then
    return 1
  fi

  printf '%s\n' "$version_line"
}

nvim_release_arch() {
  case $(uname -m) in
    x86_64)
      printf 'x86_64\n'
      ;;
    aarch64 | arm64)
      printf 'arm64\n'
      ;;
    *)
      return 1
      ;;
  esac
}

install_neovim_from_tarball() {
  local platform=$1
  local arch
  local archive_name
  local url
  local tmp_dir
  local extract_root
  local install_root="$HOME/.local/opt/nvim"

  if ! need_cmd curl; then
    printf 'missing required command: curl\n' >&2
    exit 1
  fi

  if ! need_cmd tar; then
    printf 'missing required command: tar\n' >&2
    exit 1
  fi

  if ! arch=$(nvim_release_arch); then
    printf 'unsupported architecture for Neovim bootstrap: %s\n' "$(uname -m)" >&2
    exit 1
  fi

  archive_name="nvim-${platform}-${arch}.tar.gz"
  url="https://github.com/neovim/neovim/releases/download/stable/${archive_name}"
  tmp_dir=$(mktemp -d)
  extract_root="$tmp_dir/extract"
  mkdir -p "$extract_root" "$HOME/.local/bin" "$HOME/.local/opt"

  log "Installing Neovim $minimum_nvim_version or newer from official release"
  trap 'rm -rf "$tmp_dir"' RETURN
  curl -fL "$url" -o "$tmp_dir/$archive_name"
  tar -xzf "$tmp_dir/$archive_name" -C "$extract_root"
  if [[ -d "$install_root" ]]; then
    mv "$install_root" "$install_root.old.$$"
  fi
  if ! mv "$extract_root"/nvim-* "$install_root"; then
    if [[ -d "$install_root.old.$$" ]]; then
      mv "$install_root.old.$$" "$install_root"
    fi
    printf 'failed to install Neovim: mv failed\n' >&2
    exit 1
  fi
  rm -rf "$install_root.old.$$"
  ln -sfn "$install_root/bin/nvim" "$HOME/.local/bin/nvim"
  prepend_path_if_dir "$HOME/.local/bin"
  trap - RETURN
  rm -rf "$tmp_dir"
}

install_neovim() {
  local current_version

  if current_version=$(nvim_version); then
    if version_ge "$current_version" "$minimum_nvim_version"; then
      log "Neovim already installed at $(nvim_bin) (v$current_version)"
      PATH="$(dirname "$(nvim_bin)"):$PATH"
      export PATH
      return
    fi

    warn "Neovim v$current_version is too old; upgrading to v$minimum_nvim_version or newer"
  fi

  case $(os_id) in
    debian | arch)
      install_neovim_from_tarball "linux"
      ;;
    macos)
      install_neovim_from_tarball "macos"
      ;;
    *)
      printf 'unsupported platform for Neovim bootstrap\n' >&2
      exit 1
      ;;
  esac

  if ! current_version=$(nvim_version); then
    printf 'Neovim installation completed but version could not be detected\n' >&2
    exit 1
  fi

  if ! version_ge "$current_version" "$minimum_nvim_version"; then
    printf 'Neovim installation completed but version %s is still below required %s\n' "$current_version" "$minimum_nvim_version" >&2
    exit 1
  fi
}

chezmoi_bin() {
  if need_cmd chezmoi; then
    command -v chezmoi
    return
  fi

  if [[ -x "$HOME/.local/bin/chezmoi" ]]; then
    printf '%s\n' "$HOME/.local/bin/chezmoi"
    return
  fi

  if [[ -x "$HOME/bin/chezmoi" ]]; then
    printf '%s\n' "$HOME/bin/chezmoi"
    return
  fi

  return 1
}

configure_chezmoi_source() {
  local config_dir="$HOME/.config/chezmoi"
  local config_file="$config_dir/chezmoi.toml"

  mkdir -p "$config_dir"

  if [[ -f "$config_file" ]] && grep -qxF "sourceDir = \"$repo_dir\"" "$config_file" 2>/dev/null; then
    log "chezmoi source already configured: $repo_dir"
    return
  fi

  log "Configuring chezmoi source directory: $repo_dir"
  printf 'sourceDir = "%s"\n' "$repo_dir" >"$config_file"
}

install_chezmoi() {
  local chezmoi_path

  if chezmoi_path=$(chezmoi_bin); then
    log "chezmoi already installed at $chezmoi_path"
    PATH="$(dirname "$chezmoi_path"):$PATH"
    export PATH
    return
  fi

  if ! need_cmd curl; then
    printf 'missing required command: curl\n' >&2
    exit 1
  fi

  log "Installing chezmoi"
  sh -c "$(curl -fsLS get.chezmoi.io)" -- -b "$HOME/.local/bin"
  prepend_path_if_dir "$HOME/.local/bin"

  if chezmoi_path=$(chezmoi_bin); then
    PATH="$(dirname "$chezmoi_path"):$PATH"
    export PATH
    return
  fi

  # shellcheck disable=SC2016 # literal "$HOME/..." text intended in user-facing message
  printf 'chezmoi installation completed but binary was not found in PATH, "$HOME/.local/bin", or "$HOME/bin"\n' >&2
  exit 1
}

install_opencode() {
  local opencode_path

  if opencode_path=$(opencode_bin); then
    log "OpenCode already installed at $opencode_path"
    PATH="$(dirname "$opencode_path"):$PATH"
    export PATH
    return
  fi

  if ! need_cmd curl; then
    printf 'missing required command: curl\n' >&2
    exit 1
  fi

  log "Installing OpenCode"
  /bin/bash -c "$(curl -fsSL https://opencode.ai/install)"

  if opencode_path=$(opencode_bin); then
    PATH="$(dirname "$opencode_path"):$PATH"
    export PATH
    return
  fi

  # shellcheck disable=SC2016 # literal "$HOME/..." text intended in user-facing message
  printf 'OpenCode installation completed but binary was not found in PATH, "$HOME/.opencode/bin", or "$HOME/.local/bin"\n' >&2
  exit 1
}

install_rust_toolchain() {
  if need_cmd rustc && need_cmd cargo; then
    log "Rust toolchain already installed"
    return
  fi

  if ! need_cmd curl; then
    printf 'missing required command: curl\n' >&2
    exit 1
  fi

  log "Installing Rust toolchain with rustup"
  curl --proto '=https' --tlsv1.2 -fsSL https://sh.rustup.rs | sh -s -- -y

  if [[ -f "$HOME/.cargo/env" ]]; then
    # shellcheck disable=SC1091
    . "$HOME/.cargo/env"
  fi
  prepend_path_if_dir "$HOME/.cargo/bin"

  if ! need_cmd rustc || ! need_cmd cargo; then
    printf 'Rust installation completed but rustc/cargo were not found\n' >&2
    exit 1
  fi
}

set_login_shell_bash() {
  # macOS ships bash 3.2 at /bin/bash. We want Homebrew bash as the login shell.
  # No-op on non-macOS (users pick their own login shell via distro tooling).
  if [[ $(os_id) != "macos" ]]; then
    return
  fi

  local brew_bash
  if [[ -x /opt/homebrew/bin/bash ]]; then
    brew_bash=/opt/homebrew/bin/bash
  elif [[ -x /usr/local/bin/bash ]]; then
    brew_bash=/usr/local/bin/bash
  else
    warn "Homebrew bash not found; skipping login shell change"
    return
  fi

  local current_shell=${SHELL:-}
  if [[ "$current_shell" == "$brew_bash" ]]; then
    log "Login shell already $brew_bash"
    return
  fi

  if ! grep -qxF "$brew_bash" /etc/shells 2>/dev/null; then
    log "Registering $brew_bash in /etc/shells"
    printf '%s\n' "$brew_bash" | run_as_root tee -a /etc/shells >/dev/null
  fi

  log "Setting login shell to $brew_bash"
  if ! chsh -s "$brew_bash"; then
    warn "chsh failed; set login shell manually with: chsh -s $brew_bash"
  fi
}

install_hack_nerd_font() {
  # On macOS the Brewfile installs font-hack-nerd-font via cask; verify presence.
  # On Linux, font is optional (terminal emulator may ship its own).
  if [[ $(os_id) != "macos" ]]; then
    return
  fi

  if ls "$HOME/Library/Fonts"/HackNerdFont*.ttf >/dev/null 2>&1; then
    log "Hack Nerd Font already installed (user)"
    return
  fi

  if ls /Library/Fonts/HackNerdFont*.ttf >/dev/null 2>&1; then
    log "Hack Nerd Font already installed (system)"
    return
  fi

  # Fallback if Brewfile cask install silently skipped.
  if need_cmd brew; then
    log "Installing Hack Nerd Font via Homebrew cask"
    brew install --cask font-hack-nerd-font || warn "Hack Nerd Font install failed; install manually"
  fi
}
