local function config_dapui()
  local dap = require("dap")
  local dapui = require("dapui")

  dapui.setup({
    icons = { expanded = "▾", collapsed = "▸" },
    mappings = {
      expand = { "h", "l", "<2-LeftMouse>" },
      open = "o",
      remove = "d",
      edit = "c",
      repl = "r",
      toggle = "t",
    },
    expand_lines = vim.fn.has("nvim-0.7"),
    layouts = {
      {
        elements = {
          {
            id = "scopes",
            size = 0.4, -- Can be float or integer > 1
          },
          {
            id = "watches",
            size = 0.3,
          },
          {
            id = "breakpoints",
            size = 0.3,
          },
        },
        size = 40,
        position = "right", -- Can be "left", "right", "top", "bottom"
      },
      {
        elements = {
          "repl",
          "console",
        },
        size = 0.2,
        position = "bottom",
      },
    },
    floating = {
      max_height = nil,
      max_width = nil,
      border = "rounded",
      mappings = {
        close = { "q", "<Esc>" },
      },
    },
  })

  vim.fn.sign_define("DapBreakpoint", {
    text = "",
    texthl = "DiagnosticSignError",
    linehl = "",
    numhl = "",
  })

  dap.listeners.after.event_initialized["dapui_config"] = function()
    dapui.open({})
  end

  dap.listeners.before.event_terminated["dapui_config"] = function()
    dapui.close({})
  end

  dap.listeners.before.event_exited["dapui_config"] = function()
    dapui.close({})
  end

  plugin_keybinds.dap = {
    mappings = {
      d = {
        name = "Debug",
        b = { dap.toggle_breakpoint, "Toggle breakpoint" },
        c = { dap.continue, "Continue" },
        i = { dap.step_into, "Step into" },
        o = { dap.step_over, "Step over" },
        O = { dap.step_out, "Step out" },
        r = { dap.repl.toggle, "Toggle repl" },
        l = { dap.run_last, "Run last" },
        u = { dapui.toggle, "Toggle UI" },
        t = { dap.terminate, "Terminate" },
        e = { dapui.eval, "Evaluate variable" },
      },
    },
    opts = { prefix = "<leader>" },
  }
end

return {
  {
    "rcarriga/nvim-dap-ui",
    config = config_dapui,
    requires = "mfussenegger/nvim-dap",
  },
  {
    "mfussenegger/nvim-dap-python",
    config = function()
      require("dap-python").setup("python")
    end,
    requires = "mfussenegger/nvim-dap",
  },
  {
    "ravenxrz/DAPInstall.nvim",
    config = function()
      local dap_install = require("dap-install")
      dap_install.setup({})

      local custom_configs = {}

      for debugger, config in pairs(custom_configs) do
        dap_install.config(debugger, config)
      end
    end,
    requires = "mfussenegger/nvim-dap",
  },
}
