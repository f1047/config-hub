#!/usr/bin/env sh
set -eu

project_root="$(git rev-parse --show-toplevel)"

. "$project_root"/utils/header.sh

# Platform-specific setup
if [ "$(uname)" = "Darwin" ]; then
   sh -c "$project_root"/platforms/macos/setup.sh
fi

# Create git local config if not exists
git_local_config="$project_root"/configs/git/local/config
if [ ! -e "$git_local_config" ]; then
   mkdir -p "$(dirname "$git_local_config")"
   printf "$(header info) Configure git local config"
   printf "$(header prompt) Enter your user.name: "
   read _name
   printf "$(header prompt) Enter your user.email: "
   read _email
   echo """[user]
   name = $_name
   email = $_email""" >> "$git_local_config"
   printf "$(header info) Configured git local config:\n"
   cat "$git_local_config"
fi

# Create ssh config if not exists
if [ -d "$HOME" -a ! -d "$HOME"/.ssh ]; then
   mkdir -m 700 "$HOME"/.ssh
fi
if [ ! -f "$HOME"/.ssh/config ]; then
   cp "$project_root"/templates/ssh/config "$HOME"/.ssh/config
fi

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
link_with_backup "$project_root"/configs/fish       "$HOME"/.config/fish       "$backup_dir"/fish
link_with_backup "$project_root"/configs/ghostty    "$HOME"/.config/ghostty    "$backup_dir"/ghostty
link_with_backup "$project_root"/configs/git        "$HOME"/.config/git        "$backup_dir"/git
link_with_backup "$project_root"/configs/nvim       "$HOME"/.config/nvim       "$backup_dir"/nvim
link_with_backup "$project_root"/configs/tmux       "$HOME"/.config/tmux       "$backup_dir"/tmux
link_with_backup "$project_root"/configs/vim        "$HOME"/.config/vim        "$backup_dir"/vim
link_with_backup "$project_root"/configs/zsh        "$HOME"/.config/zsh        "$backup_dir"/zsh
## Link .zshenv individually to set $ZDOTDIR
link_with_backup "$project_root"/configs/zsh/.zshenv "$HOME"/.zshenv "$backup_dir"/zshenv
if [ -d "$backup_dir" ]; then
   printf "$(header info) Backed up existing config files to $backup_dir\n"
fi
