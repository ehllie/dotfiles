local function config()
  local dashboard = require("alpha.themes.dashboard")
  local fortune = require("alpha.fortune")
  local align = require("plenary.strings").align_str
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

  ---@generic T
  ---@param str `T`
  ---@return `T`
  local function id(str)
    return str
  end

  ---@param vals table
  ---@return fun(str: string): string)
  local function format(vals)
    ---@param str string
    return function(str)
      return string.format(str, unpack(vals))
    end
  end

  ---@generic R
  ---@param funcs table<fun(arg: `T`): `R`>
  ---@param args table<`T`>
  ---@return table<`R`>
  local function zip_map(funcs, args)
    local results = {}
    for i, func in ipairs(funcs) do
      results[i] = func(args[i])
    end
    return results
  end

  ---@param lines table<string>
  ---@param min_width integer?
  ---@return table<string>
  local function center(lines, min_width)
    local max_len = min_width or 0
    for _, line in ipairs(lines) do
      max_len = math.max(max_len, #line)
    end
    local result = {}
    for _, line in ipairs(lines) do
      local diff = max_len - #line
      local left_pad = math.floor(diff / 2)
      result[#result + 1] = align((align(line, #line + left_pad)), max_len, true)
    end
    return result
  end

  local function footer()
    local width = 54
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

  dashboard.section.footer.opts.hl = "Type"
  dashboard.section.header.opts.hl = "Include"
  dashboard.section.buttons.opts.hl = "Identifier"

  dashboard.opts.opts.noautocmd = true
  require("alpha").setup(dashboard.opts)
end
-- "goolord/alpha-nvim"
return { "goolord/alpha-nvim", config = config }

-- Lua Diagnostics.: This function requires 4 argument(s) but instead it is receiving 3.
