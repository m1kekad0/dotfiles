# dotfiles

m1kekad0 の個人用 dotfiles リポジトリです。

## 概要

各種ツール・シェルの設定ファイルを一元管理します。
[GNU Stow](https://www.gnu.org/software/stow/) を使用してシンボリックリンクをホームディレクトリに展開します。

## パッケージ一覧

| パッケージ | 展開先 | 内容 |
|---|---|---|
| `nvim/` | `~/.config/nvim/` | Neovim 設定（lazy.nvim / LSP / treesitter） |
| `wezterm/` | `~/.config/wezterm/` | WezTerm 設定（カラースキーム・フォント・キーバインド） |
| `zsh/` | `~/` | Zsh 設定（`.zshrc`・`.zshenv`、Oh My Zsh / Powerlevel10k） |
| `git/` | `~/` | Git 設定（`.gitconfig`・`.gitignore_global`） |
| `claude/` | `~/.claude/` | Claude Code 設定（グローバル指示・hooks・カスタムコマンド） |

## セットアップ

### 前提条件

- [GNU Stow](https://www.gnu.org/software/stow/) がインストールされていること

```bash
# macOS
brew install stow
```

### インストール

```bash
# リポジトリをクローン
git clone https://github.com/m1kekad0/dotfiles.git ~/dotfiles
cd ~/dotfiles

# 全パッケージを一括展開
stow -t ~ */

# 特定パッケージのみ展開
stow -t ~ nvim
stow -t ~ zsh
```

### アンインストール

```bash
# 特定パッケージのシンボリックリンクを削除
stow -t ~ -D nvim
```

## ディレクトリ構成

```
dotfiles/
├── CLAUDE.md
├── README.md
├── nvim/
│   └── .config/nvim/          # → ~/.config/nvim/
│       ├── init.lua
│       └── lua/
│           ├── config/
│           └── plugins/
├── wezterm/
│   └── .config/wezterm/       # → ~/.config/wezterm/
│       └── wezterm.lua
├── zsh/
│   ├── .zshrc                 # → ~/.zshrc
│   └── .zshenv                # → ~/.zshenv
├── git/
│   ├── .gitconfig             # → ~/.gitconfig
│   └── .gitignore_global      # → ~/.gitignore_global
└── claude/
    └── .claude/               # → ~/.claude/
        ├── CLAUDE.md
        ├── settings.json
        ├── statusline-command.sh
        ├── statusline-line2.py
        └── commands/
```

## 作業ルール

- 特定のパッケージを作業する際は、対応するフィーチャーブランチを切ること（例: `feature/nvim`）
- 設定ファイルを追加・変更した場合は、このREADMEも合わせて更新すること
- 機密情報（トークン・パスワード等）は絶対にコミットしないこと
