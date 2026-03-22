$projectRoot = (git rev-parse --show-toplevel).Trim()
. "$projectRoot/utils/header.ps1"

function link {
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
