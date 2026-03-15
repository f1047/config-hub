#!/usr/bin/env sh
set -eu

project_root="$(git rev-parse --show-toplevel)"
this_dir="$(cd "$(dirname "$0")"; pwd)"

. "$project_root"/utils/header.sh

# Apply macOS defaults
sh "$this_dir"/defaults.sh

# Resolve the correct Homebrew binary
# sysctl hw.optional.arm64 returns 1 on Apple Silicon even under Rosetta 2
if [ "$(sysctl -n hw.optional.arm64 2>/dev/null)" = "1" ]; then
   brew_bin="/opt/homebrew/bin/brew"   # Apple Silicon native path
else
   brew_bin="brew"
fi

# Install Homebrew packages
if [ -x "$brew_bin" ]; then
   printf "$(header info) Installing Homebrew ($brew_bin) packages from Brewfile...\n"
   "$brew_bin" bundle --file="$this_dir"/Brewfile
else
   printf "$(header info) Homebrew not found at $brew_bin. Install from https://brew.sh and re-run setup.\n"
fi
