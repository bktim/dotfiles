case $- in
  *i*) ;;
  *) return ;;
esac

export EDITOR=nvim
export VISUAL=nvim
export PAGER=less

if [[ -f "$HOME/.bash_aliases" ]]; then
  . "$HOME/.bash_aliases"
fi

if command -v dircolors >/dev/null 2>&1; then
  eval "$(dircolors -b)"
  alias ls='ls --color=auto'
fi

if [[ -f /usr/share/bash-completion/bash_completion ]]; then
  . /usr/share/bash-completion/bash_completion
fi

if [[ -f /usr/share/doc/fzf/examples/key-bindings.bash ]]; then
  . /usr/share/doc/fzf/examples/key-bindings.bash
fi

if [[ -f /usr/share/doc/fzf/examples/completion.bash ]]; then
  . /usr/share/doc/fzf/examples/completion.bash
fi
