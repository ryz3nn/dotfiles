-- ============================================================================
-- 1. LEADER KEYS
-- ============================================================================
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- ============================================================================
-- 2. OPTIONS
-- ============================================================================
local opt = vim.opt

-- Line numbers
opt.number = true
opt.relativenumber = true

-- Indentation (4 spaces by default; Makefiles keep real tabs via ftplugin)
opt.tabstop = 4
opt.softtabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.smartindent = true

-- Search
opt.ignorecase = true
opt.smartcase = true
opt.incsearch = true
opt.hlsearch = true

-- Use ripgrep for :grep if available
if vim.fn.executable("rg") == 1 then
  opt.grepprg = "rg --vimgrep --smart-case"
  opt.grepformat = "%f:%l:%c:%m"
end

-- UI & splits
opt.termguicolors = true
opt.signcolumn = "yes"
opt.cursorline = true
opt.colorcolumn = "80"
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.wrap = false
opt.splitright = true
opt.splitbelow = true
opt.showmode = true

-- Behavior & files
opt.mouse = "a"
opt.clipboard = "unnamedplus"
opt.undofile = true
opt.updatetime = 250
opt.timeoutlen = 400
opt.completeopt = { "menu", "menuone", "noselect" }
opt.path:append("**") -- Allow :find and gf to search subdirectories

-- ============================================================================
-- 3. AUTOCOMMANDS
-- ============================================================================
local augroup = vim.api.nvim_create_augroup("UserConfig", { clear = true })

-- Highlight yanked text briefly
vim.api.nvim_create_autocmd("TextYankPost", {
  group = augroup,
  callback = function()
    vim.hl.on_yank({ timeout = 150 })
  end,
})

-- Return to last edit position when opening a file
vim.api.nvim_create_autocmd("BufReadPost", {
  group = augroup,
  callback = function(args)
    local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
    local line_count = vim.api.nvim_buf_line_count(args.buf)
    if mark[1] > 0 and mark[1] <= line_count then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- C/C++ buffer helpers
vim.api.nvim_create_autocmd("FileType", {
  group = augroup,
  pattern = { "c", "cpp" },
  callback = function(args)
    -- If there is no Makefile in the current directory, compile single file with cc
    if vim.fn.filereadable("Makefile") == 0 and vim.fn.filereadable("makefile") == 0 then
      vim.bo[args.buf].makeprg = "cc -Wall -Wextra -g % -o %<"
    end

    -- Quick switch between .c and .h with the same base name
    vim.keymap.set("n", "<leader>ch", function()
      local ext = vim.fn.expand("%:e")
      local target = vim.fn.expand("%:r") .. (ext == "h" and ".c" or ".h")
      if vim.fn.filereadable(target) == 1 then
        vim.cmd.edit(target)
      else
        vim.notify("Not found: " .. target, vim.log.levels.WARN)
      end
    end, { buffer = args.buf, desc = "Switch between .c and .h" })
  end,
})

-- ============================================================================
-- 4. KEYMAPS
-- ============================================================================
local map = vim.keymap.set

-- Clear search highlight
map("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlight" })

-- Built-in file explorer (Netrw)
map("n", "<leader>e", "<cmd>Explore<CR>", { desc = "Open file explorer" })

-- Better window navigation
map("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Move to lower window" })
map("n", "<C-k>", "<C-w>k", { desc = "Move to upper window" })
map("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })

-- Resize windows
map("n", "<C-Up>", "<cmd>resize +2<CR>", { desc = "Increase window height" })
map("n", "<C-Down>", "<cmd>resize -2<CR>", { desc = "Decrease window height" })
map("n", "<C-Left>", "<cmd>vertical resize -2<CR>", { desc = "Decrease window width" })
map("n", "<C-Right>", "<cmd>vertical resize +2<CR>", { desc = "Increase window width" })

-- Keep visual selection when indenting
map("v", "<", "<gv", { desc = "Indent left" })
map("v", ">", ">gv", { desc = "Indent right" })

-- Move selected lines up/down
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- Quickfix & build
map("n", "<leader>m", "<cmd>write | make<CR>", { desc = "Save and run :make" })
map("n", "<leader>co", "<cmd>copen<CR>", { desc = "Open quickfix list" })
map("n", "<leader>cc", "<cmd>cclose<CR>", { desc = "Close quickfix list" })

-- Diagnostics
map("n", "<leader>d", vim.diagnostic.open_float, { desc = "Show line diagnostic" })
map("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostics list" })

-- ============================================================================
-- 5. THEME & UI
-- ============================================================================
pcall(vim.cmd.colorscheme, "habamax")

vim.diagnostic.config({
  virtual_text = true,
  severity_sort = true,
  float = { border = "rounded" },
})

-- ============================================================================
-- 6. LSP (CLANGD)
-- ============================================================================
if vim.fn.executable("clangd") == 1 then
  vim.lsp.config("clangd", {
    cmd = {
      "clangd",
      "--background-index",
      "--clang-tidy",
      "--header-insertion=never",
    },
    filetypes = { "c", "cpp", "objc", "objcpp" },
    root_markers = {
      "compile_commands.json",
      "compile_flags.txt",
      ".clangd",
      "Makefile",
      "CMakeLists.txt",
      ".git",
    },
  })
  vim.lsp.enable("clangd")
end

-- Attach LSP keymaps & built-in completion when an LSP connects
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true }),
  callback = function(args)
    local bufmap = function(mode, lhs, rhs, desc)
      vim.keymap.set(mode, lhs, rhs, { buffer = args.buf, desc = desc })
    end

    bufmap("n", "gd", vim.lsp.buf.definition, "Go to definition")
    bufmap("n", "gD", vim.lsp.buf.declaration, "Go to declaration")
    bufmap("n", "gr", vim.lsp.buf.references, "List references")
    bufmap("n", "gi", vim.lsp.buf.implementation, "Go to implementation")
    bufmap("n", "K", vim.lsp.buf.hover, "Hover documentation")
    bufmap("n", "<leader>rn", vim.lsp.buf.rename, "Rename symbol")
    bufmap({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, "Code action")
    bufmap("n", "<leader>f", function()
      vim.lsp.buf.format({ async = true })
    end, "Format buffer")

    -- Trigger built-in LSP completion with <C-Space> in insert mode
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client and client:supports_method("textDocument/completion") then
      vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = false })
      bufmap("i", "<C-Space>", function()
        vim.lsp.completion.get()
      end, "Trigger LSP completion")
    end
  end,
})
