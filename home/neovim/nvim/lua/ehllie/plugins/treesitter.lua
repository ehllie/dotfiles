return {
  "nvim-treesitter/nvim-treesitter",
  main = "nvim-treesitter.configs",
  opts = {
    ensure_installed = "all",
    highlight = {
      enable = true,
    },
    autopairs = {
      enable = true,
    },
    autotag = {
      enable = true,
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
  },
  dependencies = {
    "windwp/nvim-ts-autotag",
    "nvim-treesitter/nvim-treesitter-textobjects",
  },
}
