# config-hub

A dotfiles repository that manages my personal configuration files.

## Usage

Run `setup.sh`.

```sh
./setup.sh
```

## Structure

| Directory | Description |
| --- | --- |
| `configs/<program>/entities/` | Symlink targets linked to `~/.config/<program>` |
| `configs/<program>/scripts/` | Setup scripts, templates, etc. |
| `utils/` | Shared utility scripts |
