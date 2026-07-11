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
| `zsh/` | `~/` | Zsh 設定（`.zshrc`・`.zshenv`・`.p10k.zsh`、Oh My Zsh / Powerlevel10k） |
| `git/` | `~/` | Git 設定（`.gitconfig`・`.gitignore_global`） |

> **Note**: AI コーディングエージェント関連の設定（Claude Code・共通ルール `AGENTS.md` 等）は
> [ai-agent-config](https://github.com/m1kekad0/ai-agent-config) リポジトリへ分離しました。

### 既存の Powerlevel10k 設定の移行

既存の Zsh 設定を Stow 管理へ移行する場合は、`~/.p10k.zsh` だけでなく `~/.zshrc` と
`~/.zshenv` も競合します。通常ファイルだけを退避してから展開してください。すでに Stow で
`zsh` パッケージを展開済みの場合は、この手順は不要です。

```bash
mkdir -p ~/.dotfiles-backup/zsh
for file in .zshrc .zshenv .p10k.zsh; do
  [[ -e "$HOME/$file" && ! -L "$HOME/$file" ]] && mv "$HOME/$file" "$HOME/.dotfiles-backup/zsh/$file"
done
stow -t ~ zsh
```

展開後は退避した設定とこのリポジトリの設定との差分を確認し、端末固有の値だけを移行します。

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
git clone https://github.com/m1kekad0/dotfiles.git ~/github.com/m1kekad0/dotfiles
cd ~/github.com/m1kekad0/dotfiles

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
│   ├── .zshenv                # → ~/.zshenv
│   └── .p10k.zsh              # → ~/.p10k.zsh
├── git/
│   ├── .gitconfig             # → ~/.gitconfig
│   └── .gitignore_global      # → ~/.gitignore_global
└── lazygit/
    └── .config/lazygit/       # → ~/.config/lazygit/
        └── config.yml
```

## 作業ルール

- 特定のパッケージを作業する際は、対応するフィーチャーブランチを切ること（例: `feature/nvim`）
- 設定ファイルを追加・変更した場合は、このREADMEも合わせて更新すること
- 機密情報（トークン・パスワード等）は絶対にコミットしないこと
