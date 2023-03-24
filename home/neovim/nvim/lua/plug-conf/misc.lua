-- Setup for minor plugins

return {
  "kyazdani42/nvim-web-devicons",
  "moll/vim-bbye",
  "nvim-lua/plenary.nvim", -- Useful lua functions used by lots of plugins
  {
    "AndrewRadev/bufferize.vim",
    config = function()
      require("which-key").register({ ["<leader>Bm"] = { "<cmd>Bufferize messages<cr>", "Bufferize" } }, { mode = "n" })
    end,
    requires = "folke/which-key.nvim",
  },
  {
    "lambdalisue/suda.vim",
    config = function()
      require("which-key").register({ ["w!!"] = { "SudaWrite", "Write as superuser" } }, { mode = "c" })
    end,
    requires = "folke/which-key.nvim",
  },
  {
    "norcalli/nvim-colorizer.lua",
    config = function()
      require("colorizer").setup({
        "css",
        "html",
        "javascript",
        "lua",
        "typescript",
        "vue",
      })
    end,
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    config = function()
      require("indent_blankline").setup({
        char = "▏",
        show_trailing_blankline_indent = false,
        show_first_indent_level = true,
        use_treesitter = true,
        show_current_context = true,
        buftype_exclude = { "terminal", "nofile" },
        filetype_exclude = {
          "NvimTree",
          "help",
          "packer",
        },
      })
    end,
  },
  {
    "lewis6991/impatient.nvim",
    config = function()
      require("impatient").enable_profile()
    end,
  },
  {
    "RRethy/vim-illuminate",
    config = function()
      local illuminate = require("illuminate")
      illuminate.configure({
        filetypes_denylist = { "alpha", "NvimTree" },
        under_cursor = false,
      })
      require("which-key").register({
        ["<a-n>"] = { illuminate.goto_next_reference, "Next reference" },
        ["<a-p>"] = { illuminate.goto_prev_reference, "Previous reference" },
      })
    end,
    requires = "folke/which-key.nvim",
  },
  {
    "windwp/nvim-autopairs",
    config = function()
      require("nvim-autopairs").setup({
        check_ts = true, -- treesitter integration
        disable_filetype = { "TelescopePrompt" },
      })

      local cmp_autopairs = require("nvim-autopairs.completion.cmp")
      local cmp_status_ok, cmp = pcall(require, "cmp")
      if not cmp_status_ok then
        cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done({}))
      end
    end,
  },
  {
    "kylechui/nvim-surround",
    tag = "*", -- Use for stability; omit to use `main` branch for the latest features
    config = function()
      require("nvim-surround").setup()
    end,
  },
  {
    "ellisonleao/glow.nvim",
    config = function()
      require("glow").setup({ border = "rounded", width = 80 })
      require("which-key").register({
        ["<leader>m"] = { "<cmd>Glow<CR>", "Open preview in glow" },
      })
    end,
    requires = "folke/which-key.nvim",
  },
}
