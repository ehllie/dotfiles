return {
  "goolord/alpha-nvim",
  config = function()
    local dashboard = require("alpha.themes.dashboard")
    local fortune = require("alpha.fortune")
    local center = require("ehllie.utils").center
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
      dashboard.button("u", " " .. " Update plugins", ":Lazy<CR>"),
      dashboard.button("q", " " .. " Quit", ":qa<CR>"),
    }

    local function footer()
      local width = 64
      local plugin_count = require("lazy").stats().count
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
  end,
}
