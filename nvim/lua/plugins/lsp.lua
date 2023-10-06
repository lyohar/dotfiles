return {
  {
    "williamboman/mason.nvim",
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
    },
    config = function()
      local mason = require("mason")
      local mason_lspconfig = require("mason-lspconfig")
      mason.setup({
        ui = {
          icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗",
          },
        },
      })

      mason_lspconfig.setup({
        ensure_installed = { "lua_ls", "pylsp" },
        automatic_installation = true,
      })
    end,
  },

  {
    "simrat39/rust-tools.nvim",
    ft = "rust",
    dependencies = "neovim/nvim-lspconfig",
    config = function()
      local m = require("plugins.conf.conf")
      m.signs()
      local options = {
        server = {
          on_attach = m.on_attach,
          capabilities = m.capabilities,
        },
      }
      require("rust-tools").setup(options)
    end,
  },

  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      { "antosha417/nvim-lsp-file-operations", config = true },
    },
    config = function()
      local lspconfig = require("lspconfig")
      local m = require("plugins.conf.conf")
      m.signs()

      lspconfig["pylsp"].setup({
        capabilities = m.capabilities,
        on_attach = m.on_attach,
      })

      lspconfig["lua_ls"].setup({
        capabilities = m.capabilities,
        on_attach = m.on_attach,
        settings = { -- custom settings for lua
          Lua = {
            -- make the language server recognize "vim" global
            diagnostics = {
              globals = { "vim" },
            },
            workspace = {
              -- make language server aware of runtime files
              library = {
                [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                [vim.fn.stdpath("config") .. "/lua"] = true,
              },
            },
          },
        },
      })
    end,
  },
}
