return {
  "nvim-treesitter/nvim-treesitter",
  config = function(_, opts)
    local file_path = vim.fn.stdpath("state") .. "/prev_gcc"
    local prev_gcc = ""
    local file = io.open(file_path, "r")
    if file then
      prev_gcc = file:read("*a")
      file:close()
    end
    if prev_gcc ~= store.gcc then
      vim.cmd("TSUninstall all")
      file = io.open(file_path, "w")
      if file then
        file:write(store.gcc)
        file:close()
      else
        print("Could not open file: " .. file_path)
      end
    end

    require("nvim-treesitter.install").compilers = { store.gcc .. "/bin/gcc" }

    require("nvim-treesitter.configs").setup(opts)
  end,
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
