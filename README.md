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
| `mise/` | `~/.config/mise/` | mise のグローバルなランタイム設定 |

> **Note**: AI コーディングエージェント関連の設定（Claude Code・共通ルール `AGENTS.md` 等）は
> [ai-agent-config](https://github.com/m1kekad0/ai-agent-config) リポジトリへ分離しました。

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
stow -t ~ mise
```

### mise のランタイム導入

`mise` をインストール後、設定を展開して次のコマンドを実行すると、グローバル設定で指定したランタイムを導入できます。

```bash
mise install
```

プロジェクトごとのバージョン指定は、各プロジェクトの `mise.toml` を優先します。

すでに `~/.config/mise/config.toml` がある場合は、Stow で展開する前に内容を確認して退避してください。
退避後は既存の設定とこのリポジトリの設定を比較し、必要な項目を統合します。

```bash
mv ~/.config/mise/config.toml ~/.config/mise/config.toml.backup
stow -t ~ mise
```

### 端末固有の Zsh 設定

トークンや端末ごとの PATH は Git 管理せず、`~/.zshrc.local` に定義します。初回のみ、
Stow で展開された `~/.zshrc.local.example` をコピーして作成してください。

```bash
cp ~/.zshrc.local.example ~/.zshrc.local
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
│   └── .zshrc.local.example   # → ~/.zshrc.local.example
├── mise/
│   └── .config/mise/          # → ~/.config/mise/
│       └── config.toml
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
