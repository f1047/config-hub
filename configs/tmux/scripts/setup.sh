#!/usr/bin/env sh
set -eu

project_root="$(git rev-parse --show-toplevel)"

. "$project_root"/utils/link.sh

link_with_backup \
   "$project_root"/configs/tmux/entities \
   "$HOME"/.config/tmux \
   "tmux"
