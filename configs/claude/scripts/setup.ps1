#!/usr/bin/env pwsh
$ErrorActionPreference = 'Stop'

$projectRoot = (git rev-parse --show-toplevel).Trim()

. "$projectRoot/utils/header.ps1"

# Update settings.json with statusLine config
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

. "$projectRoot/utils/link.ps1"

link `
   (Join-Path $projectRoot "configs\claude\entities\skills\save-plan") `
   (Join-Path $HOME ".claude\skills\save-plan") `
   "claude-skills"
