
-- ==========================================
-- Neovim Minimal Configuration
-- ~/.config/nvim/init.lua
-- ==========================================

-- Leader
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- General
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.mouse = "a"
vim.opt.clipboard = "unnamedplus"
vim.opt.undofile = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.termguicolors = true
vim.opt.signcolumn = "yes"
vim.opt.updatetime = 300
vim.opt.timeoutlen = 500

-- Indentation
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.smartindent = true

-- Search
vim.opt.hlsearch = true          
vim.opt.incsearch = true

-- UI
vim.opt.cursorline = true
vim.opt.wrap = false
vim.opt.scrolloff = 5
vim.opt.sidescrolloff = 5
vim.opt.showmode = true
vim.opt.laststatus = 2
vim.opt.cmdheight = 1
vim.opt.winborder = "rounded"

-- Completion
vim.opt.completeopt = { "menu", "menuone", "noselect" }
