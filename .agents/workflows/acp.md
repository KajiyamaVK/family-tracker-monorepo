---
description: Automatically commits and pushes all changes with an AI-generated concise commit message.
---

// turbo

1. Execute `git add .` to stage all changes.
2. Execute `git diff --staged` to review the staged changes and generate a concise, descriptive commit message. The commit message must follow this format: First line brief summary (50 chars or less), blank line, and bullet points describing key changes if there are multiple changes.
// turbo
3. Execute `git commit -m "<Generated Message>"` substituting the generated message.
// turbo
4. Execute `git push` to push the changes to the remote repository.
