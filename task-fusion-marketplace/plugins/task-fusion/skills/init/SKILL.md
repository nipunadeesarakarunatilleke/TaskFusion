---
name: init
description: Analyse the current repository and create or update its CLAUDE.md with build, test and lint commands, structure, conventions and constraints. Use when setting up TaskFusion in a repository for the first time.
disable-model-invocation: true
---

# TaskFusion: initialise repository context

Goal: give every later TaskFusion stage reliable, project-specific context.

1. Detect the stack by inspecting build and config files. Look for modern and legacy build systems alike, for example package.json, pom.xml, build.gradle, build.xml (Ant), *.sln, *.csproj, *.vbproj, packages.config, pyproject.toml, setup.py, requirements.txt, Gemfile, composer.json, go.mod, CMakeLists.txt, configure and Makefile, shell build scripts, SQL and stored-procedure folders, JCL and COBOL copybooks, Dockerfile and CI files (GitHub Actions, Jenkinsfile, .gitlab-ci.yml, azure-pipelines.yml).
2. Identify the exact commands for: install/build, unit tests, a single test, lint, format and local run. Prefer commands already defined in scripts, Makefiles or CI. If a command can only run in CI or a specific environment, record that instead of guessing a local command.
3. Map the top-level structure: main source folders, test folders, configuration and entry points.
4. Infer conventions from existing code: naming, layering, error handling, logging and test style. Only record conventions you can see evidence for. Where the code is inconsistent, record the convention used by the most recent code and note the older style.
5. Record constraints: language and runtime versions, framework versions, end-of-life dependencies, and environment limits (for example "integration tests need the shared test database"). Note roughly how much of the code has automated tests.
6. If CLAUDE.md already exists, read it and propose additions as a diff. Do not remove existing content without asking.
7. Write or update CLAUDE.md with these sections:
   - ## Project overview (2–4 lines)
   - ## Commands (build, test, single test, lint, format, run)
   - ## Structure
   - ## Conventions
   - ## Constraints (runtime and framework versions, environment limits, test coverage)
   - ## Do not (things that must never be changed or run)
8. For a large repository with several major modules, offer to create a short CLAUDE.md inside each major module folder with that module's commands and conventions. Only create them if the user agrees.
9. Create .task-fusion/ with the subfolders context/, requirements/, designs/, plans/ and reports/ if they do not exist, and an index.md that contains only the work item table header shown below.
10. Recommend committing .task-fusion/ (context/, requirements/, designs/, plans/ and index.md) so the whole team shares the same project knowledge. Ask whether reports/ should be committed too or added to .gitignore. Only change .gitignore if they agree.
11. Ask the user whether TaskFusion should format files automatically after each edit. Recommend "no" for legacy or unformatted code, because formatting a whole file turns a small fix into a large diff. If they agree, create the empty file .task-fusion/format-on-edit.
12. Finish with a short summary. If the repository is large, old or poorly documented, suggest /task-fusion:discover as the next step; otherwise suggest /task-fusion:requirements or /task-fusion:flow. Mention /task-fusion:status for checking progress later.

Keep CLAUDE.md under about 150 lines. It is loaded into every session, so every line must earn its place. Detailed knowledge of the system belongs in .task-fusion/context/, which /task-fusion:discover creates.

Index format (.task-fusion/index.md; one row per work item):

   # TaskFusion work items
   | Work item | Title | Stage | Status | Branch | Updated |
   |---|---|---|---|---|---|
