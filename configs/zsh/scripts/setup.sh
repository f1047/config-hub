#!/usr/bin/env sh
set -eu

project_root="$(git rev-parse --show-toplevel)"

. "$project_root"/utils/link.sh

link_with_backup \
   "$project_root"/configs/zsh/entities \
   "$HOME"/.config/zsh \
   "zsh"
# .zshenv have to be linked separately since it sets up $ZDOTDIR
link_with_backup \
   "$project_root"/configs/zsh/entities/.zshenv \
   "$HOME"/.zshenv \
   "zshenv"
