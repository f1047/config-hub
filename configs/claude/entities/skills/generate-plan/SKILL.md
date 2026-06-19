---
name: generate-plan
description: Research the current task, write an implementation plan, then invoke the save-plan skill to store it in the project's `.claude/plans/` directory. Common triggers are "generate a plan", "create a plan and save it", "plan this out"
allowed-tools: [Read, Glob, Grep, Bash, Write, Skill]
---

Generate an implementation plan for the task at hand, then save it to the project via the save-plan skill.

# Workflow

1. Research the relevant code first: read the files involved and trace the code paths. Never plan from guesses.
2. Check the project's `.claude/plans/` for recent plans and match their content format. If none exist, use the default structure below.
3. Write the plan to the current plan file if one exists (e.g. plan mode); otherwise write it to a temporary file such as `/tmp/claude-plans/<slug>.md`.
4. Invoke the `save-plan` skill, telling it the plan file's path and the user's plan name if one was given. It owns file naming and duplicate handling.

# Default plan structure

```markdown
# <Title — imperative, specific>

## Context
Why this change is being made: the problem or need, what prompted it, the intended outcome.
Link related issues/PRs/investigations. Summarize rejected alternatives in one line each, if relevant.

## Scope
Files/components affected. Call out what is intentionally NOT touched.

## Changes
Numbered, concrete steps with `path:line` references.
Reuse existing functions and utilities found during research — name them.

## Verification
How to confirm the change works end-to-end: commands to run, logs/metrics to check, expected values.

## Out of scope / follow-ups
Deferred items, with enough context that they can become their own plan later.
```

# Rules

- Every file or function the plan names must have been confirmed to exist during research.
- Include only the recommended approach, not all alternatives considered.
- If the plan implements an item tracked under the project's `.claude/notes/`, include a step to update that note.
- Keep the plan concise enough to scan quickly, detailed enough to execute without re-research.
