#!/bin/bash
# Claude Code ステータスライン
# Powerlevel10k（~/.p10k.zsh）の配色・構成に寄せた Powerline 風 2 行表示。
#   1 行目: カレントディレクトリ + Git ブランチ（p10k の dir / vcs セグメントを再現）
#   2 行目: モデル名 + コンテキスト／レートリミット使用率バー

input=$(cat)

# ---------- 配色定義（p10k.zsh の POWERLEVEL9K_DIR_*/VCS_* と同系色の ANSI 256色） ----------
RESET='\033[0m'
ARROW=''  # Powerline 風のセグメント区切り記号（Nerd Font が必要）

DIR_BG=4        # 青（p10k: POWERLEVEL9K_DIR_BACKGROUND）
DIR_FG=0        # 黒。パステル系テーマでは ANSI 4 が明るい青に割り当てられ、
                # 白文字（15）だと潰れるため、vcs セグメントと同じ黒文字で統一する
VCS_CLEAN_BG=2      # 緑（p10k: POWERLEVEL9K_VCS_CLEAN_BACKGROUND）
VCS_DIRTY_BG=3      # 黄（p10k: POWERLEVEL9K_VCS_MODIFIED_BACKGROUND）
VCS_CONFLICT_BG=1   # 赤（コンフリクト時の強調表示）
VCS_FG=0        # 黒（p10k: my_git_formatter の clean/modified 文字色）

# --- Line 1: カレントディレクトリ セグメント ---
cwd=$(echo "$input" | jq -r '.workspace.current_dir // .cwd')
home_dir="$HOME"
display_cwd="${cwd/#$home_dir/~}"
bs=$'\\'
display_cwd=${display_cwd//"$bs"/"$bs$bs"}  # printf %b でのエスケープ解釈を防ぐ

line1="\033[48;5;${DIR_BG}m\033[38;5;${DIR_FG}m ${display_cwd} ${RESET}"

# --- Line 1: Git ブランチ セグメント（存在する場合のみ、p10k の vcs セグメントを再現） ---
if git -C "$cwd" --no-optional-locks rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  branch_name=$(git -C "$cwd" --no-optional-locks symbolic-ref --short HEAD 2>/dev/null \
    || git -C "$cwd" --no-optional-locks rev-parse --short HEAD 2>/dev/null)
  branch_name=${branch_name//"$bs"/"$bs$bs"}

  porcelain=$(git -C "$cwd" --no-optional-locks status --porcelain 2>/dev/null)

  staged=0
  unstaged=0
  untracked=0
  conflicted=0
  if [ -n "$porcelain" ]; then
    staged=$(echo "$porcelain" | grep -cE '^[MADRC]')
    unstaged=$(echo "$porcelain" | grep -cE '^.[MD]')
    untracked=$(echo "$porcelain" | grep -c '^??')
    conflicted=$(echo "$porcelain" | grep -cE '^(DD|AU|UD|UA|DU|AA|UU)')
  fi

  ahead=0
  behind=0
  ahead_behind=$(git -C "$cwd" --no-optional-locks rev-list --left-right --count '@{upstream}...HEAD' 2>/dev/null)
  if [ -n "$ahead_behind" ]; then
    behind=$(echo "$ahead_behind" | awk '{print $1}')
    ahead=$(echo "$ahead_behind" | awk '{print $2}')
  fi

  status_str=""
  [ "$ahead" -gt 0 ] && status_str="${status_str} >${ahead}"
  [ "$behind" -gt 0 ] && status_str="${status_str} <${behind}"
  [ "$staged" -gt 0 ] && status_str="${status_str} +${staged}"
  [ "$unstaged" -gt 0 ] && status_str="${status_str} !${unstaged}"
  [ "$untracked" -gt 0 ] && status_str="${status_str} ?${untracked}"

  if [ "$conflicted" -gt 0 ]; then
    vcs_bg=$VCS_CONFLICT_BG
  elif [ -n "$porcelain" ]; then
    vcs_bg=$VCS_DIRTY_BG
  else
    vcs_bg=$VCS_CLEAN_BG
  fi

  # ディレクトリ→ブランチ の区切り矢印（背景色の切り替えを表現）
  line1="${line1}\033[38;5;${DIR_BG}m\033[48;5;${vcs_bg}m${ARROW}${RESET}"
  line1="${line1}\033[48;5;${vcs_bg}m\033[38;5;${VCS_FG}m ${branch_name}${status_str} ${RESET}"
  # 末尾の区切り矢印（背景色から通常表示への切り替えを表現）
  line1="${line1}\033[38;5;${vcs_bg}m${ARROW}${RESET}"
else
  # Git 管理下でない場合はディレクトリ セグメントのみで終端
  line1="${line1}\033[38;5;${DIR_BG}m${ARROW}${RESET}"
fi

# --- Line 2: モデル名 + コンテキスト／レートリミット使用率（グラデーションバー） ---
line2=$(echo "$input" | python3 "$HOME/.claude/statusline-line2.py")

printf "%b\n%s\n" "$line1" "$line2"
