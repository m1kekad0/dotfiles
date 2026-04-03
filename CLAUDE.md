# dotfiles リポジトリ

m1kekad0 の個人用 dotfiles を管理するリポジトリです。

## 概要

各種ツール・シェルの設定ファイル（dotfiles）を一元管理します。
シンボリックリンクを使ってホームディレクトリに展開することを想定しています。

## ディレクトリ構成（予定）

```
dotfiles/
├── CLAUDE.md
├── README.md
├── install.sh          # セットアップスクリプト
├── wezterm/            # WezTerm 設定
│   └── wezterm.lua
├── zsh/                # Zsh 設定
│   ├── .zshrc
│   └── .zshenv
├── git/                # Git 設定
│   ├── .gitconfig
│   └── .gitignore_global
├── vim/                # Vim / Neovim 設定
│   └── .vimrc
└── tmux/               # tmux 設定
    └── .tmux.conf
```

## 作業ルール

- 設定ファイルを追加・変更した場合は、`README.md` のセットアップ手順も合わせて更新すること
- シェルスクリプトには実行権限を付与すること（`chmod +x`）
- 機密情報（トークン・パスワード等）は絶対にコミットしないこと
- OS 固有の設定は `darwin/` や `linux/` などのサブディレクトリで分離すること

## コーディング規約

- シェルスクリプトは `bash` または `zsh` で記述する
- スクリプト先頭に shebang を必ず記載する（例: `#!/usr/bin/env bash`）
- コメントはすべて日本語で記述すること
- インデントはスペース 2 つを使用すること
