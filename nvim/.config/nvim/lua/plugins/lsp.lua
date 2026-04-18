-- LSP・補完系プラグイン設定

return {
  -- ==========================================================================
  -- LSP 設定マネージャー: nvim-lspconfig
  -- ==========================================================================
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = {
      -- LSP・フォーマッタ・リンターのインストーラ
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      -- 関数シグネチャのヒント表示
      "folke/neodev.nvim",
    },
    config = function()
      -- Neovim の Lua LSP 向けの設定（init.lua 編集に便利）
      require("neodev").setup()

      -- Mason を初期化
      require("mason").setup({
        ui = { border = "rounded" },
      })

      -- 自動インストールするサーバー一覧
      local servers = {
        lua_ls = {
          settings = {
            Lua = {
              workspace = { checkThirdParty = false },
              telemetry = { enable = false },
            },
          },
        },
        ts_ls = {},       -- TypeScript / JavaScript
        eslint = {},      -- ESLint
        pyright = {},     -- Python
        rust_analyzer = {}, -- Rust
        gopls = {},       -- Go
      }

      -- LSP の共通 on_attach（バッファにアタッチ時に呼ばれる）
      local on_attach = function(_, buffer)
        local map = function(keys, func, desc)
          vim.keymap.set("n", keys, func, { buffer = buffer, desc = "LSP: " .. desc })
        end

        map("gd", vim.lsp.buf.definition, "定義に移動")
        map("gD", vim.lsp.buf.declaration, "宣言に移動")
        map("gr", vim.lsp.buf.references, "参照一覧")
        map("gi", vim.lsp.buf.implementation, "実装に移動")
        map("K", vim.lsp.buf.hover, "ホバードキュメントを表示")
        map("<leader>rn", vim.lsp.buf.rename, "リネーム")
        map("<leader>ca", vim.lsp.buf.code_action, "コードアクション")
        map("<leader>ld", vim.diagnostic.open_float, "診断を表示")
        map("[d", vim.diagnostic.goto_prev, "前の診断に移動")
        map("]d", vim.diagnostic.goto_next, "次の診断に移動")
      end

      -- 補完機能から capabilities を取得
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      -- mason-lspconfig で一括設定
      require("mason-lspconfig").setup({
        ensure_installed = vim.tbl_keys(servers),
        handlers = {
          function(server_name)
            local server_opts = servers[server_name] or {}
            server_opts.on_attach = on_attach
            server_opts.capabilities = capabilities
            require("lspconfig")[server_name].setup(server_opts)
          end,
        },
      })
    end,
  },

  -- ==========================================================================
  -- 補完エンジン: nvim-cmp
  -- ==========================================================================
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",   -- LSP ソース
      "hrsh7th/cmp-buffer",     -- バッファ内のテキストソース
      "hrsh7th/cmp-path",       -- ファイルパスソース
      "saadparwaiz1/cmp_luasnip", -- スニペットソース
      {
        "L3MON4D3/LuaSnip",
        -- スニペットエンジン本体
        build = "make install_jsregexp",
        dependencies = { "rafamadriz/friendly-snippets" },
        config = function()
          require("luasnip.loaders.from_vscode").lazy_load()
        end,
      },
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        -- 補完候補ウィンドウのボーダー
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-n>"] = cmp.mapping.select_next_item(),
          ["<C-p>"] = cmp.mapping.select_prev_item(),
          ["<C-d>"] = cmp.mapping.scroll_docs(4),
          ["<C-u>"] = cmp.mapping.scroll_docs(-4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          -- Enter で確定（スニペット展開中はジャンプ）
          ["<CR>"] = cmp.mapping.confirm({ select = false }),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        }),
        -- 補完ソースの優先順位
        sources = cmp.config.sources({
          { name = "nvim_lsp", priority = 1000 },
          { name = "luasnip", priority = 750 },
          { name = "buffer", priority = 500 },
          { name = "path", priority = 250 },
        }),
      })
    end,
  },

  -- ==========================================================================
  -- フォーマッタ・リンター: conform.nvim / nvim-lint
  -- ==========================================================================
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    keys = {
      {
        "<leader>f",
        function() require("conform").format({ async = true }) end,
        desc = "フォーマット",
      },
    },
    opts = {
      -- 保存時に自動フォーマット
      format_on_save = { timeout_ms = 500, lsp_fallback = true },
      formatters_by_ft = {
        lua = { "stylua" },
        python = { "isort", "black" },
        javascript = { "prettier" },
        typescript = { "prettier" },
        json = { "prettier" },
        yaml = { "prettier" },
        markdown = { "prettier" },
      },
    },
  },

  -- ==========================================================================
  -- シンタックスハイライト: nvim-treesitter
  -- 新バージョン（rewrite）では lazy loading 非対応のため lazy = false で起動
  -- ==========================================================================
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    -- 新バージョンは lazy loading を公式にサポートしない
    lazy = false,
    config = function()
      -- パーサーのインストール（非同期）
      require("nvim-treesitter").install({
        "bash", "c", "go", "html", "javascript", "json",
        "lua", "markdown", "python", "rust", "tsx",
        "typescript", "vim", "yaml",
      })

      -- ハイライト・インデントを FileType イベントで有効化
      -- Neovim 組み込みの treesitter API を使用する
      vim.api.nvim_create_autocmd("FileType", {
        pattern = {
          "bash", "c", "go", "html", "javascript", "json",
          "lua", "markdown", "python", "rust", "tsx",
          "typescript", "vim", "yaml",
        },
        callback = function()
          -- パーサー未インストール時はエラーを無視して有効化を試みる
          local ok = pcall(vim.treesitter.start)
          if ok then
            -- treesitter ベースのインデントを有効化
            vim.bo.indentexpr = "v:lua.vim.treesitter.indentexpr()"
          end
        end,
      })
    end,
  },
}
