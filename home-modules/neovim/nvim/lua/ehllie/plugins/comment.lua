return {
  "numToStr/Comment.nvim",
  config = function()
    require("Comment").setup({
      ignore = "^$",
      toggler = {
        line = "<leader>cc",
        block = "<leader>bb",
      },
      opleader = {
        line = "<leader>c",
        block = "<leader>b",
      },
      mappings = {
        basic = true,
        extra = true,
        block = true,
      },
    })
  end,
  dependencies = {
    "folke/which-key.nvim",
  },
}
