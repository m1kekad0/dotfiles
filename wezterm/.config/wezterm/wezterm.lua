-- WezTerm 設定ファイル
-- 参考: https://wezfurlong.org/wezterm/config/files.html

local wezterm = require("wezterm")

--- @type wezterm.Config
local config = wezterm.config_builder()

-- =============================================================================
-- 外観
-- =============================================================================

-- カラースキーム
config.color_scheme = "Catppuccin Mocha"

-- フォント設定
config.font = wezterm.font("HackGen Console", { weight = "Regular" })
config.font_size = 14.0

-- ウィンドウ設定
config.window_padding = {
  left = 12,
  right = 12,
  top = 8,
  bottom = 8,
}

-- 背景の透過（0.0 = 完全透明 / 1.0 = 不透明）
config.window_background_opacity = 0.95

-- macOS のネイティブタイトルバーを非表示にしてシンプルなウィンドウにする
config.window_decorations = "RESIZE"

-- タブバーを非表示（タブを使わない場合）
-- config.enable_tab_bar = false

-- タブバーをウィンドウ下部に表示
config.tab_bar_at_bottom = false

-- ファンシーなタブバーを使用する
config.use_fancy_tab_bar = false

-- =============================================================================
-- 動作
-- =============================================================================

-- スクロールバックのバッファ行数
config.scrollback_lines = 10000

-- クリック時に URL を開く
config.hyperlink_rules = wezterm.default_hyperlink_rules()

-- ベルを無効化
config.audible_bell = "Disabled"

-- =============================================================================
-- キーバインド
-- =============================================================================

config.keys = {
  -- ペインを水平分割
  {
    key = "d",
    mods = "CMD",
    action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
  },
  -- ペインを垂直分割
  {
    key = "d",
    mods = "CMD|SHIFT",
    action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }),
  },
  -- ペインを閉じる
  {
    key = "w",
    mods = "CMD",
    action = wezterm.action.CloseCurrentPane({ confirm = true }),
  },
  -- ペイン間の移動（左）
  {
    key = "LeftArrow",
    mods = "CMD|ALT",
    action = wezterm.action.ActivatePaneDirection("Left"),
  },
  -- ペイン間の移動（右）
  {
    key = "RightArrow",
    mods = "CMD|ALT",
    action = wezterm.action.ActivatePaneDirection("Right"),
  },
  -- ペイン間の移動（上）
  {
    key = "UpArrow",
    mods = "CMD|ALT",
    action = wezterm.action.ActivatePaneDirection("Up"),
  },
  -- ペイン間の移動（下）
  {
    key = "DownArrow",
    mods = "CMD|ALT",
    action = wezterm.action.ActivatePaneDirection("Down"),
  },
  -- 新しいタブを開く
  {
    key = "t",
    mods = "CMD",
    action = wezterm.action.SpawnTab("CurrentPaneDomain"),
  },
  -- フォントサイズを大きくする
  {
    key = "=",
    mods = "CMD",
    action = wezterm.action.IncreaseFontSize,
  },
  -- フォントサイズを小さくする
  {
    key = "-",
    mods = "CMD",
    action = wezterm.action.DecreaseFontSize,
  },
  -- フォントサイズをリセット
  {
    key = "0",
    mods = "CMD",
    action = wezterm.action.ResetFontSize,
  },
}

return config
