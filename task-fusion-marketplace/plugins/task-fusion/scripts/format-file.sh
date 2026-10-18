#!/usr/bin/env bash
# TaskFusion formatter: best-effort formatting after Write/Edit. Never blocks.
# Opt-in per project: runs only when .task-fusion/format-on-edit exists, so
# legacy files are not reformatted wholesale by default.

input="$(cat)"
command -v jq >/dev/null 2>&1 || exit 0

file="$(printf '%s' "$input" | jq -r '.tool_input.file_path // empty')"
if [ -z "$file" ] || [ ! -f "$file" ]; then
  exit 0
fi

cd "${CLAUDE_PROJECT_DIR:-.}" 2>/dev/null || exit 0
[ -f .task-fusion/format-on-edit ] || exit 0

case "$file" in
  *.ts|*.tsx|*.js|*.jsx|*.mjs|*.cjs|*.json|*.css|*.scss|*.html|*.md|*.yml|*.yaml)
    if [ -x node_modules/.bin/prettier ]; then
      node_modules/.bin/prettier --write "$file" >/dev/null 2>&1
    fi
    ;;
  *.py)
    if command -v black >/dev/null 2>&1; then
      black -q "$file" >/dev/null 2>&1
    fi
    ;;
  *.go)
    if command -v gofmt >/dev/null 2>&1; then
      gofmt -w "$file" >/dev/null 2>&1
    fi
    ;;
esac

exit 0
