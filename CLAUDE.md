# dotfiles リポジトリ

m1kekad0 の個人用 dotfiles を管理するリポジトリです。

## 概要

各種ツール・シェルの設定ファイル（dotfiles）を一元管理します。
シンボリックリンクを使ってホームディレクトリに展開することを想定しています。

## シンボリックリンク管理

**GNU Stow** を使用してシンボリックリンクを管理する。

```bash
# 全パッケージを一括で展開（folding 防止のため --no-folding を付ける）
stow --no-folding -t ~ */

# 特定パッケージのみ展開
stow -t ~ nvim

# claude・agents は必ず --no-folding で展開する
# （~/.claude・~/.agents がリポジトリ内を指し、認証情報等が書き込まれるのを防ぐ）
stow --no-folding -t ~ claude agents

# リンクを削除（アンストール）
stow -t ~ -D nvim
```

## ディレクトリ構成

GNU Stow のターゲットは `~`（ホームディレクトリ）とする。
各パッケージディレクトリ内は、ホームディレクトリからの**相対パスをそのまま再現**する。

- `~/.config/` 配下に展開するアプリは `<package>/.config/<app>/` に配置する
- `~/` 直下に展開するファイル（`.zshrc` 等）は `<package>/` 直下に配置する

```
dotfiles/
├── CLAUDE.md
├── README.md
├── install.sh               # セットアップスクリプト（stow を実行）
├── nvim/                    # Neovim 設定パッケージ
│   └── .config/
│       └── nvim/            # → ~/.config/nvim/ にリンク
│           ├── init.lua
│           └── lua/
├── wezterm/                 # WezTerm 設定パッケージ
│   └── .config/
│       └── wezterm/         # → ~/.config/wezterm/ にリンク
│           └── wezterm.lua
├── zsh/                     # Zsh 設定パッケージ
│   ├── .zshrc               # → ~/.zshrc にリンク
│   └── .zshenv              # → ~/.zshenv にリンク
├── git/                     # Git 設定パッケージ
│   ├── .gitconfig           # → ~/.gitconfig にリンク
│   └── .gitignore_global    # → ~/.gitignore_global にリンク
├── tmux/                    # tmux 設定パッケージ
│   └── .config/
│       └── tmux/            # → ~/.config/tmux/ にリンク
│           └── tmux.conf
├── claude/                  # Claude Code statusline パッケージ（settings.json は管理しない）
│   └── .claude/             # → ~/.claude/ 配下にファイル単位でリンク
└── agents/                  # 共通 SKILL パッケージ
    └── .agents/skills/      # → ~/.agents/skills/ 配下にファイル単位でリンク
        └── web-preview/
```

`claude/.claude/`・`agents/.agents/` は `.gitignore` の許可リストで管理する。ファイルを追加する際は `.gitignore` にも `!` で追記すること。

## 作業ルール

- 特定のパッケージ（例: `nvim`）を作業する際は、対応するフィーチャーブランチ（例: `feature/nvim`）を切ってから作業すること
- 設定ファイルを追加・変更した場合は、`README.md` のセットアップ手順も合わせて更新すること
- 新しいアプリの設定を追加する際は、展開先（`~/` か `~/.config/` か）を確認してからディレクトリを作成すること
- シェルスクリプトには実行権限を付与すること（`chmod +x`）
- 機密情報（トークン・パスワード等）は絶対にコミットしないこと
- OS 固有の設定は `darwin/` や `linux/` などのサブディレクトリで分離すること

## コーディング規約

- シェルスクリプトは `bash` または `zsh` で記述する
- スクリプト先頭に shebang を必ず記載する（例: `#!/usr/bin/env bash`）
- コメントはすべて日本語で記述すること
- インデントはスペース 2 つを使用すること
