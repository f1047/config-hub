#!/usr/bin/env sh
set -eu

project_root="$(git rev-parse --show-toplevel)"

. "$project_root"/utils/link.sh

# File, not directory: ~/.config/mise also holds machine-specific config.local.toml.
link \
   "$project_root"/configs/mise/entities/config.toml \
   "$HOME"/.config/mise/config.toml \
   "mise"
