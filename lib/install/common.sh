log() {
  printf '==> %s\n' "$*"
}

warn() {
  printf 'warning: %s\n' "$*" >&2
}

need_cmd() {
  command -v "$1" >/dev/null 2>&1
}

has_any_cmd() {
  local cmd

  for cmd in "$@"; do
    if need_cmd "$cmd"; then
      return 0
    fi
  done

  return 1
}

prepend_path_if_dir() {
  local dir=$1

  if [[ -d "$dir" && ":$PATH:" != *":$dir:"* ]]; then
    PATH="$dir:$PATH"
  fi
}

version_ge() {
  local left=${1#v}
  local right=${2#v}
  local left_parts=()
  local right_parts=()
  local i

  IFS=. read -r -a left_parts <<<"$left"
  IFS=. read -r -a right_parts <<<"$right"

  for ((i = ${#left_parts[@]}; i < ${#right_parts[@]}; i++)); do
    left_parts[i]=0
  done

  for ((i = ${#right_parts[@]}; i < ${#left_parts[@]}; i++)); do
    right_parts[i]=0
  done

  for ((i = 0; i < ${#left_parts[@]}; i++)); do
    if ((10#${left_parts[i]} > 10#${right_parts[i]})); then
      return 0
    fi

    if ((10#${left_parts[i]} < 10#${right_parts[i]})); then
      return 1
    fi
  done

  return 0
}

os_id() {
  if [[ $(uname -s) == "Darwin" ]]; then
    printf 'macos\n'
    return
  fi

  if [[ -r /etc/os-release ]]; then
    local distro
    # shellcheck disable=SC1091 # /etc/os-release is OS-provided, not in repo
    distro=$(. /etc/os-release && printf '%s\n' "${ID:-}")
    case $distro in
      debian | ubuntu)
        printf 'debian\n'
        return
        ;;
      arch)
        printf 'arch\n'
        return
        ;;
    esac
  fi

  printf 'unsupported\n'
}

require_sudo() {
  if [[ ${EUID:-$(id -u)} -ne 0 ]]; then
    if ! need_cmd sudo; then
      printf 'missing required command: sudo\n' >&2
      exit 1
    fi
  fi
}

run_as_root() {
  if [[ ${EUID:-$(id -u)} -eq 0 ]]; then
    "$@"
  else
    sudo "$@"
  fi
}
