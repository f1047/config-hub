#!/usr/bin/env pwsh
$ErrorActionPreference = 'Stop'

$projectRoot = (git rev-parse --show-toplevel).Trim()

. "$projectRoot/utils/header.ps1"

# Shared backup directory with consistent timestamp across all program scripts
$timestamp = Get-Date -Format "yyyyMMddTHHmmss"
$env:CONFIGHUB_BACKUP_DIR = Join-Path (Join-Path $projectRoot "backup") $timestamp

# Set XDG_CONFIG_HOME to ~/.config if not already set, then persist it as a user env var
if (-not $env:XDG_CONFIG_HOME) {
   $env:XDG_CONFIG_HOME = Join-Path $HOME ".config"
   [Environment]::SetEnvironmentVariable('XDG_CONFIG_HOME', $env:XDG_CONFIG_HOME, 'User')
   Write-Host "$(header 'info') Set XDG_CONFIG_HOME to $env:XDG_CONFIG_HOME"
}

& "$projectRoot/configs/claude/scripts/setup.ps1"
& "$projectRoot/configs/git/scripts/setup.ps1"
& "$projectRoot/configs/nvim/scripts/setup.ps1"

if (Test-Path $env:CONFIGHUB_BACKUP_DIR) {
   Write-Host "$(header 'info') Backed up existing config files to $env:CONFIGHUB_BACKUP_DIR"
}
