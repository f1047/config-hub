#!/usr/bin/env sh
set -eu

project_root="$(git rev-parse --show-toplevel)"

. "$project_root"/utils/header.sh

# Shared backup directory with consistent timestamp across all program scripts
timestamp="$(date +%Y%m%dT%H%M%S)"
export CONFIGHUB_BACKUP_DIR="$project_root"/backup/"$timestamp"

# Platform-specific setup
if [ "$(uname)" = "Darwin" ]; then
   sh "$project_root"/configs/defaults/scripts/setup.sh
   sh "$project_root"/configs/brew/scripts/setup.sh
fi

sh "$project_root"/configs/claude/scripts/setup.sh
sh "$project_root"/configs/fish/scripts/setup.sh
sh "$project_root"/configs/ghostty/scripts/setup.sh
sh "$project_root"/configs/git/scripts/setup.sh
sh "$project_root"/configs/nvim/scripts/setup.sh
sh "$project_root"/configs/ssh/scripts/setup.sh
sh "$project_root"/configs/tmux/scripts/setup.sh
sh "$project_root"/configs/vim/scripts/setup.sh
sh "$project_root"/configs/zsh/scripts/setup.sh

if [ -d "$CONFIGHUB_BACKUP_DIR" ]; then
   printf "$(header info) Backed up existing config files to $CONFIGHUB_BACKUP_DIR\n"
fi
