# Neovim 設定

lazy.nvim をベースにした Neovim 設定です。

## ファイル構成

```
nvim/
└── .config/
    └── nvim/                 # → ~/.config/nvim/ にリンク
        ├── init.lua          # エントリポイント・lazy.nvim のブートストラップ
        └── lua/
            ├── config/
            │   ├── options.lua       # 基本オプション設定
            │   └── keymaps.lua       # キーマップ設定
            └── plugins/
                ├── ui.lua            # UI 系プラグイン
                ├── editor.lua        # エディタ機能系プラグイン
                └── lsp.lua           # LSP・補完・シンタックス系プラグイン
```

## セットアップ

GNU Stow でシンボリックリンクを展開します。

```bash
# dotfiles ディレクトリで実行
stow -t ~ nvim
```

展開後のリンク先: `~/.config/nvim/`

初回起動時に lazy.nvim が自動でインストールされ、プラグインのダウンロードが始まります。

## 設定内容

### 基本オプション（`config/options.lua`）

| 項目 | 設定値 |
|------|--------|
| 行番号 | 絶対 + 相対行番号 |
| インデント | スペース 2 つ |
| クリップボード | システムクリップボードと共有 |
| スクロールバック | カーソル上下 8 行を確保 |
| アンドゥ履歴 | ファイルに永続化（10,000 件） |
| 検索 | スマートケース（大文字を含む場合のみ区別） |
| 折り返し | 無効 |

### キーマップ（`config/keymaps.lua`）

**Leader キー**: `Space`

| キー | モード | 動作 |
|------|--------|------|
| `<Esc>` | N | 検索ハイライトをクリア |
| `<leader>w` | N | ファイルを保存 |
| `<leader>q` | N | 終了 |
| `<C-hjkl>` | N | ウィンドウ間の移動 |
| `<C-矢印>` | N | ウィンドウのリサイズ |
| `<S-h>` / `<S-l>` | N | 前・次のバッファに移動 |
| `<leader>bd` | N | バッファを閉じる |
| `J` / `K` | V | 選択行を上下に移動 |
| `<` / `>` | V | インデントを保持したまま変更 |
| `<Esc><Esc>` | T | ターミナルを抜ける |

### プラグイン

#### UI（`plugins/ui.lua`）

| プラグイン | 用途 |
|-----------|------|
| [catppuccin/nvim](https://github.com/catppuccin/nvim) | カラースキーム（Mocha） |
| [nvim-lualine/lualine.nvim](https://github.com/nvim-lualine/lualine.nvim) | ステータスライン |
| [akinsho/bufferline.nvim](https://github.com/akinsho/bufferline.nvim) | バッファタブライン |
| [lukas-reineke/indent-blankline.nvim](https://github.com/lukas-reineke/indent-blankline.nvim) | インデントガイド |
| [NvChad/nvim-colorizer.lua](https://github.com/NvChad/nvim-colorizer.lua) | カラーコードプレビュー |

#### エディタ（`plugins/editor.lua`）

| プラグイン | 用途 | 主なキー |
|-----------|------|---------|
| [nvim-telescope/telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) | ファジーファインダー | `<leader>ff` / `<leader>fg` |
| [nvim-tree/nvim-tree.lua](https://github.com/nvim-tree/nvim-tree.lua) | ファイルツリー | `<leader>e` |
| [lewis6991/gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim) | Git 差分表示 | `]h` / `[h` / `<leader>h*` |
| [folke/which-key.nvim](https://github.com/folke/which-key.nvim) | キーバインドヒント | 自動表示 |
| [numToStr/Comment.nvim](https://github.com/numToStr/Comment.nvim) | コメントトグル | `gc` / `gb` |
| [windwp/nvim-autopairs](https://github.com/windwp/nvim-autopairs) | 括弧の自動補完 | 自動 |
| [kylechui/nvim-surround](https://github.com/kylechui/nvim-surround) | 囲み文字の操作 | `ys` / `ds` / `cs` |

#### LSP・補完（`plugins/lsp.lua`）

| プラグイン | 用途 |
|-----------|------|
| [neovim/nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) | LSP クライアント設定 |
| [williamboman/mason.nvim](https://github.com/williamboman/mason.nvim) | LSP サーバーのインストール管理 |
| [hrsh7th/nvim-cmp](https://github.com/hrsh7th/nvim-cmp) | 補完エンジン |
| [L3MON4D3/LuaSnip](https://github.com/L3MON4D3/LuaSnip) | スニペットエンジン |
| [stevearc/conform.nvim](https://github.com/stevearc/conform.nvim) | 自動フォーマッタ |
| [nvim-treesitter/nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) | シンタックスハイライト |

**LSP キーマップ**（バッファにアタッチ後に有効）

| キー | 動作 |
|------|------|
| `gd` | 定義に移動 |
| `gD` | 宣言に移動 |
| `gr` | 参照一覧 |
| `gi` | 実装に移動 |
| `K` | ホバードキュメントを表示 |
| `<leader>rn` | リネーム |
| `<leader>ca` | コードアクション |
| `<leader>ld` | 診断を表示 |
| `[d` / `]d` | 前・次の診断に移動 |
| `<leader>f` | フォーマット |

**自動インストールされる LSP サーバー**

`lua_ls`, `ts_ls`, `eslint`, `pyright`, `rust_analyzer`, `gopls`
