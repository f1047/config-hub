#!/usr/bin/env sh
# utils/link.sh - Symlink helper with backup support
# Requires: CONFIGHUB_BACKUP_DIR environment variable exported by root setup.sh

project_root="$(git rev-parse --show-toplevel)"
. "$project_root"/utils/header.sh

link_with_backup() {
   src="$1"
   dst="$2"
   bak="$CONFIGHUB_BACKUP_DIR/$3"
   if [ -e "$dst" ] && [ ! -L "$dst" ]; then
      mkdir -p "$bak"
      printf "$(header info) Backing up: $dst -> $bak\n"
      mv "$dst" "$bak"
   fi
   printf "$(header info) Linking: $src -> $dst\n"
   ln -sfn "$src" "$dst"
}
