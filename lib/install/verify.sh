sync_neovim_plugins() {
  if ! need_cmd nvim; then
    warn "Skipping Neovim plugin sync because nvim is not installed"
    return
  fi

  log "Syncing Neovim plugins"
  if ! nvim --headless "+Lazy! sync" +qa; then
    warn "Neovim plugin sync failed; run 'nvim --headless \"+Lazy! sync\" +qa' later"
  fi
}

check_neovim_health() {
  if ! need_cmd nvim; then
    warn "Skipping Neovim health check because nvim is not installed"
    return
  fi

  log "Running Neovim checkhealth"
  if ! nvim --headless "+checkhealth" +qa; then
    warn "Neovim health check reported issues; run 'nvim --headless \"+checkhealth\" +qa' later"
  fi
}

verify_cmd() {
  local label=$1
  shift

  if has_any_cmd "$@"; then
    printf '  [ok] %s\n' "$label"
    return 0
  fi

  printf '  [missing] %s\n' "$label"
  return 1
}

verify_tools() {
  local failures=0
  local current_nvim_version
  local nvm_version

  log "Verifying installed tools"

  verify_cmd "chezmoi" chezmoi || failures=$((failures + 1))
  verify_cmd "git" git || failures=$((failures + 1))
  verify_cmd "tmux" tmux || failures=$((failures + 1))
  if load_nvm; then
    if verify_cmd "nvm" nvm; then
      nvm_version=$(nvm --version 2>/dev/null || true)
      if [[ -n "$nvm_version" ]]; then
        printf '  [ok] nvm version %s\n' "$nvm_version"
      fi
    else
      failures=$((failures + 1))
    fi
  else
    printf '  [missing] nvm\n'
    failures=$((failures + 1))
  fi
  if verify_cmd "nvim" nvim; then
    if current_nvim_version=$(nvim_version) && version_ge "$current_nvim_version" "$minimum_nvim_version"; then
      printf '  [ok] nvim version >= %s (found %s)\n' "$minimum_nvim_version" "$current_nvim_version"
    else
      printf '  [missing] nvim version >= %s\n' "$minimum_nvim_version"
      failures=$((failures + 1))
    fi
  else
    failures=$((failures + 1))
  fi
  verify_cmd "opencode" opencode || failures=$((failures + 1))
  verify_cmd "fzf" fzf || failures=$((failures + 1))
  verify_cmd "zoxide" zoxide || failures=$((failures + 1))
  verify_cmd "fd / fdfind" fd fdfind || failures=$((failures + 1))
  verify_cmd "rg" rg || failures=$((failures + 1))
  verify_cmd "node" node || failures=$((failures + 1))
  verify_cmd "npm" npm || failures=$((failures + 1))
  verify_cmd "python3 / python" python3 python || failures=$((failures + 1))
  verify_cmd "pip3 / pip" pip3 pip || failures=$((failures + 1))
  verify_cmd "go" go || failures=$((failures + 1))
  verify_cmd "rustc" rustc || failures=$((failures + 1))
  verify_cmd "cargo" cargo || failures=$((failures + 1))
  verify_cmd "shellcheck" shellcheck || failures=$((failures + 1))
  verify_cmd "shfmt" shfmt || failures=$((failures + 1))

  case $(os_id) in
    macos)
      verify_cmd "pbcopy" pbcopy || true
      ;;
    *)
      verify_cmd "wl-copy / xclip" wl-copy xclip || true
      ;;
  esac

  if ((failures > 0)); then
    printf 'tool verification failed: %s required command(s) missing or outdated\n' "$failures" >&2
    exit 1
  fi
}
