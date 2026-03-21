---
name: save-plan
description: Copies the current plan to the project's `.claude/plans/` directory. Common triggers are "save plan", "save this plan", "copy plan to this project"
allowed-tools: Read, Glob, Write
---

Copy your current plan in the plan mode to the `.claude/plans/` directory.

If you are not in plan mode, respond with "You are not in plan mode. Please switch to plan mode to save your plan." and do not perform any file operations.

# Instructions

The name format should be lowercase, use hyphens instead of spaces, and avoid special characters.
If the user provides a name for the plan, save the plan with that name with appropriate formatting.
If not, generate a descriptive name based on the content of the plan.

The file should be named with a `YYYYMMDD-` prefix and a `.local.md` suffix, e.g. `20260219-toggle-headless-mode.local.md`.

# Duplicate handling

Avoid overwriting existing plans.
If a plan with the same name already exists, append a unique identifier to the filename, e.g. `20260219-toggle-headless-mode-1.local.md`.
