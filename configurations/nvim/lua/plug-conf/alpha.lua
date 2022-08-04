local function config()
  local dashboard = require("alpha.themes.dashboard")
  local fortune = require("alpha.fortune")
  local center = require("local-lib").center
  dashboard.section.header.val = {
    [[  ` : | | | |:  ||  :     `  :  |  |+|: | : : :|   .        `              .]],
    [[      ` : | :|  ||  |:  :    `  |  | :| : | : |:   |  .                    :]],
    [[         .' ':  ||  |:  |  '       ` || | : | |: : |   .  `           .   :.]],
    [[                `'  ||  |  ' |   *    ` : | | :| |*|  :   :               :|]],
    [[        *    *       `  |  : :  |  .      ` ' :| | :| . : :         *   :.||]],
    [[             .`            | |  |  : .:|       ` | || | : |: |          | ||]],
    [[      '          .         + `  |  :  .: .         '| | : :| :    .   |:| ||]],
    [[         .                 .    ` *|  || :       `    | | :| | :      |:| |]],
    [[ .                .          .        || |.: *          | || : :     :|||]],
    [[        .            .   . *    .   .  ` |||.  +        + '| |||  .  ||`]],
    [[     .             *              .     +:`|!             . ||||  :.||`]],
    [[ +                      .                ..!|*          . | :`||+ |||`]],
    [[     .                         +      : |||`        .| :| | | |.| ||`     .]],
    [[       *     +   '               +  :|| |`     :.+. || || | |:`|| `]],
    [[                            .      .||` .    ..|| | |: '` `| | |`  +]],
    [[  .       +++                      ||        !|!: `       :| |]],
    [[              +         .      .    | .      `|||.:      .||    .      .    `]],
    [[          '                           `|.   .  `:|||   + ||'     `]],
    [[  __    +      *                         `'       `'|.    `:]],
    [["'  `---"""----....____,..^---`^``----.,.___          `.    `.  .    ____,.,-]],
    [[    ___,--'""`---"'   ^  ^ ^        ^       """'---,..___ __,..---""']],
    [[--"'                           ^                         ``--..,__]],
  }

  dashboard.section.buttons.val = {
    dashboard.button("f", " " .. " Find file", ":Telescope find_files <CR>"),
    dashboard.button("p", " " .. " Find project", ":lua require('telescope').extensions.projects.projects()<CR>"),
    dashboard.button("r", " " .. " Recent files", ":Telescope oldfiles <CR>"),
    dashboard.button("t", " " .. " Find text", ":Telescope live_grep <CR>"),
    dashboard.button("c", " " .. " Config", ":e " .. vim.fn.stdpath("config") .. " <CR>"),
    dashboard.button("z", " " .. " Config zsh", ":e " .. vim.fn.stdpath("config") .. "/../zsh <CR>"),
    dashboard.button("u", " " .. " Update plugins", ":PackerSync<CR>"),
    dashboard.button("q", " " .. " Quit", ":qa<CR>"),
  }

  local function footer()
    local width = 64
    local plugin_count = 0
    for _, _ in pairs(packer_plugins) do
      plugin_count = plugin_count + 1
    end
    return center(vim.tbl_flatten({
      center({
        "",
        string.format("%d plugins installed", plugin_count),
        "Neovim is pretty cool actually",
        "",
        "",
      }, width),
      fortune(width),
    }))
  end

  dashboard.section.footer.val = footer()

  dashboard.section.footer.opts.hl = "Identifier"
  dashboard.section.header.opts.hl = "Type"
  dashboard.section.buttons.opts.hl = "Keyword"

  dashboard.opts.opts.noautocmd = true
  require("alpha").setup(dashboard.opts)
end
-- "goolord/alpha-nvim"
return { "goolord/alpha-nvim", config = config }

-- Lua Diagnostics.: This function requires 4 argument(s) but instead it is receiving 3.
