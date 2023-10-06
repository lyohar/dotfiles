local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
print(lazypath)
if not vim.loop.fs_stat(lazypath) then
  print("install lazy")
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
  print("lazy has been istalled")
end
vim.opt.rtp:prepend(lazypath)

local keymap = vim.keymap.set
local nmap_opts = { noremap = true, silent = true }
keymap("", "<Space>", "<Nop>", nmap_opts)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

require("options")

require("lazy").setup("plugins")
