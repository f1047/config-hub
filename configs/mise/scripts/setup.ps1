#!/usr/bin/env pwsh
$ErrorActionPreference = 'Stop'

$projectRoot = (git rev-parse --show-toplevel).Trim()

. "$projectRoot/utils/link.ps1"

# File, not directory: the mise dir also holds machine-specific config.local.toml.
link `
   (Join-Path $projectRoot "configs\mise\entities\config.toml") `
   (Join-Path $env:XDG_CONFIG_HOME "mise\config.toml") `
   "mise"
