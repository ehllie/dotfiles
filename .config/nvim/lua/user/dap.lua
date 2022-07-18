local function setup(dap, dapui, dap_install, dap_python, keymap)
  dap_python.setup("python")

  dap_install.setup({})

  local custom_configs = {}

  for debugger, config in pairs(custom_configs) do
    dap_install.config(debugger, config)
  end

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
    dapui.open()
  end

  dap.listeners.before.event_terminated["dapui_config"] = function()
    dapui.close()
  end

  dap.listeners.before.event_exited["dapui_config"] = function()
    dapui.close()
  end


  keymap("n", "<leader>db", dap.toggle_breakpoint)
  keymap("n", "<leader>dc", dap.continue)
  keymap("n", "<leader>di", dap.step_into)
  keymap("n", "<leader>do", dap.step_over)
  keymap("n", "<leader>dO", dap.step_out)
  keymap("n", "<leader>dr", dap.repl.toggle)
  keymap("n", "<leader>dl", dap.run_last)
  keymap("n", "<leader>du", dapui.toggle)
  keymap("n", "<leader>dt", dap.terminate)
  keymap("n", "<leader>de", dapui.eval)
end

return { deps = { "dap", "dapui", "dap-install", "dap-python", "user.keymaps"}, setup = setup }
