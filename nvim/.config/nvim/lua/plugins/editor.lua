-- エディタ機能系プラグイン設定

return {
  -- ==========================================================================
  -- ファジーファインダー: telescope.nvim
  -- ==========================================================================
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    dependencies = {
      "nvim-lua/plenary.nvim",
      -- ネイティブソーターで高速化
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
    keys = {
      { "<leader>ff", "<cmd>Telescope find_files<CR>", desc = "ファイルを検索" },
      { "<leader>fg", "<cmd>Telescope live_grep<CR>", desc = "テキストをgrep検索" },
      { "<leader>fb", "<cmd>Telescope buffers<CR>", desc = "バッファを検索" },
      { "<leader>fh", "<cmd>Telescope help_tags<CR>", desc = "ヘルプを検索" },
      { "<leader>fr", "<cmd>Telescope oldfiles<CR>", desc = "最近開いたファイルを検索" },
    },
    config = function()
      local telescope = require("telescope")
      telescope.setup({
        defaults = {
          -- 検索除外パターン
          file_ignore_patterns = { "node_modules", ".git/", "dist/", "build/" },
          -- レイアウト設定
          layout_config = { prompt_position = "top" },
          sorting_strategy = "ascending",
        },
      })
      telescope.load_extension("fzf")
    end,
  },

  -- ==========================================================================
  -- ファイルツリー: nvim-tree.lua
  -- ==========================================================================
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = {
      { "<leader>e", "<cmd>NvimTreeToggle<CR>", desc = "ファイルツリーをトグル" },
    },
    opts = {
      view = { width = 30 },
      renderer = {
        -- git 状態のアイコンを表示
        icons = { show = { git = true } },
      },
      filters = {
        -- .gitignore に含まれるファイルを非表示
        gitignored = true,
        dotfiles = false,
      },
    },
  },

  -- ==========================================================================
  -- Git 連携: gitsigns.nvim
  -- ==========================================================================
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      signs = {
        add = { text = "▎" },
        change = { text = "▎" },
        delete = { text = "" },
        topdelete = { text = "" },
        changedelete = { text = "▎" },
      },
      on_attach = function(buffer)
        local gs = package.loaded.gitsigns
        local map = function(mode, l, r, desc)
          vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
        end
        -- ハンクの移動
        map("n", "]h", gs.next_hunk, "次のハンク")
        map("n", "[h", gs.prev_hunk, "前のハンク")
        -- ハンクの操作
        map("n", "<leader>hs", gs.stage_hunk, "ハンクをステージ")
        map("n", "<leader>hr", gs.reset_hunk, "ハンクをリセット")
        map("n", "<leader>hp", gs.preview_hunk, "ハンクをプレビュー")
        -- git blame
        map("n", "<leader>hb", function() gs.blame_line({ full = true }) end, "行の blame を表示")
      end,
    },
  },

  -- ==========================================================================
  -- キーバインドヒント: which-key.nvim
  -- ==========================================================================
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      -- ポップアップの表示遅延（ms）
      delay = 500,
    },
  },

  -- ==========================================================================
  -- コメントトグル: Comment.nvim
  -- ==========================================================================
  {
    "numToStr/Comment.nvim",
    event = { "BufReadPost", "BufNewFile" },
    opts = {},
    -- gc でラインコメント / gb でブロックコメントをトグル
  },

  -- ==========================================================================
  -- 括弧の自動補完: nvim-autopairs
  -- ==========================================================================
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = { check_ts = true }, -- Treesitter と連携
  },

  -- ==========================================================================
  -- 囲み文字の操作: nvim-surround
  -- ==========================================================================
  {
    "kylechui/nvim-surround",
    event = { "BufReadPost", "BufNewFile" },
    opts = {},
    -- ys{motion}{char}: 囲む / ds{char}: 削除 / cs{old}{new}: 変更
  },
}
