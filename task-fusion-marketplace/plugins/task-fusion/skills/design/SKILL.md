---
name: design
description: Produce a solution design from approved requirements, covering components, data, interfaces, key decisions and risks. Use when the user asks for a technical design, architecture or approach for a change.
argument-hint: <work item id or requirements file path>
---

# TaskFusion: design (Architect)

Work item: $ARGUMENTS

1. Load the requirements for the work item (the argument above, or the most recent file in .task-fusion/requirements/). If it is not approved, ask the user to approve it first or confirm they want to continue.
2. Delegate to the task-fusion:architect agent with the requirements, CLAUDE.md and the relevant files in .task-fusion/context/ (especially constraints.md and hotspots.md).
3. Write the result to .task-fusion/designs/<id>.md using this template:

   # Design: <title>
   Status: Draft
   Work item: <id>
   ## Context and current architecture
   ## Proposed solution (overview)
   ## Components and responsibilities
   ## Data model changes
   ## Interfaces and contracts (APIs, events, messages)
   ## Key decisions (option chosen, alternatives considered, trade-offs)
   ## Security and privacy considerations
   ## Performance, scalability and reliability
   ## Migration, rollout and rollback
   ## Risks and mitigations
   ## Traceability (which design element satisfies which AC)

4. Include a simple Mermaid diagram when it makes the structure or flow clearer.
5. Present a short summary and the file path. STOP and wait for approval.
6. When the user approves, set "Status: Approved" and suggest /task-fusion:plan <id>.
