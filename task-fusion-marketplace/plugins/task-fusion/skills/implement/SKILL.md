---
name: implement
description: Implement an approved TaskFusion plan, including its tests, step by step while keeping scope tight.
argument-hint: <work item id or plan path>
disable-model-invocation: true
---

# TaskFusion: implement (Developer)

Work item: $ARGUMENTS

1. Load the plan for the work item (the argument above; otherwise the only active work item in .task-fusion/index.md; if there are several, ask which one). Set its index row to stage Implement, status In progress. If it is not approved, show its summary and ask the user to approve it before editing anything.
2. Delegate to the task-fusion:developer agent with the plan, the design, the requirements and CLAUDE.md. Ask it to write any characterisation tests from the plan first, then work task by task, writing or updating tests for each task, and to run the relevant build and tests after each one.
3. If the developer reports work that is not covered by the plan, record it under a new "## Implementation notes" section in the plan and ask the user before acting on it.
4. Do not commit, push or modify CI/CD configuration unless the user explicitly asks.
5. Report: files changed, tests added, checks run and their results, deviations from the plan. Set the index row status to Complete and suggest /task-fusion:review <id>.
