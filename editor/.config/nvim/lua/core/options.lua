-- General Settings
vim.opt.history = 10000
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.belloff = "all"

-- Line Numbers & Display
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.wrap = true
vim.opt.linebreak = true
vim.opt.breakindent = true

-- Buffers & Folds
vim.opt.hidden = true -- Change buffer without saving
vim.opt.foldmethod = "indent"
vim.opt.foldenable = false

-- Mouse & Clipboard
vim.opt.mouse = "a"
vim.opt.clipboard = "unnamedplus"
vim.opt.backspace = { "indent", "eol", "start" }

-- Tabs & Indentation
vim.opt.tabstop = 2 -- Number of spaces a tab counts for
vim.opt.softtabstop = 2 -- Tab with 2 spaces
vim.opt.shiftwidth = 2 -- Number of spaces to use for autoindent
vim.opt.expandtab = true -- Convert tabs to spaces
vim.opt.smartindent = true
vim.opt.autoindent = true

-- Search & Matching
vim.opt.showmatch = true
vim.opt.ignorecase = true -- Case-insensitive search
vim.opt.smartcase = true -- Case-sensitive if capital letters are used
vim.opt.incsearch = true -- Show matches while typing
vim.opt.hlsearch = true -- Highlight matches

-- Split
vim.opt.splitright = true

