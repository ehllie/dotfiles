return {
  "nvim-neorg/neorg",
  after = { "nvim-treesitter", "telescope.nvim" },
  config = function()
    require("neorg").setup({
      load = {
        ["core.defaults"] = {}, -- Loads default behaviour
        ["core.norg.concealer"] = {}, -- Adds pretty icons to your documents
        ["core.norg.dirman"] = { -- Manages Neorg workspaces
          config = {
            workspaces = {
              work = "~/Documents/Org/work",
              home = "~/Documents/Org/home",
            },
          },
        },
        ["core.norg.completion"] = { -- Enables completion of Neorg keywords
          config = {
            engine = "nvim-cmp",
          },
        },
        ["core.integrations.nvim-cmp"] = {},
        ["core.integrations.treesitter"] = {},
      },
    })
  end,
}
