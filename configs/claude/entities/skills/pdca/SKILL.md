---
name: pdca
description: Track PDCA (Plan-Do-Check-Act) progress by appending findings, progress, and next actions to the current plan file. Common triggers are "pdca", "update plan progress", "check plan", "plan review"
allowed-tools: [Read, Glob, Edit]
---

Append a PDCA tracking section to the current plan file.

If no plan is found, inform the user and do not perform any file operations.

# Workflow

1. Find and read the current plan file.
2. Review the plan's goals and tasks.
3. Ask the user what phase to record (Do, Check, or Act), or infer from context.
4. Append the appropriate PDCA section to the end of the plan file using the Edit tool.

# PDCA section format

Append a new section using the following structure. Use the current date as the heading.

```markdown
## PDCA - YYYY-MM-DD

### Do (Progress)
- What was done since the last update

### Check (Findings)
- What was learned, observed, or discovered
- Any blockers or unexpected results

### Act (Next Actions)
- Concrete next steps based on findings
- Adjustments to the plan if needed
```

# Rules

- Always read the plan file before editing.
- Each PDCA entry should be appended at the end of the file, never overwrite existing content.
- If there are prior PDCA entries, append below them.
- Keep entries concise and actionable.
- Use information from the current conversation context (completed tasks, errors encountered, decisions made) to populate the sections.
- If the user provides specific notes, incorporate them verbatim.
