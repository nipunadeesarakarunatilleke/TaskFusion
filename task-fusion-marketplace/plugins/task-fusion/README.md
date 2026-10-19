# TaskFusion

TaskFusion is a Claude Code plugin that packages a generic, role-based agentic SDLC into one installable unit. Specialist agents mirror a delivery team, and each stage produces a written artifact that the next stage builds on. Humans approve each artifact before work moves on. It is stack-agnostic and works on new and legacy codebases alike: project-specific knowledge comes from the repository's own `CLAUDE.md` and from `.task-fusion/context/`.

## Roles

| Agent | Responsibility | Writes code? |
|---|---|---|
| business-analyst | Turns a request into user stories, acceptance criteria and non-functional requirements | No |
| architect | Designs the solution: components, data, interfaces, decisions and risks | No |
| tech-lead | Breaks the design into an ordered plan, reviews the code and runs the final verification gate | No |
| developer | Implements the approved plan and writes the tests | Yes |
| code-archaeologist | Maps existing and legacy code: system map, data flows, business rules, hotspots and constraints | No |

## Workflow

| Stage | Command | Agent | Output |
|---|---|---|---|
| Setup | `/task-fusion:init` | — | `CLAUDE.md` with project commands, conventions and constraints |
| Discover | `/task-fusion:discover` | Code Archaeologist | `.task-fusion/context/*.md` (review gate; for existing or legacy code) |
| Requirements | `/task-fusion:requirements` | Business Analyst | `.task-fusion/requirements/<id>.md` (approval gate) |
| Design | `/task-fusion:design` | Architect | `.task-fusion/designs/<id>.md` (approval gate) |
| Plan | `/task-fusion:plan` | Tech Lead | `.task-fusion/plans/<id>.md` (approval gate) |
| Implement | `/task-fusion:implement` | Developer | Code and tests |
| Review | `/task-fusion:review` | Tech Lead | `.task-fusion/reports/<id>-review.md` |
| Verify | `/task-fusion:verify` | Tech Lead | `.task-fusion/reports/<id>-verify.md` (READY / NOT READY) |
| End to end | `/task-fusion:flow` | All | Runs every stage with the gates above |
| Status | `/task-fusion:status` | — | Work items, what each is waiting for, out-of-date context |

## Guardrails

- **`scripts/guard-bash.sh`** (PreToolUse on Bash) blocks destructive commands: `rm -rf` on `/`, `~` or `$HOME`, force pushes, `git reset --hard`, `git clean -f`, `git branch -D`, SQL `DROP`/`TRUNCATE`, MongoDB `.drop()`/`dropDatabase()`, `mkfs`, `dd` to a device, `chmod -R 777`, and piping `curl`/`wget` into a shell.
- **`scripts/guard-deps.sh`** (PreToolUse on Bash) blocks installing a package that isn't declared in the project's manifests (`npm install <pkg>`, `pip install <pkg>`, `poetry add`, `go get`, `cargo add`, `dotnet add package` and others). Installing from the manifests is always allowed. New dependencies go through the plan's New dependencies section and your approval.
- **`scripts/format-file.sh`** (PostToolUse on Write/Edit) formats the edited file with prettier (from `node_modules/.bin`), black or gofmt when present. It is **opt-in**: it does nothing unless `.task-fusion/format-on-edit` exists in the project, so legacy files are not reformatted wholesale.

## Requirements

- Claude Code, git, jq and bash
- Optional: prettier, black, gofmt (used by the formatter when enabled)

## Install

```
claude plugin marketplace add ./task-fusion-marketplace
claude plugin install task-fusion@task-fusion-marketplace
```

## Quick start

```
/task-fusion:init
/task-fusion:discover            # existing or legacy codebase
/task-fusion:flow <request>
/task-fusion:status              # where is everything up to?
```

## Files created in a project

- `CLAUDE.md`
- `.task-fusion/` with `context/`, `requirements/`, `designs/`, `plans/` and `reports/`
- `.task-fusion/index.md`: one row per work item (stage, status, branch, last updated)
- `.task-fusion/context/decisions.md`: decision log, added to whenever a design is approved
- `.task-fusion/format-on-edit` only if you enable formatting

## Guarding against hallucinated code

- **Evidence rule:** every agent backs factual claims with a file:line reference or command output, and says "not found" or "unsure" instead of guessing.
- **Tests first:** each task's tests are written from its acceptance criteria and must fail before the implementation makes them pass.
- **Real APIs only:** the developer checks third-party APIs against the installed version and never mocks an API it hasn't confirmed exists. Review checks this too.
- **Dependency guard:** packages not declared in the manifests can't be installed without your approval.
- **Checked findings:** the Tech Lead re-reads the cited code for every review finding and drops any it can't confirm.
- **Saved evidence:** verify writes each command, exit code and relevant output to `.task-fusion/reports/<id>-verify-evidence.md`, and every PASS points to it.

## How project knowledge is managed

Everything lives in files in the repository, so work survives between sessions and is shared with the team:

- **`CLAUDE.md`** holds commands, conventions and constraints, and is loaded into every session.
- **`.task-fusion/context/`** holds system knowledge, read by each stage as needed. Verify updates it after every READY change, and `/task-fusion:status` flags module files whose code has changed since they were written.
- **Work item artifacts** in `requirements/`, `designs/`, `plans/` and `reports/` share one id and are tracked in `index.md`. Acceptance criteria numbers (AC-1, AC-2 …) trace each requirement to its design, tasks, tests and verification.
- **Agents** each run in their own context and receive only the files their stage needs.

Commit `.task-fusion/` (context, requirements, designs, plans and `index.md`) so the team shares one picture of the project. `reports/` is optional.

## Working with legacy code

`/task-fusion:discover` uses the code and its git history to write lasting context documents to `.task-fusion/context/`: `system-map.md`, `modules/<module>.md`, `data-flows.md`, `glossary.md`, `business-rules.md` (each rule cited and marked Confirmed or Inferred), `hotspots.md` and `constraints.md`. Re-run it with a module name to refresh one area.

Later stages build on these documents:
- The Business Analyst separates current behaviour from desired behaviour.
- The Architect respects runtime constraints and prefers incremental change over rewrites.
- The Tech Lead plans **characterisation tests** that pin down current behaviour before anything changes, wherever coverage is thin.
- Verify accepts CI or documented manual evidence for checks that cannot run locally.
- The Developer keeps diffs minimal.

## Customising

- Project build, test and lint commands live in the project's `CLAUDE.md`, not in the plugin.
- Add formatters in `scripts/format-file.sh`.
- Add blocked patterns to the `patterns` array in `scripts/guard-bash.sh`, or another package manager to `scripts/guard-deps.sh`.
- Add MCP servers in a `.mcp.json` at the plugin root (never hard-code tokens).
- Adjust the artifact templates in the stage skills (`skills/requirements`, `skills/design`, `skills/plan`).
