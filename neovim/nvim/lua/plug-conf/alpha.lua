local function config()
  local dashboard = require("alpha.themes.dashboard")
  local fortune = require("alpha.fortune")
  local center = require("utils").center
  local header = {
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

  local buttons = {
    dashboard.button("f", " " .. " Find file", ":Telescope find_files <CR>"),
    dashboard.button("p", " " .. " Find project", ":lua require('telescope').extensions.projects.projects()<CR>"),
    dashboard.button("r", " " .. " Recent files", ":Telescope oldfiles <CR>"),
    dashboard.button("t", " " .. " Find text", ":Telescope live_grep <CR>"),
    dashboard.button("u", " " .. " Update plugins", ":PackerSync<CR>"),
    dashboard.button("q", " " .. " Quit", ":qa<CR>"),
  }

  local function footer()
    local width = 64
    local plugin_count = 0
    ---@diagnostic disable-next-line
    for _, _ in pairs(packer_plugins) do
      plugin_count = plugin_count + 1
    end
    return center(vim.tbl_flatten({
      center({
        "",
        ("%d plugins installed"):format(plugin_count),
        "Neovim is pretty cool actually",
        "",
        "",
      }, width),
      fortune(width),
    }))
  end

  dashboard.section.header.val = header
  dashboard.section.header.opts.hl = "Operator"
  dashboard.section.buttons.val = buttons
  dashboard.section.buttons.opts.hl = "Keyword"
  dashboard.section.footer.val = footer()
  dashboard.section.footer.opts.hl = "Special"

  dashboard.opts.opts.noautocmd = true
  require("alpha").setup(dashboard.opts)
end
-- "goolord/alpha-nvim"
return { "goolord/alpha-nvim", config = config }
