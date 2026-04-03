#!/usr/bin/env zsh
# Zsh メイン設定ファイル
# インタラクティブシェル起動時に読み込まれる

# Powerlevel10k インスタントプロンプト（先頭付近に必須）
# コンソール入力が必要な処理はこのブロックより上に記述すること
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# ─── Oh My Zsh ────────────────────────────────────────────────────────────────

# Oh My Zsh のインストールパス
export ZSH="$HOME/.oh-my-zsh"

# テーマ設定（Powerlevel10k を使用）
ZSH_THEME="powerlevel10k/powerlevel10k"

# 使用プラグイン一覧
plugins=(
  git                      # git エイリアス・補完
  aliases                  # エイリアス一覧表示
  history                  # 履歴検索ショートカット
  copyfile                 # ファイル内容をクリップボードへコピー
  copypath                 # カレントパスをクリップボードへコピー
  docker                   # Docker 補完
  docker-compose           # Docker Compose 補完
  mise                     # mise（ランタイムマネージャ）補完
  brew                     # Homebrew 補完
  github                   # GitHub CLI 補完
  golang                   # Go 補完
  ruby                     # Ruby 補完
  rails                    # Rails 補完
  you-should-use           # エイリアスの使用を促す
  zsh-completions          # 追加補完定義
  zsh-autosuggestions      # 入力履歴からの自動サジェスト
  zsh-syntax-highlighting  # コマンドのシンタックスハイライト
  zsh-fzf-history-search   # fzf を使った履歴検索
)

source $ZSH/oh-my-zsh.sh

# ─── パス ─────────────────────────────────────────────────────────────────────

export PATH="$HOME/.local/bin:$PATH"

# ─── エイリアス ───────────────────────────────────────────────────────────────

# eza: ls の代替（アイコン・カラー・git 連携）
alias ls='eza --icons'
alias ll='eza --icons -la --git'
alias lt='eza --icons --tree --level=2'

# bat: cat の代替（シンタックスハイライト）
alias cat='bat --style=plain'

# lazygit
alias lg='lazygit'

# ─── プロンプト ────────────────────────────────────────────────────────────────

# Powerlevel10k 設定ファイルを読み込む（p10k configure で生成）
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
