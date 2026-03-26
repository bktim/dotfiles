# AGENTS.md

Guidance for coding agents working in this chezmoi-managed dotfiles repo.

## Scope
- Repo type: personal dotfiles source state for chezmoi.
- Main languages: Bash, Lua, tmux config, git config.
- Main areas:
  - `dot_bashrc`, `dot_bash_aliases`, `dot_bash_profile`, `dot_profile`
  - `dot_gitconfig`
  - `dot_tmux.conf`
  - `dot_config/nvim/` (LazyVim-based Neovim config)
  - `dot_local/bin/` (small shell helpers)

## Rule Files
- No `.cursor/rules/` files were found.
- No `.cursorrules` file was found.
- No `.github/copilot-instructions.md` file was found.
- If any of those files appear later, treat them as higher-priority repo instructions and update this file.

## Repo Model
- This repo is the chezmoi source state, not the rendered home directory.
- Filenames follow chezmoi naming:
  - `dot_foo` renders to `.foo`
  - `executable_bar` renders as an executable file
- Prefer editing files here instead of editing files under `$HOME` directly.
- Avoid templates unless output truly needs to vary by OS, host, or user data.
- Preserve Linux/macOS portability where practical.

## Core Commands

### Install / Apply
- Initial bootstrap from this clone: `./install`
- Verification-only audit: `./install --verify-only`
- `./install` installs required tools for Debian, Arch, or macOS, installs Homebrew on macOS if needed, installs `opencode`, installs a Rust toolchain with `rustup`, runs `chezmoi apply --source "$PWD"` (with `chezmoi init` for first-time setup), sets login shell to Homebrew bash on macOS, then performs verification checks and fails if required tools are still missing
- `./install --verify-only` skips package installation and chezmoi apply, and only runs verification checks
- Re-apply changes: `chezmoi apply`
- Preview rendered changes: `chezmoi diff`
- Show source/render drift: `chezmoi status`
- Open the active source dir: `chezmoi cd`

### Build
- There is no formal build system.
- Full bootstrap/setup: `./install`
- Read-only environment audit: `./install --verify-only`
- Neovim/plugin bootstrap validation: `nvim --headless "+Lazy! sync" +qa`
- Basic Neovim config smoke test: `nvim --headless +qa`
- Neovim health validation: `nvim --headless "+checkhealth" +qa`

### Lint / Static Checks
- There is no dedicated repo-wide lint task.
- Single shell file syntax check: `bash -n path/to/script`
- Known entrypoints:
  - `bash -n install`
  - `bash -n dot_local/bin/executable_fd`
  - `bash -n dot_local/bin/executable_devvm-info`
- Batch syntax check for tracked scripts:
  - `bash -n install dot_local/bin/executable_fd dot_local/bin/executable_devvm-info`
- No checked-in `shellcheck` config exists.
- No checked-in `stylua` config exists.

### Tests
- No formal automated test suite exists today.
- No unit-test runner is configured for Lua or shell.
- Treat validation as targeted smoke testing plus syntax checks.

### Single-Test / Targeted Validation
- There is no canonical "run one test" command because no test framework is configured.
- For one shell file, use: `bash -n path/to/script`
- For a safe read-only helper, running the script directly is acceptable.
- For Neovim config changes, use: `nvim --headless +qa`
- For Neovim plugin changes, use: `nvim --headless "+Lazy! sync" +qa`
- For chezmoi rendering changes, inspect only the affected diff with: `chezmoi diff`

## Recommended Validation By Change Type
- Shell startup files changed:
  - `chezmoi diff`
  - `bash -n install dot_local/bin/executable_fd dot_local/bin/executable_devvm-info`
- Helper scripts changed:
  - `bash -n path/to/script`
  - run the script if it is clearly safe and side effects are minimal
- Neovim Lua changed:
  - `nvim --headless +qa`
  - `nvim --headless "+Lazy! sync" +qa` for plugin changes
- tmux config changed:
  - review syntax carefully
  - optionally reload a live session with `tmux source-file ~/.tmux.conf`
- bootstrap/install changed:
  - `bash -n install`
  - `nvim --headless "+checkhealth" +qa`
  - run `./install` on a supported platform when you need end-to-end validation
- Git config changed:
  - keep changes minimal
  - inspect with `chezmoi diff`

## Editing Conventions
- Default to small, surgical edits.
- Match surrounding style; avoid broad reformatting.
- Do not introduce new tooling configs unless the task calls for them.
- Do not rename chezmoi source files unless the rendered target should change.
- Avoid comments unless they clarify non-obvious behavior.
- Update `README.md` too if a user-facing workflow or dependency changes.

## Bash Style
- Use `#!/usr/bin/env bash` for executable scripts.
- Use `set -euo pipefail` in standalone scripts.
- Quote expansions by default: `"$var"`, `"$@"`, `"${NAME:-default}"`.
- Prefer small helper functions for repeated logic.
- Use lowercase `snake_case` for variables and functions.
- Use `local` inside functions.
- Check command availability with `command -v foo >/dev/null 2>&1`.
- Prefer `printf` over `echo` for predictable output.
- Use `exec` for pass-through wrapper scripts.
- Keep interactive shell files safe:
  - gate interactive-only logic when needed
  - source optional files only after existence checks
- Preserve the existing style of concise helpers like `source_first` and `path_prepend`.

## Lua / Neovim Style
- Use 2-space indentation.
- Use double quotes consistently, matching existing files.
- Favor short local aliases for common APIs, for example:
  - `local opt = vim.opt`
  - `local map = vim.keymap.set`
- Keep `require("...")` usage simple and near setup code.
- Return plugin specs as Lua tables from `lua/plugins/` files.
- Prefer trailing commas in multiline tables.
- Keep plugin config declarative unless custom logic is necessary.
- Name augroups, keymaps, and descriptions clearly.
- Include `desc` for user-facing keymaps and autocmds where appropriate.
- Follow the current layout:
  - `lua/config/` for core setup
  - `lua/plugins/` for plugin specs and overrides

## Imports, Dependencies, and Shapes
- In Lua, use `require("module")`; avoid custom loader patterns unless needed.
- In Bash, avoid unnecessary external dependencies.
- Prefer tools already assumed by the repo or README: `chezmoi`, `nvim`, `git`, `opencode`, `node`/`npm`, `python3`, `go`, `cargo`, `fzf`, `zoxide`, clipboard helpers.
- Guard dependency-sensitive behavior so startup still works when a tool is missing.
- No typed language or typechecker is configured here.
- For Lua plugin specs, keep table shapes compatible with LazyVim/lazy.nvim conventions.
- For shell scripts, prefer simple positional args and environment lookups over complex parsing.

## Naming Conventions
- Shell variables/functions: lowercase `snake_case`.
- Lua locals: short lowercase names or descriptive `snake_case`.
- Lua modules: name files by purpose under `config/` or `plugins/`.
- Autocmd groups: descriptive string names like `dotfiles_autocmds`.
- chezmoi files: preserve `dot_` and `executable_` prefixes.

## Error Handling
- Fail fast in standalone Bash scripts with `set -euo pipefail`.
- Validate required commands before using them.
- Print clear stderr messages for missing prerequisites.
- In wrapper scripts, let `exec` preserve the underlying exit status.
- In Neovim bootstrap code, keep explicit shell-error checks and clear failure messages.
- For optional integrations, degrade gracefully instead of failing startup.

## Change Discipline
- Preserve cross-platform behavior unless the task is explicitly OS-specific.
- Be careful with shell startup files; small regressions affect every interactive session.
- Keep bootstrap automation idempotent so rerunning `./install` is safe.
- For Neovim changes, prefer the established LazyVim structure over ad hoc globals.
- For tmux and git config, keep additions additive and easy to scan.
- If no formal lint/test command exists for your change, say what validation you used instead.

## When Unsure
- Prefer the simplest change that matches current repo patterns.
- Validate only the files or workflows you touched.
- Keep the source-state vs rendered-file distinction in mind.
