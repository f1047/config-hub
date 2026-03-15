# config-hub

A dotfiles repository that manages my personal configuration files.

## Usage

Run `setup.sh`.

```sh
./setup.sh
```

This will:
- Set up platform-specific settings and tools (e.g. Homebrew on macOS)
- (first time only) Prompt for git `user.name` and `user.email` to create a local git config
- (first time only) Create `~/.ssh/config` from the template
- Create symlinks from `~/.config/<tool>` to each config directory in this repo (backing up any existing configs)

Run `setup.sh` again to update the symlinks after making changes to the configs in this repo.

## Structure

| Directory | Description |
| --- | --- |
| `configs/` | Contains configuration files for various tools, expected to be symlinked to an appropriate location in the user's home directory |
| `platforms/` | Contains platform-specific configuration files or scripts |
| `templates/` | Contains template files for configurations that require user-specific information |
| `utils/` | Contains pure utility scripts |
