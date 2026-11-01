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
| `homebrew/` | `~/Brewfile` | Homebrew Bundle で管理する開発ツール・GUI アプリ・フォント |
| `mise/` | `~/.config/mise/` | mise のグローバルなランタイム設定 |
| `herdr/` | `~/.config/herdr/` | herdr の設定（テーマ・キーバインド等） |
| `claude/` | `~/.claude/` | Claude Code の statusline スクリプト（`settings.json` は管理しない） |
| `agents/` | `~/.agents/` | 各エージェント共通の SKILL（`skills/web-preview/`） |

> **Note**: AI コーディングエージェント関連では、Claude Code の statusline と共通 SKILL `web-preview` を
> 本リポジトリで管理します。権限設定などその他のエージェント設定は端末ローカルで管理します。

### 既存の Powerlevel10k 設定の移行

既存の Zsh 設定を Stow 管理へ移行する場合は、`~/.p10k.zsh` だけでなく `~/.zshrc` と
`~/.zshenv` も競合します。通常ファイルだけを退避してから展開してください。すでに `zsh`
パッケージを Stow で展開済みの場合も、通常ファイルの `~/.p10k.zsh` を退避してから再度
`stow -t ~ zsh` を実行する必要があります。既存のシンボリックリンクはそのまま保持されます。

```bash
mkdir -p ~/.dotfiles-backup
backup_dir="$(mktemp -d "$HOME/.dotfiles-backup/zsh.XXXXXX")"
for file in .zshrc .zshenv .p10k.zsh; do
  [[ -e "$HOME/$file" && ! -L "$HOME/$file" ]] && mv "$HOME/$file" "$backup_dir/$file"
done
stow -t ~ zsh
```

展開後は退避した設定とこのリポジトリの設定との差分を確認し、端末固有の値だけを移行します。

## セットアップ

### 前提条件

- [Homebrew](https://brew.sh/) がインストールされていること

### インストール

```bash
# リポジトリをクローン
git clone https://github.com/m1kekad0/dotfiles.git ~/github.com/m1kekad0/dotfiles
cd ~/github.com/m1kekad0/dotfiles

# 開発ツール、GUI アプリケーション、フォントをまとめてインストール
brew bundle install --file=homebrew/Brewfile

# 全パッケージを一括展開
stow --no-folding -t ~ */

# 特定パッケージのみ展開
stow -t ~ nvim
stow -t ~ zsh
stow -t ~ mise
stow -t ~ herdr
stow --no-folding -t ~ claude agents
```

`claude`・`agents` パッケージは必ず `--no-folding` 付きで展開してください。`~/.claude` や `~/.agents` が
存在しない状態で展開するとディレクトリごとシンボリックリンクになり、ツールが生成する認証情報や
セッションがリポジトリ内に書き込まれるためです。一括展開もこれを防ぐため `--no-folding` を付けています
（他パッケージもファイル単位のリンクになるため、パッケージにファイルを追加した際は再度 `stow` を実行します）。
すでにディレクトリ単位のリンクで展開済みのパッケージは、`stow --no-folding -t ~ -R <package>` で張り直せます。
その際、folding 状態の間にリポジトリ内（`claude/.claude/` 等）へ生成された不要ファイルがあれば、実行前にリポジトリ外へ退避してください。

### Claude Code の statusline

`~/.claude/settings.json` は権限設定や hooks を含むため本リポジトリでは管理しません。
`claude` パッケージを展開後、端末ローカルの `settings.json` に次の項目を手で追記してください。

```json
"statusLine": {
  "type": "command",
  "command": "bash $HOME/.claude/statusline-command-p10k.sh"
}
```

Powerline 記号を使わないシンプル版を使う場合は `statusline-command.sh` を指定します。
依存ツールは次のとおりです。

- `jq`・`python3`（両スクリプト共通。2 行目は `statusline-line2.py` で描画）
- Nerd Font（p10k 版のみ。区切り記号の表示に必要）

### 共通 SKILL web-preview の Claude Code への登録

`agents` パッケージは `~/.agents/skills/web-preview/` に展開されます。Claude Code からは
`~/.claude/skills/` 配下の相対シンボリックリンクで参照します。

既存の `~/.claude/skills/web-preview` がディレクトリ（またはディレクトリへのリンク）だと、`ln -s` は
その中にリンクを作ってしまいます。作成前に存在を確認し、存在する場合は中身を確認して退避してから再実行してください
（`ln -sf` も同様にディレクトリの中にリンクを作るため使わないでください）。

```bash
mkdir -p ~/.claude/skills
if [ -e ~/.claude/skills/web-preview ] || [ -L ~/.claude/skills/web-preview ]; then
  echo "~/.claude/skills/web-preview が既に存在します。中身を確認して退避してから再実行してください。"
else
  ln -s ../../.agents/skills/web-preview ~/.claude/skills/web-preview
fi
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

### herdr の既存設定

すでに `~/.config/herdr/config.toml` がある場合は、Stow で展開する前に内容を確認して退避してください。
`~/.config/herdr/` にはログファイルやソケットなど Git 管理対象外のファイルも生成されるため、
`config.toml` だけを退避・比較してください。

```bash
mv ~/.config/herdr/config.toml ~/.config/herdr/config.toml.backup
stow -t ~ herdr
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
├── .gitignore                 # claude/・agents/ の管理対象外ファイルを除外
├── homebrew/
│   └── Brewfile             # → ~/Brewfile
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
│   ├── .p10k.zsh              # → ~/.p10k.zsh
│   └── .zshrc.local.example   # → ~/.zshrc.local.example
├── mise/
│   └── .config/mise/          # → ~/.config/mise/
│       └── config.toml
├── herdr/
│   └── .config/herdr/         # → ~/.config/herdr/
│       └── config.toml
├── git/
│   ├── .gitconfig             # → ~/.gitconfig
│   └── .gitignore_global      # → ~/.gitignore_global
├── lazygit/
│   └── .config/lazygit/       # → ~/.config/lazygit/
│       └── config.yml
├── claude/
│   └── .claude/               # → ~/.claude/（--no-folding で展開）
│       ├── statusline-command-p10k.sh
│       ├── statusline-command.sh
│       └── statusline-line2.py
└── agents/
    └── .agents/skills/        # → ~/.agents/skills/（--no-folding で展開）
        └── web-preview/
            ├── SKILL.md
            └── agents/openai.yaml
```

## 作業ルール

- 特定のパッケージを作業する際は、対応するフィーチャーブランチを切ること（例: `feature/nvim`）
- 設定ファイルを追加・変更した場合は、このREADMEも合わせて更新すること
- 機密情報（トークン・パスワード等）は絶対にコミットしないこと
