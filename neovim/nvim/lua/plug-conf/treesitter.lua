local function config()
  vim.opt.runtimepath:append("@parsers@")
  require("nvim-treesitter.configs").setup({
    ensure_installed = {}, -- Installing parsers with nix
    parser_install_dir = "@parsers@",
    highlight = {
      enable = true,
    },
    autopairs = {
      enable = true,
    },
    autotag = {
      enable = true,
    },
    rainbow = {
      enable = true,
      extended_mode = true,
      max_file_lines = nil,
    },
    indent = { enable = true, disable = { "python", "css" } },
    textobjects = {
      select = {
        enable = true,
        lookahead = true,
        keymaps = {
          ["af"] = "@function.outer",
          ["if"] = "@function.inner",
          ["ac"] = "@class.outer",
          ["ic"] = "@class.inner",
          ["aa"] = "@parameter.outer",
          ["ia"] = "@parameter.inner",
        },
      },
      swap = {
        enable = true,
        swap_next = {
          ["<leader>a"] = "@parameter.inner",
        },
        swap_previous = {
          ["<leader>A"] = "@parameter.inner",
        },
      },
    },
  })
end

return {
  "nvim-treesitter/nvim-treesitter",
  config = config,
  requires = { "windwp/nvim-ts-autotag", "p00f/nvim-ts-rainbow", "nvim-treesitter/nvim-treesitter-textobjects" },
}
