#!/usr/bin/env sh
set -eu

# Common header functions for setup scripts
# Usage: header <type>
header() {
   h="[$(echo "$1" | tr '[:lower:]' '[:upper:]')]"
   printf '%-9s' "$h"
}
