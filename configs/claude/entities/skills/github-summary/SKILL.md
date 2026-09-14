---
name: github-summary
description: Wrap content in the "Created by Claude Code" collapsible <details> block for GitHub PR/issue descriptions and comments. Common triggers are "github summary", "pack this as a github summary", "wrap this for a PR/issue".
allowed-tools: [Read, Write, Edit]
---

Pack the given content into this exact Markdown template:

```markdown
<details><summary>Claude Code summary</summary>

BODY

</details>
```

# Steps

1. **Collect the source.** Take the content from the user's request, from a file/region they point at, or from what you most recently produced this turn.
2. **Condense it into a minimal description.** Keep only what a reader of the PR/issue needs: the outcome, the reasoning behind it, and any commands/paths/logs needed to act on it. Drop conversational framing — greetings, offers of next steps, questions to the user, and restatements of what was asked. Reuse the source's own wording and Markdown structure; this is a trim, not a rewrite. Skip this step if the user asks for the content verbatim.
3. **Pack it into the template.**
    - `BODY` is the condensed content from step 2.

# Rules

- Output the template verbatim —the exact `<details><summary>…</summary>` tags, and the blank lines around the body. The blank line after `<summary>` and before `</details>` is required for GitHub to render the body as Markdown.
- Do not add commentary, headers, or trailing text outside the block.
- Emit the result as a fenced code block so it can be copied verbatim, unless the user asks to write it into a file (then use Write/Edit).
- No hard wrapping in `BODY`: one line per paragraph or list item, however long. GitHub reflows it, and wrapped lines are painful to edit later. Keep a single sentence short, though — prefer the shorter wording when it says the same thing.
- If the body already contains a `<details>` block, keep it — GitHub renders nested details fine.
