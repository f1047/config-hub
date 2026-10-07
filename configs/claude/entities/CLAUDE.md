# Guidelines

## Sentence length

- Make code comments or document sentences as short as possible
- For comments, avoid what is obvious or what code says. Focus on non-obvious why and why not
- For documents, follow `/i-have-adhd` skill guide
    - If it is unavailable, nudge a user

## Code change granurality

- Above-200-line changes are regarded as large
- If the changes are large, consider splitting into multiple branches or PRs
    - Boundary is categories (fix, refactor, feat) or targets. Weight its meaning rather than file types or components
    - Add TODO comments to defects in current branch to clarify that they will addressed in later branches/PRs
- Avoid big-bang changes: limit scope as much as possible to avoid regression risks

