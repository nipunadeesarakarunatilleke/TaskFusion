#!/usr/bin/env bash
# TaskFusion dependency guard: blocks installing a package that is not already
# declared in the project's manifests, so an invented, misspelt or unapproved
# package needs a human decision first. Installing from the manifests
# (npm install, pip install -r requirements.txt, ...) is always allowed.
# Exit 2 blocks the tool call; the stderr message is shown to Claude.

input="$(cat)"
command -v jq >/dev/null 2>&1 || exit 0

cmd="$(printf '%s' "$input" | jq -r '.tool_input.command // empty')"
[ -z "$cmd" ] && exit 0

cd "${CLAUDE_PROJECT_DIR:-.}" 2>/dev/null || exit 0

# Manifests in the project root and up to three folders down (monorepos),
# skipping installed packages and virtual environments.
manifests=()
while IFS= read -r f; do
  manifests+=("$f")
done < <(find . -maxdepth 4 \
  \( -name node_modules -o -name .git -o -name vendor -o -name .venv -o -name venv \
     -o -name site-packages -o -name target -o -name bin -o -name obj \) -prune -o \
  -type f \( -name package.json -o -name 'requirements*.txt' -o -name pyproject.toml \
     -o -name setup.py -o -name setup.cfg -o -name Pipfile -o -name go.mod \
     -o -name Cargo.toml -o -name Gemfile -o -name '*.gemspec' -o -name composer.json \
     -o -name '*.csproj' -o -name '*.fsproj' -o -name '*.vbproj' \
     -o -name Directory.Packages.props -o -name packages.config \) -print 2>/dev/null)

# True if the package name appears as a whole word in any manifest.
# Case-insensitive; "-", "_" and "." are treated as equivalent (Python names).
declared() {
  local name="$1" re="" c i
  [ ${#manifests[@]} -eq 0 ] && return 1
  for ((i = 0; i < ${#name}; i++)); do
    c="${name:i:1}"
    case "$c" in
      -|_|.) re+='[-_.]' ;;
      '['|']'|'\'|'*'|'^'|'$'|'+'|'?'|'('|')'|'{'|'}'|'|') re+="\\$c" ;;
      *) re+="$c" ;;
    esac
  done
  grep -iqE "(^|[^A-Za-z0-9_.-])${re}([^A-Za-z0-9_.-]|$)" "${manifests[@]}"
}

# Strips a version or extras suffix: lodash@4, @scope/pkg@1, requests==2.31, pkg[extra].
base_name() {
  local a="$1"
  if [[ "$a" == @* ]]; then
    a="${a:1}"; printf '@%s' "${a%%@*}"; return
  fi
  printf '%s' "${a%%[@=<>!~\[;]*}"
}

is_path_or_url() {
  case "$1" in
    .|./*|../*|/*|~*|*://*|git+*|*.whl|*.tgz|*.tar.gz|*.zip) return 0 ;;
  esac
  return 1
}

undeclared=()
while IFS= read -r part; do
  read -ra t <<< "$part"
  while [ ${#t[@]} -gt 0 ] && { [ "${t[0]}" = sudo ] || [[ "${t[0]}" == [A-Za-z_]*=* ]]; }; do
    t=("${t[@]:1}")
  done
  [ ${#t[@]} -lt 2 ] && continue

  tool="${t[0]##*/}"; sub="${t[1]}"; start=2
  case "$tool" in
    python|python3)
      [ "${t[1]}" = -m ] && [[ "${t[2]}" == pip* ]] || continue
      tool=pip; sub="${t[3]}"; start=4 ;;
    pip3) tool=pip ;;
    uv)
      if [ "$sub" = pip ]; then tool=pip; sub="${t[2]}"; start=3; fi ;;
  esac

  case "$tool:$sub" in
    npm:install|npm:i|npm:add|yarn:add|pnpm:add|pnpm:install|pnpm:i|bun:add|bun:install|bun:i|\
    pip:install|poetry:add|uv:add|pipenv:install|\
    go:get|go:install|cargo:add|cargo:install|gem:install|bundle:add|composer:require) ;;
    dotnet:add)
      for ((i = 2; i < ${#t[@]} - 1; i++)); do
        if [ "${t[i]}" = package ]; then
          declared "${t[i+1]}" || undeclared+=("${t[i+1]}")
        fi
      done
      continue ;;
    *) continue ;;
  esac

  skip_next=0
  for ((i = start; i < ${#t[@]}; i++)); do
    a="${t[i]}"
    if [ $skip_next -eq 1 ]; then skip_next=0; continue; fi
    case "$a" in
      -r|--requirement|-c|--constraint|-e|--editable|-i|--index-url|--extra-index-url|\
      -t|--target|--prefix|-f|--find-links|--registry|-v|--version|--path|--git|--source)
        skip_next=1; continue ;;
      -*) continue ;;
    esac
    is_path_or_url "$a" && continue
    name="$(base_name "$a")"
    [ -z "$name" ] && continue
    declared "$name" || undeclared+=("$name")
  done
done < <(printf '%s\n' "$cmd" | awk '{ gsub(/&&|\|\||;|\|/, "\n"); print }')

if [ ${#undeclared[@]} -gt 0 ]; then
  echo "TaskFusion dependency guard blocked this command: ${undeclared[*]} is not declared in the project's manifests. Check that the package exists under exactly this name and is the one intended (for example with npm view or pip index versions), then ask the user. Approved dependencies belong in the plan's New dependencies section; declare them in the manifest and install from it, or the user can run the command themselves." >&2
  exit 2
fi

exit 0
