---
name: status
description: Show TaskFusion work items with their stage, approval status and next command, plus any out-of-date context documents. Use when the user asks what is in progress, where a change is up to, or whether the project context is current.
argument-hint: [work item id]
---

# TaskFusion: status

Work item: $ARGUMENTS

1. Read .task-fusion/index.md. If it does not exist, build the list from the artifact files in .task-fusion/requirements/, designs/, plans/ and reports/, and offer to create the index.
2. Check the index against the files on disk: each work item's latest artifact and its "Status:" line. Report any mismatch and offer to correct the index. Only change it if the user agrees.
3. For each active work item (stage not Done), or only the one named above, show: id, title, stage, status, branch, what it is waiting for (an approval, open review findings or a NOT READY verdict) and the next command to run.
4. If .task-fusion/context/ exists, check its freshness. For each modules/<module>.md, run git log --oneline <its Commit>..HEAD -- <its Paths> and report how many commits have changed those paths since the file was written. For the other context files, report how many commits the repository has had since their Commit. Mark a module file "Possibly stale" when its paths have changed, and suggest /task-fusion:discover <module> to refresh it.
5. If .task-fusion/context/decisions.md exists, list its five most recent entries.

Keep the output short: one table of work items, then any warnings. This skill only reads, apart from index corrections the user approves.
