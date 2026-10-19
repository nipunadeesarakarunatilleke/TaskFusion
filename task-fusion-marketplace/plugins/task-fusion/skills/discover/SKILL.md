---
name: discover
description: Map an existing or legacy codebase into lasting context documents covering system map, modules, data flows, glossary, business rules, hotspots and constraints. Use before the first work item in an unfamiliar, large or poorly documented repository.
argument-hint: [module or area to focus on]
disable-model-invocation: true
---

# TaskFusion: discover (Code Archaeologist)

Focus: $ARGUMENTS

1. Read CLAUDE.md. If it does not exist, suggest /task-fusion:init first and ask whether to continue without it.
2. Decide the scope: the module or area named above, otherwise the whole repository. If .task-fusion/context/ already exists, read it and update only what the scope covers.
3. For a large repository, split the work by major module. Run the task-fusion:code-archaeologist agent once per module, in parallel where possible, then once more across modules for the system map and cross-module data flows.
4. Write the results to .task-fusion/context/:
   - system-map.md: purpose, modules, entry points, deployable units, external systems, and a Mermaid diagram
   - modules/<module>.md: a "Paths:" line listing the folders the module covers, then responsibility, key files, inbound and outbound dependencies, data owned, existing tests
   - data-flows.md: main flows end to end, data stores (including stored procedures, triggers, files and queues), batch jobs and integrations
   - glossary.md: domain terms as they appear in code, with their meaning
   - business-rules.md: rules found in code, each with file:line evidence and marked Confirmed or Inferred
   - hotspots.md: high-churn files, code with little or no test coverage, very large or complex files, dead-code candidates, deprecated dependencies
   - constraints.md: language, runtime and framework versions, build quirks, and anything that can only run in CI or a specific environment
   - decisions.md: notable past decisions visible in code or git history, each marked Inferred, in the decision log format used by /task-fusion:design (optional; the design stage maintains it afterwards)
   Each file starts with "Status: Draft", "Last updated: <date>" and "Commit: <short sha>".
5. Never copy secret values from configuration files into the context documents. Name the setting and write "<redacted>".
6. Propose CLAUDE.md additions as a diff: a "## Context" line pointing to .task-fusion/context/, plus any commands or constraints that were missing. Apply them only if the user agrees.
7. Present a short summary, the list of files, and the open questions (especially Inferred business rules). STOP and wait for review.
8. When the user approves, set "Status: Approved" in each reviewed file and suggest /task-fusion:requirements or /task-fusion:flow.

Re-run with a module name after major changes to refresh that part of the context.
