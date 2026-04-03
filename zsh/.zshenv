#!/usr/bin/env zsh
# Zsh 環境変数設定ファイル
# ログインシェル・非インタラクティブシェルを含むすべての起動時に読み込まれる
# .zshrc より先に読み込まれるため、PATH 等の基本設定をここに定義する

# ─── XDG Base Directory ───────────────────────────────────────────────────────

export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"
