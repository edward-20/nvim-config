return {
  -- dap
  {
    "mfussenegger/nvim-dap",
    config = function()
      -- config required
      local dap = require("dap")
      dap.adapters.codelldb = {
        type = "executable",
        command = vim.fn.stdpath("data") .. "/mason/packages/codelldb/extension/adapter/codelldb",
      }
      dap.set_log_level("TRACE")
    end
  },
  {
    "jay-babu/mason-nvim-dap.nvim", -- closes the gap between mason.nvim and nvim-dap plugin
    dependencies = {
      "williamboman/mason.nvim",
      "mfussenegger/nvim-dap"
    },
  },
  {
    "rcarriga/nvim-dap-ui",
    dependencies = {
      "mfussenegger/nvim-dap",
      "nvim-neotest/nvim-nio"
    },
    event = "VeryLazy",
    config = function()
      require("lazydev").setup({
        library = { "nvim-dap-ui" },
      })
      local dap = require("dap")
      local dapui = require("dapui")

      dapui.setup()

      -- Auto open UI when debugging starts, close when it ends
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end

      -- Key mappings
      vim.keymap.set("n", "<F5>", dap.continue, { desc = "Start/Continue Debugger" })
      vim.keymap.set("n", "<F10>", dap.step_over, { desc = "Step Over" })
      vim.keymap.set("n", "<F11>", dap.step_into, { desc = "Step Into" })
      vim.keymap.set("n", "<F12>", dap.step_out, { desc = "Step Out" })
      vim.keymap.set("n", "<Leader>b", dap.toggle_breakpoint, { desc = "Toggle Breakpoint" })
      vim.keymap.set("n", "<Leader>B", function()
        dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
      end, { desc = "Set Conditional Breakpoint" })
      vim.keymap.set("n", "<Leader>du", require("dapui").toggle, { desc = "Toggle DAP UI" })

    end
  },
}
