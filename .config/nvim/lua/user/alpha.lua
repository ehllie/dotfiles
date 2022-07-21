local function config()
  local dashboard = require("alpha.themes.dashboard")
  dashboard.section.header.val = {
    [[                               __                ]],
    [[  ___     ___    ___   __  __ /\_\    ___ ___    ]],
    [[ / _ `\  / __`\ / __`\/\ \/\ \\/\ \  / __` __`\  ]],
    [[/\ \/\ \/\  __//\ \_\ \ \ \_/ |\ \ \/\ \/\ \/\ \ ]],
    [[\ \_\ \_\ \____\ \____/\ \___/  \ \_\ \_\ \_\ \_\]],
    [[ \/_/\/_/\/____/\/___/  \/__/    \/_/\/_/\/_/\/_/]],
  }

  dashboard.section.buttons.val = {
    dashboard.button("f", " " .. " Find file", ":Telescope find_files <CR>"),
    dashboard.button("e", " " .. " New file", ":ene <BAR> startinsert <CR>"),
    dashboard.button("p", " " .. " Find project", ":lua require('telescope').extensions.projects.projects()<CR>"),
    dashboard.button("r", " " .. " Recent files", ":Telescope oldfiles <CR>"),
    dashboard.button("t", " " .. " Find text", ":Telescope live_grep <CR>"),
    dashboard.button("c", " " .. " Config", ":e " .. vim.fn.stdpath("config") .. " <CR>"),
    dashboard.button("z", " " .. " Config zsh", ":e " .. vim.fn.stdpath("config") .. "/../zsh <CR>"),
    dashboard.button("p", "勒 " .. " Update plugins", ":PackerSync<CR>"),
    dashboard.button("q", " " .. " Quit", ":qa<CR>"),
  }
  local function footer()
    local plugin_count = 0
    for _, _ in pairs(packer_plugins) do
      plugin_count = plugin_count + 1
    end
    return string.format("%d plugins installed\nNeovim is pretty cool actually", plugin_count)
  end

  dashboard.section.footer.val = footer()

  dashboard.section.footer.opts.hl = "Type"
  dashboard.section.header.opts.hl = "Include"
  dashboard.section.buttons.opts.hl = "Keyword"

  dashboard.opts.opts.noautocmd = true
  require("alpha").setup(dashboard.opts)
end
-- "goolord/alpha-nvim"
return { "goolord/alpha-nvim", config = config }

-- Lua Diagnostics.: This function requires 4 argument(s) but instead it is receiving 3.
