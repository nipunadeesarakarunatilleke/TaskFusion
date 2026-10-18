---
name: verify
description: Final verification gate confirming a change meets its acceptance criteria, builds, passes tests and has no open critical review findings. Use before marking a task done or opening a pull request.
argument-hint: [work item id]
---

# TaskFusion: verify (Tech Lead)

Work item: $ARGUMENTS

1. Load the requirements, plan and latest review report for the work item.
2. Delegate to the task-fusion:tech-lead agent in verification mode.
3. Produce a checklist with PASS, FAIL or N/A and evidence for each item:
   - Every acceptance criterion (AC-n) is met and covered by a test or a documented manual check
   - Characterisation tests from the plan exist and pass
   - Build succeeds
   - Full relevant test suite passes
   - Lint passes (if a lint command exists)
   - No open Critical or Major review findings
   - No debug code, newly added TODOs or secrets in the diff
   - Nothing listed as out of scope was changed
   - No unrelated reformatting or whitespace-only changes in the diff
4. When a check cannot run locally (CLAUDE.md or .task-fusion/context/constraints.md says so), mark it PASS only with evidence from a CI run or a documented manual check, and name the source. Without evidence, mark it FAIL.
5. Write the result to .task-fusion/reports/<id>-verify.md.
6. Verdict: READY only if every item is PASS or N/A; otherwise NOT READY with the items to fix.
