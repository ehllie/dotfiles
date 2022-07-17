local function setup(lualine)
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
    colored = false,
    always_visible = true,
  }

  local diff = {
    "diff",
    colored = false,
    symbols = { added = "", modified = "", removed = "" }, -- changes diff symbols
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

  lualine.setup({
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
      lualine_c = { diagnostics },
      lualine_x = { diff, spaces, "encoding", filetype },
      lualine_y = { location },
      lualine_z = { "progress" },
    },
  })
end

return { deps = "lualine", setup = setup }
