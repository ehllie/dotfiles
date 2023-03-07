local function config()
  local bline = require("bufferline")
  bline.setup()

  require("which-key").register({
    ["<leader>q"] = {
      h = {
        function()
          bline.close_in_direction("left")
        end,
        "Close buffers to the left",
      },
      l = {
        function()
          bline.close_in_direction("right")
        end,
        "Close buffers to the right",
      },
    },
    ["<C-S-h>"] = {
      function()
        bline.move(-1)
      end,
      "Move buffer to the left",
    },
    ["<C-S-l>"] = {
      function()
        bline.move(1)
      end,
      "Move buffer to the right",
    },
  })
end

return {
  "akinsho/bufferline.nvim",
  config = config,
  tag = "v3.*",
  requires = "folke/which-key.nvim",
}
