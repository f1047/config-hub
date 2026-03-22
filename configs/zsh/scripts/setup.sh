#!/usr/bin/env sh
set -eu

project_root="$(git rev-parse --show-toplevel)"

. "$project_root"/utils/link.sh

link \
   "$project_root"/configs/zsh/entities \
   "$HOME"/.config/zsh \
   "zsh"
# .zshenv needs to be linked separately since it sets up $ZDOTDIR
link \
   "$project_root"/configs/zsh/entities/.zshenv \
   "$HOME"/.zshenv \
   "zshenv"
