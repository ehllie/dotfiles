local function config()
  vim.opt.runtimepath:append(store.gcc .. "/bin")
  require("nvim-treesitter.configs").setup({
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
  })
end

return {
  "nvim-treesitter/nvim-treesitter",
  config = config,
  requires = { "windwp/nvim-ts-autotag", "nvim-treesitter/nvim-treesitter-textobjects" },
}
