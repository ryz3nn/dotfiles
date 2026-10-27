return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "igorlfs/nvim-dap-view",
    },
    config = function()
      local dap = require("dap")
      local dap_view = require("dap-view")

      dap_view.setup({
        auto_toggle = true,
         
        windows = {
          size = 50,
          position = "right",
        },
      })

      -- CodeLLDB adapter (Rust, C, C++)
      dap.adapters.lldb = {
        type = "executable",
        command = "lldb-dap",
        name = "lldb",
      }

      -- Rust
      dap.configurations.rust = {
        {
          name = "Launch Rust program",
          type = "codelldb",
          request = "launch",
          program = function()
            vim.fn.jobstart("cargo build")
            return vim.fn.input(
              "Executable path: ",
              vim.fn.getcwd() .. "/target/debug/",
              "file"
            )
          end,
          cwd = "${workspaceFolder}",
          stopOnEntry = false,
        },
      }

      -- C and C++
      local cpp_config = {
        {
          name = "Launch C/C++ executable",
          type = "lldb",
          request = "launch",
          program = function()
            return vim.fn.input(
              "Executable path: ",
              vim.fn.getcwd() .. "/build/",
              "file"
            )
          end,
          cwd = "${workspaceFolder}",
          stopOnEntry = false,
        },
      }

      dap.configurations.c = cpp_config
      dap.configurations.cpp = cpp_config

      -- Debug keymaps
      vim.keymap.set("n", "<F5>", dap.continue)
      vim.keymap.set("n", "<F10>", dap.step_over)
      vim.keymap.set("n", "<F11>", dap.step_into)
      vim.keymap.set("n", "<F12>", dap.step_out)
      vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint)

      -- DAP View
      vim.keymap.set("n", "<leader>du", function()
        dap_view.toggle()
      end, {
        desc = "Debug: Toggle view",
      })

      vim.keymap.set("n", "<leader>de", function()
        dap_view.add_expr()
      end, {
        desc = "Debug: Add watch expression",
      })
    end,
  },
}
