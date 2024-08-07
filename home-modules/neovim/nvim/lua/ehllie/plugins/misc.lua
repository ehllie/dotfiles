-- Setup for minor plugins

return {
  "moll/vim-bbye",
  "nvim-lua/plenary.nvim", -- Useful lua functions used by lots of plugins
  "kyazdani42/nvim-web-devicons",
  {
    "AndrewRadev/bufferize.vim",
    keys = {
      { "<leader>Bm", "<cmd>Bufferize messages<cr>", desc = "Bufferize" },
    },
    dependencies = "folke/which-key.nvim",
  },
  {
    "lambdalisue/suda.vim",
    keys = {
      { "w!!", "SudaWrite", desc = "Write as superuser", mode = "c" },
    },
    dependencies = "folke/which-key.nvim",
  },
  {
    "NvChad/nvim-colorizer.lua",
    opts = {
      user_default_options = {
        tailwind = true,
      },
    },
    keys = {
      { "<leader>tc", "<cmd>ColorizerToggle<CR>", desc = "Toggle colorizer" },
    },
    dependencies = "folke/which-key.nvim",
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    opts = {
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
    },
    tag = "v2.20.8",
  },
  {
    "RRethy/vim-illuminate",
    config = function(_, opts)
      local illuminate = require("illuminate")
      illuminate.configure(opts)
    end,
    opts = {
      filetypes_denylist = { "alpha", "NvimTree" },
      under_cursor = false,
    },
    dependencies = "folke/which-key.nvim",
  },
  {
    "windwp/nvim-autopairs",
    config = function(_, opts)
      require("nvim-autopairs").setup(opts)

      local cmp_autopairs = require("nvim-autopairs.completion.cmp")
      local cmp_status_ok, cmp = pcall(require, "cmp")
      if not cmp_status_ok then
        cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done({}))
      end
    end,
    opts = {
      check_ts = true, -- treesitter integration
      disable_filetype = { "TelescopePrompt" },
    },
  },
  {
    "kylechui/nvim-surround",
    config = true,
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
  },
  {
    "ellisonleao/glow.nvim",
    opts = { border = "rounded", width = 80 },
    keys = {
      { "<leader>m", "<cmd>Glow<CR>", desc = "Open preview in glow" },
    },
    dependencies = "folke/which-key.nvim",
  },
}
