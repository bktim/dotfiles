install_homebrew() {
  if need_cmd brew; then
    return
  fi

  if ! need_cmd curl; then
    printf 'missing required command: curl\n' >&2
    exit 1
  fi

  log "Installing Homebrew"
  NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  if [[ -x /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [[ -x /usr/local/bin/brew ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
  fi
}

install_packages_debian() {
  require_sudo
  log "Installing packages with apt"
  run_as_root apt-get update
  run_as_root apt-get install -y \
    bash-completion \
    curl \
    fd-find \
    fzf \
    git \
    golang-go \
    nodejs \
    npm \
    python3 \
    python3-pip \
    python3-venv \
    ripgrep \
    shellcheck \
    shfmt \
    tmux \
    xclip \
    wl-clipboard \
    zoxide
}

install_packages_arch() {
  require_sudo
  log "Installing packages with pacman"
  run_as_root pacman -Sy --needed --noconfirm \
    bash-completion \
    chezmoi \
    curl \
    fd \
    fzf \
    git \
    go \
    neovim \
    nodejs \
    npm \
    python \
    python-pip \
    ripgrep \
    shellcheck \
    shfmt \
    stylua \
    tmux \
    wl-clipboard \
    xclip \
    zoxide
}

install_packages_macos() {
  install_homebrew
  log "Installing packages with Homebrew"
  brew install \
    bash \
    bash-completion@2 \
    chezmoi \
    fd \
    fzf \
    git \
    go \
    neovim \
    node \
    python \
    ripgrep \
    shellcheck \
    shfmt \
    stylua \
    tmux \
    zoxide
}

install_packages() {
  case $(os_id) in
    debian)
      install_packages_debian
      ;;
    arch)
      install_packages_arch
      ;;
    macos)
      install_packages_macos
      ;;
    *)
      printf 'unsupported platform; expected Debian, Arch, or macOS\n' >&2
      exit 1
      ;;
  esac
}
