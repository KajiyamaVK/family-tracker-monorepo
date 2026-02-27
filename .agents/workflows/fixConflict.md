---
description: Attempts to automatically resolve any git merge conflicts by analyzing and fixing the conflicted files.
---

1. Execute `git diff --name-only --diff-filter=U` to get a list of all files with unresolved conflicts. If no files are listed, skip the remaining steps.
2. For each conflicted file, view its contents to understand the nature of the merge conflict and the surrounding code context.
3. Automatically determine the correct resolution based on the project's logic and the intent of both branches. Use file editing capabilities to remove the git conflict markers (`<<<<<<<`, `=======`, `>>>>>>>`) and apply the correct merged code.
4. After resolving all conflicts in all files, execute `git diff` to verify the resolutions are correct and that no conflict markers remain.
5. Execute `git add <resolved-files>` to stage the files.
6. If the conflict occurred during a rebase, execute `GIT_EDITOR=true git rebase --continue`. If it occurred during a merge, execute `git commit --no-edit` or another appropriate action to complete the resolution.
