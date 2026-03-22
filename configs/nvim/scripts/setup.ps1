#!/usr/bin/env pwsh
$ErrorActionPreference = 'Stop'

$projectRoot = (git rev-parse --show-toplevel).Trim()

. "$projectRoot/utils/link.ps1"

link `
   (Join-Path $projectRoot "configs\nvim\entities") `
   (Join-Path $env:XDG_CONFIG_HOME "nvim") `
   "nvim"
