#!/usr/bin/env sh
set -eu

project_root="$(git rev-parse --show-toplevel)"
this_dir="$(cd "$(dirname "$0")"; pwd)"

. "$project_root"/utils/header.sh

# Create ssh config if not exists
if [ -d "$HOME" ] && [ ! -d "$HOME"/.ssh ]; then
   mkdir -m 700 "$HOME"/.ssh
fi
if [ ! -f "$HOME"/.ssh/config ]; then
   cp "$this_dir"/config "$HOME"/.ssh/config
   printf "$(header info) Created ~/.ssh/config from template\n"
fi
