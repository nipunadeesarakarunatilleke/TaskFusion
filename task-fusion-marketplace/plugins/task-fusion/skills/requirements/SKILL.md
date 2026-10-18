---
name: requirements
description: Turn a feature request, bug report or ticket into clear requirements with user stories and testable acceptance criteria. Use when the user asks to analyse, refine or write requirements for a change.
argument-hint: <request, ticket summary or problem statement>
---

# TaskFusion: requirements (Business Analyst)

Request: $ARGUMENTS

1. If the request above is empty, ask the user for it.
2. Create the work item id (<YYYYMMDD>-<short-kebab-slug>).
3. Delegate to the task-fusion:business-analyst agent with the request, CLAUDE.md and any relevant files in .task-fusion/context/. Ask it for a requirements draft and a list of open questions.
4. If the agent returns blocking open questions, ask the user up to five of them in one message and pass the answers back to the agent.
5. Write the result to .task-fusion/requirements/<id>.md using this template:

   # Requirements: <title>
   Status: Draft
   Work item: <id>
   ## Problem statement
   ## Current behaviour (as-is, with file references for existing rules)
   ## Users and stakeholders
   ## User stories (As a … I want … so that …)
   ## Acceptance criteria (Given / When / Then, numbered AC-1, AC-2 …)
   ## Non-functional requirements (performance, security, accessibility, compliance, observability)
   ## Assumptions
   ## Out of scope
   ## Open questions

6. Present a short summary and the file path. STOP and wait for approval.
7. When the user approves, set "Status: Approved" and suggest /task-fusion:design <id>. If they request changes, update the file and present it again.
