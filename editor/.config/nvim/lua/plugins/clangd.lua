return {
  {
    "neovim/nvim-lspconfig",
    ft = { "c", "cpp", "objc", "objcpp" },
    config = function()
      vim.lsp.config("clangd", {
        cmd = {
          "clangd",
          "--background-index",
          "--clang-tidy",
          "--completion-style=detailed",
          "--header-insertion=iwyu",
        },

        on_attach = function(_, bufnr)
          local opts = { buffer = bufnr, silent = true }

          -- Standard LSP keymaps
          vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
          vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
          vim.keymap.set("n", "gI", vim.lsp.buf.implementation, opts)
          vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
          vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)

          -- Hover documentation
          vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)

          -- Code actions
          vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)

          -- Diagnostics
          vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, opts)
          vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
          vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)

          -- Format current buffer
          vim.keymap.set("n", "<leader>f", function()
            vim.lsp.buf.format({ bufnr = bufnr })
          end, opts)
        end,
      })

      vim.lsp.enable("clangd")
    end,
  },
}
