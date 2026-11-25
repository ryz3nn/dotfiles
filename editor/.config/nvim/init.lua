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

-- Indentation (2 spaces by default; Makefiles keep real tabs via ftplugin)
opt.tabstop = 2
opt.softtabstop = 2
opt.shiftwidth = 2
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

-- UI & splits (sharp borders everywhere)
opt.termguicolors = true
opt.winborder = "single"
opt.signcolumn = "yes"
opt.cursorline = true
-- opt.colorcolumn = "80"
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.wrap = false
opt.splitright = true
opt.splitbelow = true
opt.laststatus = 3 -- Global statusline
opt.showmode = false -- Shown by lualine

-- Behavior & files
opt.mouse = "a"
opt.clipboard = "unnamedplus"
opt.undofile = true
opt.updatetime = 250
opt.timeoutlen = 400
opt.completeopt = { "menu", "menuone", "noselect" }
opt.path:append("**") -- Allow :find and gf to search subdirectories

-- Folding (first level only, no nested folds; files open unfolded)
opt.foldenable = true
opt.foldmethod = "indent"
opt.foldnestmax = 1
opt.foldlevel = 99
opt.foldlevelstart = 99

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

-- Remove empty, unmodified [No Name] buffers once a real file is opened
vim.api.nvim_create_autocmd("BufEnter", {
  group = augroup,
  callback = function(args)
    if
      not vim.bo[args.buf].buflisted
      or vim.bo[args.buf].buftype ~= ""
      or vim.api.nvim_buf_get_name(args.buf) == ""
    then
      return
    end

    vim.schedule(function()
      for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if
          buf ~= args.buf
          and vim.api.nvim_buf_is_valid(buf)
          and vim.bo[buf].buflisted
          and vim.bo[buf].buftype == ""
          and vim.api.nvim_buf_get_name(buf) == ""
          and not vim.bo[buf].modified
          and #vim.fn.win_findbuf(buf) == 0
          and vim.api.nvim_buf_line_count(buf) == 1
          and vim.api.nvim_buf_get_lines(buf, 0, 1, false)[1] == ""
        then
          pcall(vim.api.nvim_buf_delete, buf, { force = false })
        end
      end
    end)
  end,
})

-- When started with a directory (e.g. `nvim path/to/folder`), cd into it
local start_arg = vim.fn.argv(0)
if type(start_arg) == "string" and start_arg ~= "" and vim.fn.isdirectory(start_arg) == 1 then
  pcall(vim.api.nvim_set_current_dir, start_arg)
end

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

-- Force quit
map("n", "<C-q>", "<cmd>q!<CR>", { desc = "Force quit" })

-- Toggle fold with zo
map({ "n", "x" }, "zo", "za", { desc = "Toggle fold" })
map({ "n", "x" }, "<leader>ww", "<cmd>set wrap!<CR>", { desc = "Toggle fold" })

-- Delete to blackhole register (keep clipboard intact)
map({ "n", "v" }, "d", '"_d', { desc = "Delete without yanking" })
map({ "n", "v" }, "D", '"_D', { desc = "Delete to EOL without yanking" })

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

-- Buffers
map("n", "<S-h>", "<cmd>bprevious<CR>", { desc = "Previous buffer" })
map("n", "<S-l>", "<cmd>bnext<CR>", { desc = "Next buffer" })

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
-- 5. DIAGNOSTICS & LSP (CLANGD)
-- ============================================================================
vim.diagnostic.config({
  virtual_text = true,
  severity_sort = true,
  float = { border = "single" },
})

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

-- Attach LSP keymaps when an LSP connects
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
  end,
})

-- ============================================================================
-- 6. PLUGINS
-- ============================================================================
-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local out = vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--branch=stable",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
    }, true, {})
  end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
-- --------------------------------------------------------------------------
-- UI
-- --------------------------------------------------------------------------
  {
    "Mofiqul/vscode.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      -- style = "dark",
      style = "light",
      italic_comments = true,
      disable_nvimtree_bg = true,
    },
    config = function(_, opts)
      require("vscode").setup(opts)
      vim.cmd.colorscheme("vscode")
    end,
  },

  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      options = {
        theme = "auto",
        globalstatus = true,
        -- Sharp separators (no rounded/slant pills)
        section_separators = { left = "", right = "" },
        component_separators = { left = "|", right = "|" },
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch", "diff", "diagnostics" },
        lualine_c = { { "filename", path = 1 } },
        lualine_x = { "encoding", "fileformat", "filetype" },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
    },
  },

  {
    "akinsho/bufferline.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      options = {
        separator_style = "thin", -- Sharp straight dividers
        indicator = { icon = "▎", style = "icon" },
        show_buffer_close_icons = false,
        show_close_icon = false,
        offsets = {
          {
            filetype = "snacks_layout_box",
            text = "FILES",
            text_align = "left",
            separator = true,
          },
        },
      },
    },
  },

-- --------------------------------------------------------------------------
-- SNACKS (EXPLORER, PICKER, INDENT, UTILS)
-- --------------------------------------------------------------------------
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      bigfile = { enabled = true },
      quickfile = { enabled = true },
      explorer = {
        enabled = true,
        replace_netrw = true,
      },
      indent = {
        enabled = true,
        indent = { char = "│" },
        scope = { enabled = true },
        animate = { enabled = false },
      },
      input = { enabled = true },
      notifier = {
        enabled = true,
        timeout = 3000,
      },
      terminal = { enabled = true },
      words = { enabled = true },
      styles = {
        blame_line = { border = "single" },
        float = { border = "single" },
        input = { border = "single" },
        notification = { border = "single" },
        notification_history = { border = "single" },
      },
      picker = {
        ui_select = true,
        layout = {
          cycle = true,
          hidden = { "preview" }, -- Preview off by default (toggle with <F4> or <M-p>)
          preset = function()
            return vim.o.columns >= 120 and "default" or "vertical"
          end,
        },
        win = {
          input = {
            keys = {
              ["<F4>"] = { "toggle_preview", mode = { "n", "i" } },
            },
          },
          list = {
            keys = {
              ["<F4>"] = "toggle_preview",
            },
          },
        },
        sources = {
          files = {
            hidden = true,
            follow = true,
            exclude = { "*.o", "*.out" },
          },
          grep = {
            hidden = true,
            follow = true,
            exclude = { "*.o", "*.out" },
          },
          explorer = {
            layout = {
              layout = {
                position = "right",
                width = 32,
              },
            },
            win = {
              list = {
                wo = {
                  number = true,
                  relativenumber = true,
                },
              },
            },
          },
        },
      },
    },
    keys = {
      -- Explorer & pickers
      { "<leader>e", function() Snacks.explorer() end, desc = "Toggle file explorer" },
      { "<leader>sf", function() Snacks.picker.files() end, desc = "Search files" },
      { "<leader>sg", function() Snacks.picker.grep() end, desc = "Search by grep" },
      { "<leader>sw", function() Snacks.picker.grep_word() end, mode = { "n", "x" }, desc = "Search word or selection" },
      { "<leader>sb", function() Snacks.picker.buffers() end, desc = "Search open buffers" },
      { "<leader>sr", function() Snacks.picker.recent() end, desc = "Search recent files" },
      { "<leader>sd", function() Snacks.picker.diagnostics_buffer() end, desc = "Search buffer diagnostics" },
      { "<leader>sD", function() Snacks.picker.diagnostics() end, desc = "Search workspace diagnostics" },
      { "<leader>ss", function() Snacks.picker.lsp_symbols() end, desc = "Search document symbols" },
      { "<leader>sh", function() Snacks.picker.help() end, desc = "Search help" },
      { "<leader>sR", function() Snacks.picker.resume() end, desc = "Resume last picker" },
      { "<leader>sn", function() Snacks.notifier.show_history() end, desc = "Notification history" },

      -- Helpful utils
      { "<leader>bd", function() Snacks.bufdelete() end, desc = "Close buffer (keep layout)" },
      { "<leader>bo", function() Snacks.bufdelete.other() end, desc = "Close other buffers" },
      { "<leader>gb", function() Snacks.git.blame_line() end, desc = "Git blame line" },
      { "<leader>cR", function() Snacks.rename.rename_file() end, desc = "Rename file (LSP)" },
      { "<leader>un", function() Snacks.notifier.hide() end, desc = "Dismiss notifications" },
      { "<C-/>", function() Snacks.terminal() end, mode = { "n", "t" }, desc = "Toggle terminal" },
      { "<C-_>", function() Snacks.terminal() end, mode = { "n", "t" }, desc = "Toggle terminal" },
      { "]]", function() Snacks.words.jump(vim.v.count1) end, mode = { "n", "t" }, desc = "Next reference" },
      { "[[", function() Snacks.words.jump(-vim.v.count1) end, mode = { "n", "t" }, desc = "Prev reference" },
    },
  },

-- --------------------------------------------------------------------------
-- TREESITTER
-- --------------------------------------------------------------------------
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      local ts = require("nvim-treesitter")
      ts.setup()

      -- Install C/IDE parsers automatically only when CLI + compiler exist
      if vim.fn.executable("tree-sitter") == 1 and (vim.fn.executable("cc") == 1 or vim.fn.executable("gcc") == 1) then
        ts.install({ "c", "cpp", "lua", "bash", "cmake", "make", "markdown" })
      end

      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("UserTreesitter", { clear = true }),
        callback = function(args)
          pcall(vim.treesitter.start, args.buf)
        end,
      })
    end,
  },

-- --------------------------------------------------------------------------
-- COMPLETION & EDITING
-- --------------------------------------------------------------------------
  {
    "saghen/blink.cmp",
    version = "1.*",
    opts = {
      keymap = {
        preset = "default",
        ["<CR>"] = { "accept", "fallback" },
        ["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
        ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
      },
      appearance = {
        nerd_font_variant = "mono",
      },
      completion = {
        menu = {
          border = "single",
        },
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 200,
          window = {
            border = "single",
          },
        },
      },
      signature = {
        enabled = true,
        window = {
          border = "single",
        },
      },
      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
      },
      fuzzy = {
        implementation = "prefer_rust_with_warning",
      },
    },
    config = function(_, opts)
      require("blink.cmp").setup(opts)
      vim.lsp.config("*", {
        capabilities = require("blink.cmp").get_lsp_capabilities(),
      })
    end,
  },

  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {},
  }, 

-- --------------------------------------------------------------------------
-- FORMATTING (CONFORM)
-- --------------------------------------------------------------------------
  {
    "stevearc/conform.nvim",
    cmd = "ConformInfo",
    keys = {
      {
        "<leader>f",
        function()
          require("conform").format({ async = true, lsp_format = "fallback" })
        end,
        mode = { "n", "v" },
        desc = "Format buffer or selection",
      },
    },
    opts = {
      formatters_by_ft = {
        c = { "clang_format" },
        cpp = { "clang_format" },
      },
      default_format_opts = {
        lsp_format = "fallback",
      },
    },
  },

-- --------------------------------------------------------------------------
-- DEBUGGING (DAP + DAP-VIEW)
-- --------------------------------------------------------------------------
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      {
        "igorlfs/nvim-dap-view",
        cmd = { "DapViewOpen", "DapViewClose", "DapViewToggle", "DapViewWatch" },
        opts = {
          winbar = {
            show = true,
            controls = { enabled = true },
          },
          windows = {
            size = 0.25,
            position = "below",
          },
          help = { border = "single" },
          hover = { border = "single" },
          virtual_text = { enabled = true },
          auto_toggle = true,
        },
      },
    },
    keys = {
      { "<F5>", function() require("dap").continue() end, desc = "Debug: Start/Continue" },
      { "<F9>", function() require("dap").toggle_breakpoint() end, desc = "Debug: Toggle breakpoint" },
      { "<F10>", function() require("dap").step_over() end, desc = "Debug: Step over" },
      { "<F11>", function() require("dap").step_into() end, desc = "Debug: Step into" },
      { "<F12>", function() require("dap").step_out() end, desc = "Debug: Step out" },
      { "<leader>Db", function() require("dap").toggle_breakpoint() end, desc = "Toggle breakpoint" },
      { "<leader>DB", function() require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: ")) end, desc = "Conditional breakpoint" },
      { "<leader>Dc", function() require("dap").continue() end, desc = "Continue / Start debug" },
      { "<leader>Dt", function() require("dap").terminate() end, desc = "Terminate debug" },
      { "<leader>Dr", function() require("dap").repl.toggle() end, desc = "Toggle debug REPL" },
      { "<leader>Dv", "<cmd>DapViewToggle<CR>", desc = "Toggle DAP view" },
      { "<leader>Dw", "<cmd>DapViewWatch<CR>", desc = "Add expression to DAP watch" },
    },
    config = function()
      local dap = require("dap")

      vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DiagnosticError" })
      vim.fn.sign_define("DapBreakpointCondition", { text = "◆", texthl = "DiagnosticWarn" })
      vim.fn.sign_define("DapBreakpointRejected", { text = "○", texthl = "DiagnosticHint" })
      vim.fn.sign_define("DapStopped", { text = "▶", texthl = "DiagnosticInfo", linehl = "CursorLine" })

      dap.adapters.lldb = {
        type = "executable",
        command = "lldb-dap",
        name = "lldb",
      }

      dap.configurations.c = {
        {
          name = "Launch executable (lldb-dap)",
          type = "lldb",
          request = "launch",
          program = function()
            return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
          end,
          cwd = "${workspaceFolder}",
          stopOnEntry = false,
          args = {},
        },
        {
          name = "Attach to process (lldb-dap)",
          type = "lldb",
          request = "attach",
          pid = require("dap.utils").pick_process,
          cwd = "${workspaceFolder}",
        },
      }
      dap.configurations.cpp = dap.configurations.c
    end,
  },
}, {
  ui = {
    border = "single", -- Sharp border for lazy.nvim window
  },
  change_detection = {
    notify = false,
  },
})
