---
name: plan
description: Break an approved design into an ordered, file-level implementation plan with a test plan. Use when the user asks to plan, scope or estimate the implementation of a change.
argument-hint: <work item id, design path, or a small task description>
---

# TaskFusion: plan (Tech Lead)

Input: $ARGUMENTS

1. Load the approved design and requirements for the work item (the argument above; otherwise the only active work item in .task-fusion/index.md; if there are several, ask which one). For a small change with no design, accept a task description, create a work item id, add its row to .task-fusion/index.md, and plan directly from it.
2. Delegate to the task-fusion:tech-lead agent in planning mode with the requirements, design, CLAUDE.md and the relevant files in .task-fusion/context/.
3. Write the result to .task-fusion/plans/<id>.md using this template:

   # Plan: <title>
   Status: Draft
   Work item: <id>
   ## Summary
   ## Tasks (ordered; for each: files to change, what changes, which AC it serves)
   ## Characterisation tests (existing behaviour to pin down before changing it; write "Not needed" and the reason if the changed code is already well tested)
   ## Test plan (unit, integration and any manual checks, mapped to AC numbers)
   ## Constraints (runtime versions and environment limits that apply)
   ## Definition of done
   ## Risks and edge cases
   ## Out of scope

4. Present a short summary and the file path. STOP and wait for approval. Do not edit source files in this stage.
5. When the user approves, set "Status: Approved", update the index row (stage Plan, status Approved) and suggest /task-fusion:implement <id>.
