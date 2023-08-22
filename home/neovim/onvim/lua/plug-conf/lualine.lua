local function config()
  local lsp_status = require("lsp-status")

  local function hide_in_width()
    return vim.fn.winwidth(0) > 80
  end

  local function diff_source()
    local gitsigns = vim.b.gitsigns_status_dict
    if gitsigns then
      return {
        added = gitsigns.added,
        modified = gitsigns.changed,
        removed = gitsigns.removed,
      }
    end
  end

  local diagnostics = {
    "diagnostics",
    sources = { "nvim_diagnostic" },
    sections = { "error", "warn" },
    symbols = { error = " ", warn = " " },
    always_visible = true,
  }

  local function macro_recording()
    local recording_register = vim.fn.reg_recording()
    if recording_register == "" then
      return ""
    else
      return "Recording @" .. recording_register
    end
  end

  local function progress()
    return #vim.lsp.get_active_clients() > 0 and lsp_status.status_progress() or ""
  end

  local diff = {
    "diff",
    symbols = { added = " ", modified = " ", removed = " " }, -- changes diff symbols
    cond = hide_in_width,
    source = diff_source,
  }

  local filetype = {
    "filetype",
    icons_enabled = false,
  }

  local location = {
    "location",
    padding = 0,
  }

  local spaces = function()
    return "spaces: " .. vim.api.nvim_buf_get_option(0, "shiftwidth")
  end

  require("lualine").setup({
    options = {
      globalstatus = true,
      icons_enabled = true,
      theme = "auto",
      component_separators = { left = "", right = "" },
      disabled_filetypes = { "alpha", "dashboard" },
      always_divide_middle = true,
    },
    sections = {
      lualine_a = { "mode" },
      lualine_b = { { "b:gitsigns_head", icon = "" } },
      lualine_c = { macro_recording, diagnostics, progress },
      lualine_x = { diff, spaces, "encoding", filetype },
      lualine_y = { location },
      lualine_z = { "progress" },
    },
  })
end

return {
  "nvim-lualine/lualine.nvim",
  config = config,
  requires = { "lewis6991/gitsigns.nvim", "nvim-lua/lsp-status.nvim" },
}
