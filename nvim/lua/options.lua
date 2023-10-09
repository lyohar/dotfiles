local keymap = vim.keymap.set
local nmap_opts = { noremap = true, silent = true }
keymap("", "<Space>", "<Nop>", nmap_opts)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Navigation
keymap("n", "<c-k>", ":wincmd k<CR>", nmap_opts)
keymap("n", "<c-j>", ":wincmd j<CR>", nmap_opts)
keymap("n", "<c-h>", ":wincmd h<CR>", nmap_opts)
keymap("n", "<c-l>", ":wincmd l<CR>", nmap_opts)
keymap("n", "<leader>/", ":CommentToggle<CR>", nmap_opts)

-- Splits
keymap("n", "|", ":vsplit<CR>")
keymap("n", "\\", ":split<CR>")

-- Other
--vim.keymap.set('n', '<leader>w', ':w<CR>')
--vim.keymap.set('n', '<leader>x', ':BufferLinePickClose<CR>')
--vim.keymap.set('n', '<leader>X', ':BufferLineCloseRight<CR>')
--vim.keymap.set('n', '<leader>s', ':BufferLineSortByTabs<CR>')
--vim.keymap.set('i', 'jj', '<Esc>')
--vim.keymap.set('n', '<leader>h', ':nohlsearch<CR>')

-- Tabs
vim.keymap.set('n', '<Tab>', ':BufferLineCycleNext<CR>')
vim.keymap.set('n', '<s-Tab>', ':BufferLineCyclePrev<CR>')

-- Terminal
--vim.keymap.set('n', '<leader>tf', ':ToggleTerm direction=float<CR>')
--vim.keymap.set('n', '<leader>th', ':ToggleTerm direction=horizontal<CR>')
--vim.keymap.set('n', '<leader>tv', ':ToggleTerm direction=vertical size=40<CR>')


local opt = vim.opt -- for conciseness

-- line numbers
opt.relativenumber = true -- show relative line numbers
opt.number = true -- shows absolute line number on cursor line (when relative number is on)

-- tabs & indentation
opt.tabstop = 2 -- 2 spaces for tabs (prettier default)
opt.shiftwidth = 2 -- 2 spaces for indent width
opt.expandtab = true -- expand tab to spaces
opt.autoindent = true -- copy indent from current line when starting new one

-- line wrapping
opt.wrap = false -- disable line wrapping

-- search settings
opt.ignorecase = true -- ignore case when searching
opt.smartcase = true -- if you include mixed case in your search, assumes you want case-sensitive

-- cursor line
opt.cursorline = true -- highlight the current cursor line

-- appearance

-- turn on termguicolors for nightfly colorscheme to work
-- (have to use iterm2 or any other true color terminal)
opt.termguicolors = true
opt.background = "dark" -- colorschemes that can be light or dark will be made dark
opt.signcolumn = "yes" -- show sign column so that text doesn't shift

-- backspace
opt.backspace = "indent,eol,start" -- allow backspace on indent, end of line or insert mode start position

-- clipboard
opt.clipboard:append("unnamedplus") -- use system clipboard as default register

-- split windows
opt.splitright = true -- split vertical window to the right
opt.splitbelow = true -- split horizontal window to the bottom

-- turn off swapfile
opt.swapfile = false
