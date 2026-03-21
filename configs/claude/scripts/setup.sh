#!/usr/bin/env sh
set -eu

project_root="$(git rev-parse --show-toplevel)"
this_dir="$(cd "$(dirname "$0")"; pwd)"

. "$project_root"/utils/header.sh

# Update settings.json with statusLine config
settings_file="$HOME"/.claude/settings.json
if [ ! -f "$settings_file" ]; then
   mkdir -p "$HOME"/.claude
   echo '{}' > "$settings_file"
fi
statusline_cmd="$this_dir/statusline.py"
tmp="$(mktemp)"
if jq --arg cmd "$statusline_cmd" '.statusLine = {"type": "command", "command": $cmd}' "$settings_file" > "$tmp" && jq empty "$tmp" 2>/dev/null; then
   mv "$tmp" "$settings_file"
   printf "$(header info) Configured statusLine in ~/.claude/settings.json\n"
else
   rm -f "$tmp"
   printf "$(header error) Failed to update ~/.claude/settings.json\n" >&2
   exit 1
fi
