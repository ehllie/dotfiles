local function config()
  local util = require("Comment.utils")
  local api = require("Comment.api")
  require("Comment").setup({
    pre_hook = function(ctx)
      local location = nil
      if ctx.ctype == util.ctype.block then
        location = require("ts_context_commentstring.utils").get_cursor_location()
      elseif ctx.cmotion == util.cmotion.v or ctx.cmotion == util.cmotion.V then
        location = require("ts_context_commentstring.utils").get_visual_start_location()
      end

      return require("ts_context_commentstring.internal").calculate_commentstring({
        key = ctx.ctype == util.ctype.line and "__default" or "__multiline",
        location = location,
      })
    end,
  })

  local register = require("which-key").register
  register({ ["<leader>/"] = { api.toggle_current_linewise, "Comment out" } })
  register({
    ["<leader>/"] = {
      function()
        api.toggle_linewise_op(vim.fn.visualmode())
      end,
      "Comment out",
      mode = "x",
    },
  })
end

return {
  "numToStr/Comment.nvim",
  config = config,
  requires = { "JoosepAlviste/nvim-ts-context-commentstring", "folke/which-key.nvim" },
}
