#!/bin/bash

input=$(cat)

# --- Line 1: 現在ディレクトリ + Git リポジトリ名 + ブランチ名 ---
cwd=$(echo "$input" | jq -r '.workspace.current_dir // .cwd')
home_dir="$HOME"
display_cwd="${cwd/#$home_dir/~}"

repo_name=""
branch_name=""

if git -C "$cwd" --no-optional-locks rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  repo_name=$(basename "$(git -C "$cwd" --no-optional-locks rev-parse --show-toplevel 2>/dev/null)")
  branch_name=$(git -C "$cwd" --no-optional-locks symbolic-ref --short HEAD 2>/dev/null \
    || git -C "$cwd" --no-optional-locks rev-parse --short HEAD 2>/dev/null)

  porcelain=$(git -C "$cwd" --no-optional-locks status --porcelain 2>/dev/null)
  if [ -n "$porcelain" ]; then
    added=$(echo "$porcelain" | grep -c '^??' || echo 0)
    modified=$(echo "$porcelain" | grep -cE '^ M|^M |^MM|^ D|^D ' || echo 0)
  else
    added=0
    modified=0
  fi

  diff_parts=""
  [ "$added" -gt 0 ] && diff_parts="+${added}"
  if [ "$modified" -gt 0 ]; then
    [ -n "$diff_parts" ] && diff_parts="$diff_parts ~${modified}" || diff_parts="~${modified}"
  fi

  line1="📂 ${display_cwd} │ 🐙 ${repo_name} │ 🌿 ${branch_name}"
  [ -n "$diff_parts" ] && line1="$line1 ${diff_parts}"
else
  line1="📂 ${display_cwd}"
fi

# --- Line 2: Python でグラデーション付きバーを生成 ---
line2=$(echo "$input" | python3 "$HOME/.claude/statusline-line2.py")

printf "%s\n%s\n" "$line1" "$line2"
