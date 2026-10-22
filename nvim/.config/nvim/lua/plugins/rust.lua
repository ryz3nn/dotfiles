-- Cargo helpers for Neovim (no Rust Analyzer required)
local function project_root()
  return vim.fs.root(0, { "Cargo.toml" }) or vim.fn.getcwd()
end

-- Run cargo check / clippy and populate quickfix
local function cargo_diagnostics(command)
  vim.cmd("write")

  local root = project_root()
  local title = "cargo " .. command
  local output = vim.fn.systemlist(
    "cd " .. vim.fn.shellescape(root)
    .. " && cargo " .. command
    .. " --message-format=short 2>&1"
  )

  local items = {}

  for _, line in ipairs(output) do
    local file, lnum, col, severity, message =
      line:match("^([^:]+):(%d+):(%d+): (%w+): (.*)")

    if file and (severity == "error" or severity == "warning") then
      table.insert(items, {
        filename = root .. "/" .. file,
        lnum = tonumber(lnum),
        col = tonumber(col),
        text = severity .. ": " .. message,
        type = severity == "error" and "E" or "W",
      })
    end
  end

  vim.fn.setqflist({}, "r", {
    title = title,
    items = items,
  })

  vim.cmd("copen")

  local status = vim.v.shell_error
  if status == 0 then
    print(title .. ": passed")
  elseif #items == 0 then
    print(title .. ": failed; see command output")
    vim.notify(table.concat(output, "\n"), vim.log.levels.ERROR)
  else
    print(title .. ": " .. #items .. " diagnostic(s)")
  end
end

-- Run interactive Cargo commands in a terminal split
local function cargo_terminal(command, close_on_clean_exit)
  vim.cmd("write")
  vim.cmd("botright 12new")

  local win = vim.api.nvim_get_current_win()
  local buf = vim.api.nvim_get_current_buf()

  -- Default to closing automatically unless specified otherwise
  if close_on_clean_exit == nil then
    close_on_clean_exit = true
  end

  vim.fn.termopen({ "cargo", command }, {
    cwd = project_root(),
    on_exit = function(_, exit_code)
      -- If close_on_clean_exit is true, only close if status code is 0
      -- so you can still read errors/panics if the program crashes.
      if not close_on_clean_exit or exit_code == 0 then
        vim.schedule(function()
          if vim.api.nvim_win_is_valid(win) then
            vim.api.nvim_win_close(win, true)
          end
          if vim.api.nvim_buf_is_valid(buf) then
            vim.api.nvim_buf_delete(buf, { force = true })
          end
        end)
      end
    end,
  })

  vim.cmd("startinsert")
end

-- Format project
local function cargo_fmt()
  vim.cmd("write")

  local output = vim.fn.systemlist(
    "cd " .. vim.fn.shellescape(project_root())
    .. " && cargo fmt 2>&1"
  )

  if vim.v.shell_error == 0 then
    print("cargo fmt: done")
  else
    vim.notify(table.concat(output, "\n"), vim.log.levels.ERROR)
  end
end

-- Attach Cargo keymaps to Rust buffers without depending on rust-analyzer
vim.api.nvim_create_autocmd("FileType", {
  pattern = "rust",
  callback = function(args)
    local function map(lhs, rhs, desc)
      vim.keymap.set("n", lhs, rhs, { buffer = args.buf, silent = true, desc = desc })
    end

    -- Build / diagnostics
    map("<leader>cc", function() cargo_diagnostics("check") end, "Cargo check → quickfix")
    map("<leader>cl", function() cargo_diagnostics("clippy") end, "Cargo clippy → quickfix")
    map("<leader>cb", function() cargo_terminal("build") end, "Cargo build")

    -- Run / test
    map("<leader>cr", function() cargo_terminal("run") end, "Cargo run")
    map("<leader>ct", function() cargo_terminal("test") end, "Cargo test")
    map("<leader>cT", function() cargo_terminal("test") end, "Cargo test")

    -- Formatting
    map("<leader>cf", cargo_fmt, "Cargo fmt")
  end,
})
return {
  {
    "mrcjkb/rustaceanvim",
    version = "^5",
    ft = { "rust" },
    init = function()
      vim.g.rustaceanvim = {
        tools = {
          -- Inlay hint and hover styling
          hover_actions = {
            auto_focus = true,
          },
        },
        server = {
          on_attach = function(_, bufnr)
            local opts = { buffer = bufnr, silent = true }

            -- Standard LSP keymaps
            vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
            vim.keymap.set("n", "gI", vim.lsp.buf.implementation, opts)
            vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)

            -- Rustaceanvim-specific commands
            vim.keymap.set("n", "K", function()
              vim.cmd.RustLsp({ "hover", "actions" })
            end, opts)
            vim.keymap.set("n", "<leader>ca", function()
              vim.cmd.RustLsp("codeAction")
            end, opts)
            vim.keymap.set("n", "<leader>em", function()
              vim.cmd.RustLsp("expandMacro")
            end, opts)
            vim.keymap.set("n", "<leader>oc", function()
              vim.cmd.RustLsp("openCargo")
            end, opts)
          end,
          default_settings = {
            ["rust-analyzer"] = {
              lru = {
      capacity = 256, -- Default is often 1024 or higher
    },
              cargo = {
                allFeatures = true,
                loadOutDirsFromCheck = true,
                runBuildScripts = true,
              },
              -- Run Clippy on save instead of default cargo check
              checkOnSave = true,
              check = {
                command = "clippy",
                extraArgs = { "--no-deps" },
              },
              procMacro = {
                enable = true,
              },
            },
          },
        },
      }
    end,
  },
}
