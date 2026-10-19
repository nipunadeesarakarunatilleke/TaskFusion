---
name: design
description: Produce a solution design from approved requirements, covering components, data, interfaces, key decisions and risks. Use when the user asks for a technical design, architecture or approach for a change.
argument-hint: <work item id or requirements file path>
---

# TaskFusion: design (Architect)

Work item: $ARGUMENTS

1. Load the requirements for the work item (the argument above; otherwise the only active work item in .task-fusion/index.md; if there are several, ask which one). If it is not approved, ask the user to approve it first or confirm they want to continue.
2. Delegate to the task-fusion:architect agent with the requirements, CLAUDE.md and the relevant files in .task-fusion/context/ (especially constraints.md, hotspots.md and decisions.md). For each modules/<module>.md the design touches, run git log --oneline <its Commit>..HEAD -- <its Paths>; if there are commits, tell the user the file may be stale.
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
6. When the user approves, set "Status: Approved", add each key decision to .task-fusion/context/decisions.md using the format below, update the index row (stage Design, status Approved) and suggest /task-fusion:plan <id>.

Decision log format (.task-fusion/context/decisions.md; create it if missing; newest entry last):

   ## D-<n>: <decision title>
   Status: Accepted · Date: <date> · Work item: <id>
   Context: <why a decision was needed>
   Decision: <option chosen>
   Alternatives: <options rejected and why>
   Consequences: <trade-offs accepted>

If a new decision replaces an earlier one, change the earlier entry's status to "Superseded by D-<n>".
