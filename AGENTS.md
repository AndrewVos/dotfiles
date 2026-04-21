# AGENTS.md

## Purpose

This repository provisions a macOS machine with Homebrew packages and GNU Stow-managed dotfiles.

The main entrypoint is `./install`, which:

- installs formulae, casks, taps, and language runtimes
- appends a few required shell lines to local startup files
- stows config directories into `$HOME`

## Repository Layout

- `install`: primary bootstrap script
- `helpers.sh`: idempotent shell helpers used by `install`
- `git/`, `ghostty/`, `aerospace/`, `nvim/`, `starship/`, `mise/`: Stow packages that mirror paths under `$HOME`

When adding a new config, place it inside the appropriate package directory using its final home-relative path. Example: `ghostty/.config/ghostty/config`.

## Working Agreements

- Treat this as a personal dotfiles repo. Make focused changes and preserve the existing style unless the user asks for a broader cleanup.
- Do not run `./install` unless the user explicitly asks for machine-level changes to be applied.
- Keep bootstrap changes idempotent. Reuse `brew-install`, `brew-install-cask`, `brew-tap`, and `add-line-to-file` instead of open-coding repeated checks.
- Keep shell scripts compatible with the existing `bash` usage and preserve `set -euo pipefail`.
- Prefer editing the relevant Stow package instead of writing directly into `$HOME`.
- If you add a new top-level Stow package, also update `install` so it gets stowed.
- Avoid removing packages, taps, or shell init lines unless the user explicitly requests that behavior.

## Validation

Run lightweight validation after shell-script changes:

```bash
bash -n install helpers.sh
shellcheck install helpers.sh
```

If you change Stow-managed paths, sanity-check the tree shape and package names before applying anything to the home directory:

```bash
find git ghostty aerospace nvim starship mise -maxdepth 3 -type f | sort
```

Only run `stow` or `./install` when the user wants changes applied to the local machine, since both affect files outside the repo.

## Notes For Agents

- This repo currently has minimal documentation; prefer updating this file and `README.md` when behavior changes.
- `nvim/.config/nvim/lazy-lock.json` is generated state. Only update it when intentionally changing Neovim plugins.
- Assume macOS and Homebrew unless the user says otherwise.
