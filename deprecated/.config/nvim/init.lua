-- Minimal nvim config ---- 

------------------------------------------
------- Options ----------------------------
---------------------------------------

-- General Settings
vim.opt.history = 10000
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.belloff = "all"
vim.opt.shell = "zsh"

-- Line Numbers & Display
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.wrap = false
vim.opt.linebreak = true
vim.opt.breakindent = true

-- Buffers & Folds
vim.opt.hidden = true -- Change buffer without saving
vim.opt.foldmethod = "indent"
vim.opt.foldlevel = 0
vim.opt.foldlevelstart = 99
vim.opt.foldnestmax = 1

-- Mouse & Clipboard
vim.opt.mouse = "a"
-- vim.opt.clipboard = "unnamedplus"
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
vim.opt.path = { ".", "**" }
vim.opt.wildignore:append({ "*/.git/*", "*/node_modules/*" })
-- Split
vim.opt.splitright = true


------------------------------------------------
-------- Keymaps -------------------------------
------------------------------------------------
-- Set leader key
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Disable the spacebar key's default behavior in Normal and Visual modes
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })
local opts = { noremap = true, silent = true }
vim.keymap.set({"n", "v"}, 'zo', 'za')

-- quit file
vim.keymap.set('n', '<C-q>', '<cmd> q! <CR>', opts)

-- delete single character without copying into register
-- vim.keymap.set('n', 'd', '"_d', opts)

vim.keymap.set("x", "<leader>p", [["_dP]])
vim.keymap.set({"n", "v"}, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])
vim.keymap.set({"n", "v"}, "<leader>p", [["+p]])
vim.keymap.set({"n", "v"}, "<leader>d", [["_d]])

-- Move line in Visual mode
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- Vertical scroll and center
vim.keymap.set('n', '<C-d>', '<C-d>zz', opts)
vim.keymap.set('n', '<C-u>', '<C-u>zz', opts)
vim.keymap.set('n', 'n', 'nzzzv', opts)
vim.keymap.set('n', 'N', 'Nzzzv', opts)

-- Resize with arrows
vim.keymap.set('n', '<Up>', ':resize -2<CR>', opts)
vim.keymap.set('n', '<Down>', ':resize +2<CR>', opts)
vim.keymap.set('n', '<Left>', ':vertical resize -2<CR>', opts)
vim.keymap.set('n', '<Right>', ':vertical resize +2<CR>', opts)

-- Navigate between splits
vim.keymap.set('n', '<C-k>', ':wincmd k<CR>', opts)
vim.keymap.set('n', '<C-j>', ':wincmd j<CR>', opts)
vim.keymap.set('n', '<C-h>', ':wincmd h<CR>', opts)
vim.keymap.set('n', '<C-l>', ':wincmd l<CR>', opts)

-- Stay in indent mode
vim.keymap.set('v', '<', '<gv', opts)
vim.keymap.set('v', '>', '>gv', opts)

vim.keymap.set("n", "<leader>rd", function()
  local root = vim.fs.root(0, { ".git" })

  if not root then
    vim.notify("Git root not found", vim.log.levels.ERROR)
    return
  end

  local script = root .. "/run.sh"

  if vim.fn.filereadable(script) == 1 then
    vim.cmd("!" .. vim.fn.shellescape(script))
  else
    vim.notify("run.sh not found: " .. script, vim.log.levels.ERROR)
  end
end, { desc = "Run project" })

------------------------------------------------
-------- Autocmds -------------------------------
------------------------------------------------

vim.api.nvim_create_autocmd("WinEnter", {
    callback = function()
        local current = vim.api.nvim_get_current_win()
        local wins = vim.api.nvim_tabpage_list_wins(0)

        if #wins < 2 then return end

        vim.cmd("wincmd =")

        local target = math.floor(vim.o.columns * 0.5)
        vim.api.nvim_win_set_width(current, target)
    end,
})

------------------------------------------------
-------- Plugins -------------------------------
------------------------------------------------

