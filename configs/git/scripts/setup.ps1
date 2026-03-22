#!/usr/bin/env pwsh
$ErrorActionPreference = 'Stop'

$projectRoot = (git rev-parse --show-toplevel).Trim()
$thisDir = Split-Path $MyInvocation.MyCommand.Path -Parent

. "$projectRoot/utils/header.ps1"

# Create git local config if not exists
$gitLocalConfig = Join-Path $HOME ".local\share\git\config"
if (-not (Test-Path $gitLocalConfig)) {
   New-Item -ItemType Directory -Path (Split-Path $gitLocalConfig -Parent) -Force | Out-Null
   Write-Host "$(header 'info') Configure git local config"
   $name = Read-Host "$(header 'prompt') Enter your user.name"
   $email = Read-Host "$(header 'prompt') Enter your user.email"
   $template = Get-Content (Join-Path $thisDir "local.config.template") -Raw
   $content = $template -replace '\{\{NAME\}\}', $name -replace '\{\{EMAIL\}\}', $email
   Set-Content -Path $gitLocalConfig -Value $content
   Write-Host "$(header 'info') Configured git local config:"
   Get-Content $gitLocalConfig
}

. "$projectRoot/utils/link.ps1"

link `
   (Join-Path $projectRoot "configs\git\entities") `
   (Join-Path $env:XDG_CONFIG_HOME "git") `
   "git"
