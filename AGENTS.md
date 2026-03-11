# AGENTS.md

This repository is a personal dotfiles setup centered on shell configuration,
editor configuration, and one installation workflow.

Agents working here should optimize for safety, idempotence, and minimal surprise.
Most files are user-facing configs, so small edits can have broad interactive impact.

## Scope

- Main entrypoint: `install.sh`
- Main validation script: `test-install.sh`
- Shell configs: `bash/bashrc`, `zsh/zshrc`
- Editor configs: `vim/vimrc`, `tmux/tmux.conf`, `git/gitconfig`
- Ranger config: `ranger/`
- Local machine overrides example: `.config/config.sh`

## Rule Sources

- No `.cursorrules` file was found.
- No files were found under `.cursor/rules/`.
- No `.github/copilot-instructions.md` file was found.
- This file is therefore the primary agent instruction source in-repo.

## Build / Lint / Test Commands

There is no formal build system, package manager manifest, or dedicated lint config.
The repo is mostly shell/config files, so validation is command-based.

### Primary commands

- Full install flow: `./install.sh`
- Full validation flow: `./test-install.sh`
- Make scripts executable if needed: `chmod +x install.sh test-install.sh`

### Fast validation commands

- Bash syntax check for installer: `bash -n install.sh`
- Bash syntax check for validation script: `bash -n test-install.sh`
- Python syntax check for ranger command file: `python -m py_compile ranger/commands.py`
- Optional syntax check for ranger sample file: `python -m py_compile ranger/commands_full.py`
- Vim plugin install smoke test: `vim +PlugInstall +qall`

### Single-test guidance

There is no unit-test framework with named test cases.
`test-install.sh` is one monolithic integration check.

If you need the equivalent of a single targeted test, run only the narrow command
that matches the area you changed:

- Shell script edit in `install.sh`: `bash -n install.sh`
- Shell script edit in `test-install.sh`: `bash -n test-install.sh`
- Ranger Python edit: `python -m py_compile ranger/commands.py`
- Vim config edit: `vim -Nu vim/vimrc +qa`
- Zsh config edit: `zsh -n zsh/zshrc`

For end-to-end verification after install logic changes, still run:

- `./test-install.sh`

### Suggested validation by change type

- Changed package installation or symlink logic: `bash -n install.sh && ./test-install.sh`
- Changed shell config content only: `zsh -n zsh/zshrc && bash -n bash/bashrc`
- Changed ranger Python command logic: `python -m py_compile ranger/commands.py`
- Changed Vim config: `vim -Nu vim/vimrc +qa`

## Repository Conventions

### General principles

- Prefer minimal, surgical edits over broad rewrites.
- Preserve user-specific customizations unless the task explicitly asks to normalize them.
- Keep scripts idempotent when possible; re-running `install.sh` should remain safe.
- Favor compatibility across Ubuntu/Debian, CentOS/RHEL, Fedora, and Arch when editing installer logic.
- Avoid introducing new dependencies unless clearly necessary.

### Shell style

The authored shell scripts use Bash with straightforward imperative control flow.
Follow that style unless a file already requires shell-specific features.

- Use `#!/bin/bash` for Bash scripts already using that shebang.
- Quote variable expansions in paths and command arguments: `"$HOME"`, `"$DOTFILES_DIR"`.
- Prefer `command -v tool &> /dev/null` for existence checks; this style is already used.
- Use arrays for grouped values like package lists and plugin lists.
- Use small helper functions for repeated logic, as seen in `install.sh`.
- Keep branching explicit with `if` / `elif` blocks for distro detection.
- Print clear status lines with `echo` and consistent success/failure markers.
- Use `mkdir -p` before linking or writing into directories.
- Prefer `ln -sf` for managed symlinks that should be refreshed.
- Avoid clever shell one-liners when readable multi-line logic is clearer.

### Shell error handling

- Existing scripts do not use `set -euo pipefail`; do not add it casually to legacy files.
- Preserve the current error model unless you verify all branches remain safe.
- Fail fast with `exit 1` when a required dependency or validation step is missing.
- For optional steps, emit a warning and continue rather than hard-failing.
- When invoking interactive or networked tools, provide a fallback message for manual recovery.

### Imports and module usage

Python usage is minimal and localized to ranger command files.

- Keep imports at the top of the file.
- Follow existing standard-library-first ordering.
- Reuse `ranger.api.commands.Command` patterns already present in `ranger/commands.py`.
- Do not add heavy Python abstractions for simple ranger commands.

### Python style

- Match the existing simple class-based ranger command structure.
- Use descriptive local names like `target_filename` rather than short abbreviations.
- Return early on invalid input or missing files.
- Surface user-facing failures through `self.fm.notify(..., bad=True)`.
- Keep command methods short and operational.

### Naming conventions

- Shell functions: lowercase with underscores, e.g. `check_and_install_packages`.
- Shell variables: uppercase for exported/env-style values, lowercase or local for temporaries.
- Arrays use plural names, e.g. `packages`, `missing_tools`, `plugins`.
- Python command classes use lower-case sample names only when required by ranger conventions; otherwise prefer readable identifiers.
- Config variables should follow the host tool's native naming style rather than forcing one style globally.

### Formatting

- Preserve existing indentation style within each file.
- In Bash scripts here, indentation is currently 4 spaces inside functions and conditionals.
- In `zsh/zshrc`, mixed indentation exists; avoid mass reformatting unrelated lines.
- Keep line lengths reasonable, but do not wrap tool-specific config strings unnecessarily.
- Align repeated config entries only when it improves readability and matches nearby style.

### Comments

- Keep comments functional and task-oriented.
- Prefer section headers when grouping installer phases.
- Do not add obvious comments for self-explanatory assignments.
- When behavior is surprising, explain why, not just what.

### Config-file editing guidance

- Treat `zsh/zshrc` as interactive shell startup code; avoid slow commands on every shell launch.
- Treat `.config/config.sh` as a local override example; keep it generic and safe to copy.
- Treat `vim/vimrc` as hand-maintained config; preserve plugin and keymap organization.
- Treat `ranger/commands.py` as a light customization file, not a place to duplicate `commands_full.py`.

### Safety rules for agents

- Do not hardcode machine-specific absolute paths unless the file already intentionally does so.
- If you touch existing absolute paths in `zsh/zshrc`, verify they are still consistent with the surrounding config.
- Do not remove user environment exports just because they are personal.
- Do not replace symlink-based setup with file copies unless explicitly requested.
- Avoid destructive file operations in `$HOME` or `/etc` without a clear task requirement.

## Practical workflow for agents

1. Read the target config and nearby related files first.
2. Make the smallest change that satisfies the request.
3. Run the narrowest validation command for the edited file.
4. Run `./test-install.sh` for changes that affect install or verification behavior.
5. Summarize user-visible effects, especially for shell startup, symlinks, or package installation.

## Good defaults

- Prefer compatibility over novelty.
- Prefer explicit commands over abstractions.
- Prefer additive config changes over destructive rewrites.
- Prefer targeted validation over no validation.
- Prefer preserving user intent over stylistic cleanup.
