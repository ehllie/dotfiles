return {
  "numToStr/Comment.nvim",
  config = function()
    local util = require("Comment.utils")
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
      pre_hook = function(ctx)
        if vim.bo.filetype == "typescript" then
          local location = nil
          if ctx.ctype == util.ctype.blockwise then
            location = require("ts_context_commentstring.utils").get_cursor_location()
          elseif ctx.cmotion == util.cmotion.v or ctx.cmotion == util.cmotion.V then
            location = require("ts_context_commentstring.utils").get_visual_start_location()
          end

          return require("ts_context_commentstring.internal").calculate_commentstring({
            key = ctx.ctype == util.ctype.linewise and "__default" or "__multiline",
            location = location,
          })
        end
      end,
    })
  end,
  dependencies = {
    "JoosepAlviste/nvim-ts-context-commentstring",
    "folke/which-key.nvim",
  },
}
