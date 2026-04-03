-- Neovim メインエントリポイント
-- lazy.nvim をブートストラップしてプラグインと設定を読み込む

-- lazy.nvim のインストールパス
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

-- lazy.nvim が存在しない場合はクローンしてくる
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end

-- lazy.nvim をランタイムパスに追加
vim.opt.rtp:prepend(lazypath)

-- 基本設定を読み込む
require("config.options")
require("config.keymaps")

-- プラグインを読み込む
require("lazy").setup("plugins", {
  -- インストール時のカラースキーム
  install = { colorscheme = { "catppuccin" } },
  -- 起動時に自動でプラグインをチェック
  checker = { enabled = true, notify = false },
  -- パフォーマンス最適化
  performance = {
    rtp = {
      -- 不要なデフォルトプラグインを無効化
      disabled_plugins = {
        "gzip",
        "matchit",
        "matchparen",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})
