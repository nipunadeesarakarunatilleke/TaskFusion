#!/usr/bin/env bash
# TaskFusion guard: blocks destructive shell commands before they run.
# Exit 2 blocks the tool call; the stderr message is shown to Claude.

input="$(cat)"

if ! command -v jq >/dev/null 2>&1; then
  echo "TaskFusion guard: jq is not installed, so commands cannot be checked. Install jq to enable the guard." >&2
  exit 0
fi

cmd="$(printf '%s' "$input" | jq -r '.tool_input.command // empty')"
[ -z "$cmd" ] && exit 0

patterns=(
  'rm[[:space:]]+-[a-zA-Z]*r[a-zA-Z]*f?[a-zA-Z]*[[:space:]]+(/|~|\$HOME)([[:space:]]|/?$)'
  'git[[:space:]]+push.*(--force|--force-with-lease|[[:space:]]-f([[:space:]]|$))'
  'git[[:space:]]+reset[[:space:]]+--hard'
  'git[[:space:]]+clean[[:space:]]+-[a-zA-Z]*f'
  'git[[:space:]]+branch[[:space:]]+-D'
  'drop[[:space:]]+(table|database|schema|collection)'
  'truncate[[:space:]]+table'
  '\.drop\(\)'
  'dropDatabase\(\)'
  'mkfs'
  'dd[[:space:]]+if=.*of=/dev/'
  'chmod[[:space:]]+-R[[:space:]]+777'
  '(curl|wget)[^|]*\|[[:space:]]*(sudo[[:space:]]+)?(ba|z)?sh'
)

for p in "${patterns[@]}"; do
  if printf '%s' "$cmd" | grep -Eiq -- "$p"; then
    echo "TaskFusion guard blocked this command because it matches a destructive pattern ($p). Explain to the user why it is needed and ask them to run it manually if they agree." >&2
    exit 2
  fi
done

exit 0
