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
| `configs/<program>/entities/` | Symlink targets — the directory itself gets symlinked to `~/.config/<program>` |
| `configs/<program>/scripts/` | Setup scripts, templates, and Brewfiles called during installation |
| `utils/` | Contains pure utility scripts |

Programs with only config files (fish, ghostty, nvim, tmux, vim, zsh) have an `entities/` subdirectory.
Programs with setup logic (brew, defaults, git, ssh) have a `scripts/` subdirectory (and optionally `entities/`).
