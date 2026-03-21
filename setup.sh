#!/usr/bin/env sh
set -eu

project_root="$(git rev-parse --show-toplevel)"

. "$project_root"/utils/header.sh

# Platform-specific setup
if [ "$(uname)" = "Darwin" ]; then
   sh "$project_root"/configs/defaults/scripts/setup.sh
   sh "$project_root"/configs/brew/scripts/setup.sh
fi

sh "$project_root"/configs/claude/scripts/setup.sh
sh "$project_root"/configs/git/scripts/setup.sh
sh "$project_root"/configs/ssh/scripts/setup.sh

# Create symlinks with backup
# If the destination exists and is not a symlink, move it to backup directory before creating the symlink.
link_with_backup() {
   src="$1"
   dst="$2"
   bak="$3"
   if [ -e "$dst" ] && [ ! -L "$dst" ]; then
      mkdir -p "$bak"
      mv -vb "$dst" "$bak"
   fi
   ln -vsfn "$src" "$dst"
}

timestamp="$(date +%Y%m%dT%H%M%S)"
backup_dir="$project_root"/backup/"$timestamp"

# Link config entities
printf "$(header info) Linking config files...\n"
link_with_backup "$project_root"/configs/fish/entities       "$HOME"/.config/fish       "$backup_dir"/fish
link_with_backup "$project_root"/configs/ghostty/entities    "$HOME"/.config/ghostty    "$backup_dir"/ghostty
link_with_backup "$project_root"/configs/git/entities        "$HOME"/.config/git        "$backup_dir"/git
link_with_backup "$project_root"/configs/nvim/entities       "$HOME"/.config/nvim       "$backup_dir"/nvim
link_with_backup "$project_root"/configs/tmux/entities       "$HOME"/.config/tmux       "$backup_dir"/tmux
link_with_backup "$project_root"/configs/vim/entities        "$HOME"/.config/vim        "$backup_dir"/vim
link_with_backup "$project_root"/configs/zsh/entities        "$HOME"/.config/zsh        "$backup_dir"/zsh
## Link .zshenv individually to set $ZDOTDIR
link_with_backup "$project_root"/configs/zsh/entities/.zshenv "$HOME"/.zshenv "$backup_dir"/zshenv
link_with_backup "$project_root"/configs/claude/entities/skills/save-plan  "$HOME"/.claude/skills/save-plan  "$backup_dir"/claude-skills

if [ -d "$backup_dir" ]; then
   printf "$(header info) Backed up existing config files to $backup_dir\n"
fi
