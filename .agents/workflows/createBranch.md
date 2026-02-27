---
description: Infers a relevant branch name from uncommitted changes and switches to it.
---

1. Execute `git diff` to view uncommitted changes, and `git diff --staged` if there are any staged changes, to understand the context of the work.
2. Generate a concise, descriptive branch name in kebab-case based on the diff context (e.g., `feat/add-login-form`, `fix/header-alignment`, `chore/update-deps`).
// turbo
3. Execute `git checkout -b <generated-branch-name>` to create and switch to the new inferred branch.
