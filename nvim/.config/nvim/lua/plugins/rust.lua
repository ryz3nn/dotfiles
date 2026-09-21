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
