# TaskFusion marketplace

This repository is a Claude Code plugin marketplace for the TaskFusion role-based agentic SDLC workflow.

## Plugins

| Plugin | Description |
|---|---|
| [task-fusion](plugins/task-fusion/README.md) | Role-based SDLC workflow: BA, Architect, Tech Lead, Developer and Code Archaeologist agents with guardrails |

## Install

```
claude plugin marketplace add ./task-fusion-marketplace
claude plugin install task-fusion@task-fusion-marketplace
```

If you add the marketplace from a Git host, use `claude plugin marketplace add <owner>/<repo>` (or the full repository URL) instead of the local path.

Then run `/task-fusion:init` in your project. See the [plugin README](plugins/task-fusion/README.md) for the full workflow.
