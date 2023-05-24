-- disable netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- options
local opts = {
  clipboard = "unnamedplus",
  hlsearch = true,
  ignorecase = true,
  number = true,
  relativenumber = false,
  cursorline = true,
  showtabline = 2,
  expandtab = true,
  tabstop = 2,
  shiftwidth = 2,
  termguicolors = true,
  numberwidth = 4,
  signcolumn = "yes",
  completeopt = { 'menu', 'menuone', 'noselect' },
}
for k, v in pairs(opts) do
  vim.opt[k] = v
end

-- plugins
require('packer').startup(function(use)
  use { "wbthomason/packer.nvim" }
  use { "nvim-lua/popup.nvim" }
  use { "nvim-lua/plenary.nvim" }
  use { "ellisonleao/gruvbox.nvim" }
  use { "nvim-treesitter/nvim-treesitter", run = ":TSUpdate", }
  use { "akinsho/toggleterm.nvim" }
  use { "nvim-lualine/lualine.nvim", requires = { "nvim-tree/nvim-web-devicons", opt = true } }
  use { "nvim-telescope/telescope.nvim", tag = "0.1.1" }
  use { "neovim/nvim-lspconfig" }
  use { "williamboman/mason.nvim" }
  use { "williamboman/mason-lspconfig.nvim" }
  use { "hrsh7th/nvim-cmp" }
  use { "hrsh7th/cmp-buffer" }
  use { "hrsh7th/cmp-path" }
  use { "hrsh7th/cmp-nvim-lsp" }
  -- use {"hrsh7th/cmp-cmdline"}
  use { "saadparwaiz1/cmp_luasnip" }
  use { "L3MON4D3/LuaSnip" }
  use { "rafamadriz/friendly-snippets" }
  use { 'numToStr/Comment.nvim' }
  use { 'simrat39/rust-tools.nvim' }
  use { "nvim-tree/nvim-tree.lua" }
  use { "windwp/nvim-autopairs" }
end)

-- common keymaps
local keymap = vim.keymap.set
local nmap_opts = { noremap = true, silent = true }
--Remap space as leader key
keymap("", "<Space>", "<Nop>", nmap_opts)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- colorscheme
vim.o.background = "dark"
vim.cmd([[colorscheme gruvbox]])

-- treesitter
local treesitter_configs = require("nvim-treesitter.configs")
treesitter_configs.setup {
  ensure_installed = { "lua", "rust", "c", "cpp" },
  sync_install = false,
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = true,
  },
  indent = { enable = true, },
}

-- toggle terminal
require('toggleterm').setup {
  open_mapping = [[<c-\>]],
  direction = "float",
  close_on_exit = true,
}

--  lualine
require('lualine').setup {
  options = { theme = 'gruvbox' }
}

--comment
require("Comment").setup()

-- telescope
keymap("n", "<c-t>", "<cmd>Telescope live_grep<cr>", nmap_opts)
keymap("n", "<leader>tf", "<cmd>Telescope find_files hidden=true<cr>", nmap_opts)
keymap("n", "<leader>tb", "<cmd>Telescope buffers<cr>", nmap_opts)

-- mason
require("mason").setup {}
require("mason-lspconfig").setup()

-- nvim-tree
require("nvim-tree").setup({
  sort_by = "case_sensitive",
  view = {
    width = 30,
  },
  renderer = {
    group_empty = true,
  },
  filters = {
    dotfiles = true,
  },
})
keymap("n", "<leader>e", "<cmd>NvimTreeToggle<cr>", nmap_opts)

-- LSP
local cmp_capabilities = require("cmp_nvim_lsp").default_capabilities()

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    -- Buffer local mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local buf_opts = { buffer = ev.buf }
    keymap('n', 'gd', vim.lsp.buf.definition, buf_opts)
    keymap('n', 'gD', vim.lsp.buf.declaration, buf_opts)
    keymap('n', 'gi', vim.lsp.buf.implementation, buf_opts)
    keymap('n', 'gr', vim.lsp.buf.references, buf_opts)
    keymap('n', '<leader>rn', vim.lsp.buf.rename, buf_opts)
    keymap('n', '<leader>l', function() vim.lsp.buf.format { async = true } end, buf_opts)
    keymap({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, buf_opts)
    keymap('n', 'K', vim.lsp.buf.hover, buf_opts)
    keymap('n', '<C-k>', vim.lsp.buf.signature_help, buf_opts)
    -- wtf is it?
    keymap('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, buf_opts)
    keymap('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, buf_opts)
    keymap('n', '<leader>wl', function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, buf_opts)
    keymap('n', '<leader>D', vim.lsp.buf.type_definition, buf_opts)
  end,
})

-- lsp servers
local lspconfig = require('lspconfig')
-- lua. just for neovim - from documentation
lspconfig.lua_ls.setup {
  capabilities = cmp_capabilities,
  settings = {
    Lua = {
      runtime = {
        -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
        version = 'LuaJIT',
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = { 'vim' },
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = vim.api.nvim_get_runtime_file("", true),
        checkThirdParty = false
      },
      -- Do not send telemetry data containing a randomized but unique identifier
      telemetry = {
        enable = false,
      },
    },
  },
}

-- rust tolls (wrapper above neovim-lsp-config for rust)
local rt = require("rust-tools")
rt.setup({
  tools = {
    runnables = {
      use_telescope = true,
    },
    inlay_hints = {
      auto = true,
      show_parameter_hints = false,
      parameter_hints_prefix = "",
      other_hints_prefix = "",
    },
  },
  server = {
    capabilities = cmp_capabilities,
    settings = {
      ["rust-analyzer"] = {
        diagnostics = {
          enable = false,
        },
      },
    },
  },
})

lspconfig.clangd.setup {
  capabilities = cmp_capabilities,
}

-- autopairs
require("nvim-autopairs").setup {}
local cmp_autopairs = require('nvim-autopairs.completion.cmp')

-- completion
local luasnip = require("luasnip")
require("luasnip.loaders.from_vscode").lazy_load()

local check_backspace = function()
  local col = vim.fn.col "." - 1
  return col == 0 or vim.fn.getline("."):sub(col, col):match "%s"
end

local cmp = require("cmp")
cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = {
    ["<C-k>"] = cmp.mapping.select_prev_item(),
    ["<C-j>"] = cmp.mapping.select_next_item(),
    ["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-1), { "i", "c" }),
    ["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(1), { "i", "c" }),
    ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
    ["<C-y>"] = cmp.config.disable,
    ["<C-e>"] = cmp.mapping { i = cmp.mapping.abort(), c = cmp.mapping.close() },
    -- Accept currently selected item. If none selected, `select` first item.
    -- Set `select` to `false` to only confirm explicitly selected items.
    ["<CR>"] = cmp.mapping.confirm { select = true },
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expandable() then
        luasnip.expand()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      elseif check_backspace() then
        fallback()
      else
        fallback()
      end
    end, {
      "i",
      "s",
    }),
    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, {
      "i",
      "s",
    }),
  },
  formatting = {
    fields = { 'menu', 'abbr', 'kind' },
    format = function(entry, item)
      local menu_icon = {
        nvim_lsp = 'λ',
        luasnip = '⋗',
        buffer = 'Ω',
        path = '🖫',
      }
      item.menu = menu_icon[entry.source.name]
      return item
    end,
  },
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
  sources = {
    { name = "nvim_lsp" },
    { name = "luasnip" },
    { name = "buffer" },
    { name = "path" },
  }
})

cmp.event:on(
  'confirm_done',
  cmp_autopairs.on_confirm_done()
)
