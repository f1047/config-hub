#!/usr/bin/env sh
set -eu

project_root="$(git rev-parse --show-toplevel)"

. "$project_root"/utils/link.sh

link \
   "$project_root"/configs/ghostty/entities \
   "$HOME"/.config/ghostty \
   "ghostty"
