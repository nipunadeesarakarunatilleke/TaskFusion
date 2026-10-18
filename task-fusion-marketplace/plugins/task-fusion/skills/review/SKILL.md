---
name: review
description: Run an independent, read-only code review of the current changes against the plan, design and requirements. Use before committing, before opening a pull request, or when asked to review code.
argument-hint: [work item id or base branch]
---

# TaskFusion: review (Tech Lead)

Input: $ARGUMENTS

1. Determine the base branch: a branch name given above, otherwise the repository default branch (main or master).
2. Collect the change set: committed changes since the base plus staged and uncommitted changes.
3. Delegate to the task-fusion:tech-lead agent in review mode with the change set, the matching plan, design and requirements if they exist, CLAUDE.md and .task-fusion/context/constraints.md if it exists.
4. Present findings grouped as Critical, Major, Minor and Nit, each with file, line, issue and suggested fix.
5. Do not fix anything automatically. Ask the user which findings to address; hand approved fixes to the task-fusion:developer agent.
6. Save the review to .task-fusion/reports/<id>-review.md (use the date and branch name as the id when there is no work item).
