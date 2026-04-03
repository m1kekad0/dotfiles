# WezTerm 設定

WezTerm のカスタム設定ファイルです。

## ファイル構成

```
wezterm/
└── wezterm.lua   # メイン設定ファイル
```

## セットアップ

`wezterm.lua` を WezTerm の設定ディレクトリにシンボリックリンクを貼ります。

```bash
ln -sf ~/dotfiles/wezterm/wezterm.lua ~/.config/wezterm/wezterm.lua
```

## 設定内容

### 外観

| 項目 | 値 |
|------|----|
| カラースキーム | Catppuccin Mocha |
| フォント | JetBrains Mono（日本語: Noto Sans CJK JP） |
| フォントサイズ | 14.0 |
| ウィンドウ余白 | 上下 8px / 左右 12px |
| 背景透過 | 95%（`window_background_opacity = 0.95`） |
| タイトルバー | 非表示（`window_decorations = "RESIZE"`） |
| タブバー | ウィンドウ上部に表示（シンプルスタイル） |

### 動作

| 項目 | 値 |
|------|----|
| スクロールバック | 10,000 行 |
| ベル | 無効 |
| URL ハイパーリンク | 有効 |

### キーバインド

| キー | 動作 |
|------|------|
| `CMD + D` | ペインを水平分割 |
| `CMD + Shift + D` | ペインを垂直分割 |
| `CMD + W` | 現在のペインを閉じる |
| `CMD + ALT + ←` | 左のペインに移動 |
| `CMD + ALT + →` | 右のペインに移動 |
| `CMD + ALT + ↑` | 上のペインに移動 |
| `CMD + ALT + ↓` | 下のペインに移動 |
| `CMD + T` | 新しいタブを開く |
| `CMD + =` | フォントサイズを拡大 |
| `CMD + -` | フォントサイズを縮小 |
| `CMD + 0` | フォントサイズをリセット |
