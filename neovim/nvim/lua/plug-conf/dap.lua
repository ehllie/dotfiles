local function config_dapui()
  local utils = require("utils")
  local dap = require("dap")
  local dapui = require("dapui")
  local register = require("which-key").register
  local ui_funcs = require("utils").right_ui
  local vsdap = require("dap.ext.vscode")

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
    expand_lines = true,
    layouts = {
      {
        elements = {
          {
            id = "scopes",
            size = 0.4, -- Can be float or integer > 1
          },
          {
            id = "stacks",
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
          {
            id = "watches",
            size = 0.4,
          },
          {
            id = "console",
            size = 0.6,
          },
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

  ui_funcs.register("dapui", function()
    dapui.open({})
  end, function()
    dapui.close({})
  end)

  local function toggle()
    ui_funcs.toggle("dapui")
  end

  dap.listeners.after.event_initialized["dapui_config"] = function()
    ui_funcs.temp_open("dapui")
  end

  dap.listeners.before.event_terminated["dapui_config"] = function()
    ui_funcs.restore()
  end

  dap.listeners.before.event_exited["dapui_config"] = function()
    ui_funcs.restore()
  end

  local winsize = 0.8

  vim.api.nvim_create_user_command("FloatRepl", function()
    utils.floating_win({ ratio = winsize })
  end, {})

  register({
    d = {
      name = "Debug",
      b = { dap.toggle_breakpoint, "Toggle breakpoint" },
      c = { dap.continue, "Continue" },
      i = { dap.step_into, "Step into" },
      o = { dap.step_over, "Step over" },
      O = { dap.step_out, "Step out" },
      r = {
        function()
          dap.repl.toggle(utils.ui_dim_fraction(winsize), "FloatRepl")
          vim.cmd("wincmd p")
        end,
        "Toggle repl",
      },
      l = { dap.run_last, "Run last" },
      j = { vsdap.load_launchjs, "Load launch.js configurations" },
      u = { toggle, "Toggle UI" },
      t = { dap.terminate, "Terminate" },
      e = { dapui.eval, "Evaluate variable" },
    },
  }, { prefix = "<leader>" })
end

return {
  {
    "rcarriga/nvim-dap-ui",
    config = config_dapui,
    requires = { "mfussenegger/nvim-dap", "folke/which-key.nvim" },
  },
  {
    "mfussenegger/nvim-dap-python",
    config = function()
      local register = require("which-key").register
      local dappy = require("dap-python")
      register({
        p = { dappy.test_method, "Test python method" },
      }, { prefix = "<leader>d" })
      dappy.setup("python")
      dappy.test_runner = "pytest"
    end,
    requires = "mfussenegger/nvim-dap",
  },
}
