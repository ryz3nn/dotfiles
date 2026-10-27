return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "rcarriga/nvim-dap-ui",
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")
      dapui.setup({
        layouts = {
          {
            elements = {
              -- Move "scopes" to the top of the list
              { id = "scopes", size = 0.25 },
              { id = "breakpoints", size = 0.25 },
              { id = "stacks", size = 0.25 },
              { id = "watches", size = 0.25 }, -- or remove "watches" here if you don't want it at all
            },
            size = 40, -- 40 columns wide (adjust as needed)
            position = "left",
          },
          {
            elements = {
              { id = "repl", size = 0.5 },
              { id = "console", size = 0.5 },
            },
            size = 10, -- 10 lines tall
            position = "bottom",
          },
        },
      })

      -- DAP UI listeners
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end

      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end

      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end

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
      vim.keymap.set("n", "<leader>du", dapui.toggle)

      -- Evaluate expression under cursor or selected expression
      vim.keymap.set({ "n", "v" }, "<leader>de", function()
        dapui.eval()
      end, { desc = "Evaluate expression" })
    end,
  },
}
