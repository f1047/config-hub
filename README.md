# config-hub

A dotfiles repository that manages my personal configuration files.

## Usage

### macOS / Linux

```sh
./setup.sh
```

### Windows

Symlinks require either **Developer Mode** enabled or running as **Administrator**.

```powershell
.\setup.ps1
```

> `setup.ps1` currently sets up: claude, git, nvim.

## Structure

| Path | Description |
| --- | --- |
| `configs/<program>/entities/` | Symlink targets linked to `~/.config/<program>` |
| `configs/<program>/scripts/` | Setup scripts, templates, etc. |
| `utils/` | Shared utility scripts (header, link helpers) |
| `backup/<timestamp>/` | Automatic backups of pre-existing configs |
