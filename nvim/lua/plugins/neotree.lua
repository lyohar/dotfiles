return {
  "nvim-neo-tree/neo-tree.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
  },
  config = function()
    local keymap = vim.keymap
    keymap.set("n", "<leader>e", "<cmd>Neotree float reveal<cr>")
    keymap.set("n", "<leader>E", "<cmd>Neotree left reveal<cr>")
  end,
}

