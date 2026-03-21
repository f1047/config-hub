#!/usr/bin/env sh
set -eu

project_root="$(git rev-parse --show-toplevel)"

. "$project_root"/utils/header.sh

# Create git local config if not exists
git_local_config="$HOME"/.local/share/git/config
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
