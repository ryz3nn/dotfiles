
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

-- Keymaps
local map = vim.keymap.set

map("n", "<Space>", "<Nop>")
map("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Save / Quit
map("n", "<leader>w", "<cmd>write<CR>")
map("n", "<leader>q", "<cmd>quit<CR>")
map("n", "<leader>x", "<cmd>x<CR>")

-- Window navigation
map("n", "<C-h>", "<C-w>h")
map("n", "<C-j>", "<C-w>j")
map("n", "<C-k>", "<C-w>k")
map("n", "<C-l>", "<C-w>l")

-- Window management
map("n", "<leader>sv", "<cmd>vsplit<CR>")
map("n", "<leader>sh", "<cmd>split<CR>")
map("n", "<leader>se", "<C-w>=")
map("n", "<leader>sx", "<cmd>close<CR>")

-- Buffer navigation
map("n", "<S-l>", "<cmd>bnext<CR>")
map("n", "<S-h>", "<cmd>bprevious<CR>")
map("n", "<leader>bd", "<cmd>bdelete<CR>")

-- Move lines
map("n", "<A-j>", "<cmd>move .+1<CR>==")
map("n", "<A-k>", "<cmd>move .-2<CR>==")
map("v", "<A-j>", ":move '>+1<CR>gv=gv")
map("v", "<A-k>", ":move '<-2<CR>gv=gv")

-- Better indentation
map("v", "<", "<gv")
map("v", ">", ">gv")

-- Terminal
map("n", "<leader>t", "<cmd>terminal<CR>")
map("t", "<Esc>", "<C-\\><C-n>")

-- Diagnostics (built-in LSP)
map("n", "<leader>d", vim.diagnostic.open_float)
map("n", "[d", vim.diagnostic.goto_prev)
map("n", "]d", vim.diagnostic.goto_next)

-- Filetype settings
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "c", "cpp", "h" },
  callback = function()
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
  end,
})

-- Remember cursor position
vim.api.nvim_create_autocmd("BufReadPost", {
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local line = mark[1]
    if line > 0 and line <= vim.api.nvim_buf_line_count(0) then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})
