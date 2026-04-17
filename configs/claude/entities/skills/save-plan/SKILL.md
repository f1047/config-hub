---
name: save-plan
description: Copies the current plan to the project's `.claude/plans/` directory. Common triggers are "save plan", "save this plan", "copy plan to this project"
allowed-tools: [Read, Glob, Bash(cp *)]
---

Copy your current plan to the `.claude/plans/` directory by executing `cp`.

If no plan found, do not perform any file operations.

# Naming conventions

The name format should be lowercase, use hyphens instead of spaces, and avoid special characters.

If the user provides a name for the plan, save the plan with that name with appropriate formatting.
If not, generate a descriptive name based on the content of the plan.

The file should be named with a `YYYYMMDD-` prefix and a `.local.md` suffix, e.g. `20260219-toggle-headless-mode.local.md`.

# Duplicate handling

Avoid overwriting existing plans.
If a plan with the same name already exists, append a unique identifier to the filename, e.g. `20260219-toggle-headless-mode-1.local.md`.
