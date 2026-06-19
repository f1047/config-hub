---
name: shorten
description: Rewrite descriptions or comments to be concise and brief without losing meaning. Common triggers are "shorten", "make this shorter", "trim the comments", "too long/verbose".
allowed-tools: [Read, Edit]
---

Rewrite the target text (code comments, docstrings, or descriptions) to be shorter while keeping its meaning.

# Target

- If the user points at specific text, a file, or a region, shorten that.
- Otherwise, shorten the comments/descriptions you most recently wrote or edited.

# Rules

- Keep the original meaning and any non-obvious "why"; drop restated code, obvious context, and filler.
- Prefer one line. Only keep multiple lines when each carries distinct information.
- Match the surrounding comment style and language (e.g. jsdoc, `#`, `//`).
- Edit only comments/descriptions. Do not change code, logic, or identifiers.
- If something is already concise, leave it and say so.
