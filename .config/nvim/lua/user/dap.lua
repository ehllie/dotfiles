local function setup(dap, dapui, dap_install, dap_python)
  dap_python.setup("python")

  dap_install.setup({})

  local custom_configs = {}

  for debugger, config in pairs(custom_configs) do
    dap_install.config(debugger, config)
  end

  dapui.setup({
    layouts = {
      {
        elements = {
          {
            id = "scopes",
            size = 0.25, -- Can be float or integer > 1
          },
          { id = "breakpoints", size = 0.25 },
        },
        size = 40,
        position = "right", -- Can be "left", "right", "top", "bottom"
      },
    },
  })

  vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "DiagnosticSignError", linehl = "", numhl = "" })

  dap.listeners.after.event_initialized["dapui_config"] = function()
    dapui.open()
  end

  dap.listeners.before.event_terminated["dapui_config"] = function()
    dapui.close()
  end

  dap.listeners.before.event_exited["dapui_config"] = function()
    dapui.close()
  end
end

return { deps = { "dap", "dapui", "dap-install", "dap-python" }, setup = setup }
