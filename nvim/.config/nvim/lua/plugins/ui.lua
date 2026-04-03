-- UI 系プラグイン設定

return {
  -- ==========================================================================
  -- カラースキーム: Catppuccin
  -- ==========================================================================
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000, -- 他のプラグインより先に読み込む
    opts = {
      flavour = "mocha", -- latte / frappe / macchiato / mocha
      integrations = {
        cmp = true,
        gitsigns = true,
        nvimtree = true,
        telescope = { enabled = true },
        treesitter = true,
        which_key = true,
      },
    },
    config = function(_, opts)
      require("catppuccin").setup(opts)
      -- カラースキームを適用
      vim.cmd.colorscheme("catppuccin")
    end,
  },

  -- ==========================================================================
  -- ステータスライン: lualine.nvim
  -- ==========================================================================
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      options = {
        theme = "catppuccin",
        -- セクション区切りをスラッシュ形式に
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
      },
    },
  },

  -- ==========================================================================
  -- バッファタブライン: bufferline.nvim
  -- ==========================================================================
  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      options = {
        diagnostics = "nvim_lsp",
        -- LSP エラーのあるバッファにアイコンを表示
        diagnostics_indicator = function(_, _, diag)
          local icons = { error = " ", warning = " " }
          local ret = (diag.error and icons.error .. diag.error .. " " or "")
            .. (diag.warning and icons.warning .. diag.warning or "")
          return vim.trim(ret)
        end,
        offsets = {
          {
            filetype = "NvimTree",
            text = "ファイルツリー",
            highlight = "Directory",
            separator = true,
          },
        },
      },
    },
  },

  -- ==========================================================================
  -- インデントガイド: indent-blankline.nvim
  -- ==========================================================================
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      indent = { char = "│" },
      scope = { enabled = false },
    },
  },

  -- ==========================================================================
  -- カラーコードのプレビュー: nvim-colorizer.lua
  -- ==========================================================================
  {
    "NvChad/nvim-colorizer.lua",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      user_default_options = { tailwind = true },
    },
  },
}
