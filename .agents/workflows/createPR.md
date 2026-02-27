---
description: Gets all diffs and creates a Pull Request to merge the current branch into dev.
---

1. Execute `git diff --name-only --diff-filter=U` to check for any unresolved git conflicts. If conflicts are found, execute the `fixConflict` workflow automatically.
2. Execute `git diff dev...HEAD` to understand all changes in the current branch compared to `dev`, and generate a concise PR title and descriptive body.
// turbo
3. Ensure the remote branch is up to date by running `git push -u origin HEAD`.
// turbo
4. Run `gh pr create --base dev --title "<Generated Title>" --body "<Generated Body>"` to create the PR, substituting the title and body you generated.
5. Display the URL of the created PR to the user.
