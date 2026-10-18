---
name: flow
description: Run the full TaskFusion SDLC for a work item, from requirements through design, plan, implement, review and verify, with approval gates.
argument-hint: <request or ticket summary>
disable-model-invocation: true
---

# TaskFusion: end-to-end flow

Request: $ARGUMENTS

Keep a task list with one item per stage. Follow each stage's own skill instructions.

0. Context. If .task-fusion/context/ does not exist and the repository is large, old or poorly documented, suggest running /task-fusion:discover first and ask the user.
1. Triage. Ask the tech-lead agent to classify the request as Small (a contained fix or tweak) or Standard. For Small, propose skipping Requirements and Design and ask the user to confirm.
2. Requirements — /task-fusion:requirements. GATE: wait for approval.
3. Design — /task-fusion:design. GATE: wait for approval.
4. Plan — /task-fusion:plan. GATE: wait for approval.
5. Implement — /task-fusion:implement.
6. Review — /task-fusion:review. GATE: if there are Critical or Major findings, ask which to fix, have the developer fix them, then review once more.
7. Verify — /task-fusion:verify.

Finish with a short summary: work item id, artifact paths, files changed, test results, review outcome, verification verdict and a suggested conventional-commit message. Do not commit.
