#!/usr/bin/env pwsh
$ErrorActionPreference = 'Stop'

$projectRoot = (git rev-parse --show-toplevel).Trim()

function header {
   param([string]$type)
   $h = "[" + $type.ToUpper() + "]"
   return $h.PadRight(9)
}

# Shared backup directory with consistent timestamp across all program scripts
$timestamp = Get-Date -Format "yyyyMMddTHHmmss"
$env:CONFIGHUB_BACKUP_DIR = Join-Path (Join-Path $projectRoot "backup") $timestamp

function link_with_backup {
   param([string]$src, [string]$dst, [string]$bak_name)
   $bak = Join-Path $env:CONFIGHUB_BACKUP_DIR $bak_name
   $item = Get-Item -Path $dst -ErrorAction SilentlyContinue
   if ($item -and -not $item.LinkType) {
      New-Item -ItemType Directory -Path $bak -Force | Out-Null
      Write-Host "$(header 'info') Backing up: $dst -> $bak"
      Move-Item -Path $dst -Destination $bak
   }
   $parent = Split-Path $dst -Parent
   if ($parent -and -not (Test-Path $parent)) {
      New-Item -ItemType Directory -Path $parent -Force | Out-Null
   }
   Write-Host "$(header 'info') Linking: $src -> $dst"
   New-Item -ItemType SymbolicLink -Path $dst -Target $src -Force | Out-Null
}

# --- claude ---
$claudeDir = Join-Path $HOME ".claude"
$settingsFile = Join-Path $claudeDir "settings.json"
if (-not (Test-Path $settingsFile)) {
   New-Item -ItemType Directory -Path $claudeDir -Force | Out-Null
   Set-Content -Path $settingsFile -Value '{}'
}
# Note: avoid Join-Path here as it converts '/' to '\', breaking the forward-slash requirement
$statuslineCmd = "python $projectRoot/configs/claude/scripts/statusline.py"
$settings = Get-Content $settingsFile -Raw | ConvertFrom-Json
$settings | Add-Member -MemberType NoteProperty -Name 'statusLine' -Value @{
   type    = 'command'
   command = $statuslineCmd
} -Force
$settings | ConvertTo-Json -Depth 10 | Set-Content $settingsFile
Write-Host "$(header 'info') Configured statusLine in ~/.claude/settings.json"

link_with_backup `
   (Join-Path $projectRoot "configs\claude\entities\skills\save-plan") `
   (Join-Path $HOME ".claude\skills\save-plan") `
   "claude-skills"

# Set XDG_CONFIG_HOME to ~/.config if not already set, then persist it as a user env var
if (-not $env:XDG_CONFIG_HOME) {
   $env:XDG_CONFIG_HOME = Join-Path $HOME ".config"
   [Environment]::SetEnvironmentVariable('XDG_CONFIG_HOME', $env:XDG_CONFIG_HOME, 'User')
   Write-Host "$(header 'info') Set XDG_CONFIG_HOME to $env:XDG_CONFIG_HOME"
}
$configHome = $env:XDG_CONFIG_HOME

# --- git ---
$gitLocalConfig = Join-Path $HOME ".local\share\git\config"
if (-not (Test-Path $gitLocalConfig)) {
   New-Item -ItemType Directory -Path (Split-Path $gitLocalConfig -Parent) -Force | Out-Null
   Write-Host "$(header 'info') Configure git local config"
   $name = Read-Host "$(header 'prompt') Enter your user.name"
   $email = Read-Host "$(header 'prompt') Enter your user.email"
   $template = Get-Content (Join-Path $projectRoot "configs\git\scripts\local.config.template") -Raw
   $content = $template -replace '\{\{NAME\}\}', $name -replace '\{\{EMAIL\}\}', $email
   Set-Content -Path $gitLocalConfig -Value $content
   Write-Host "$(header 'info') Configured git local config:"
   Get-Content $gitLocalConfig
}

link_with_backup `
   (Join-Path $projectRoot "configs\git\entities") `
   (Join-Path $configHome "git") `
   "git"

# --- nvim ---
link_with_backup `
   (Join-Path $projectRoot "configs\nvim\entities") `
   (Join-Path $configHome "nvim") `
   "nvim"

if (Test-Path $env:CONFIGHUB_BACKUP_DIR) {
   Write-Host "$(header 'info') Backed up existing config files to $env:CONFIGHUB_BACKUP_DIR"
}
