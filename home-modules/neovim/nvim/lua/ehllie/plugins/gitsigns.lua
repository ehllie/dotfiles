return {
  "lewis6991/gitsigns.nvim",
  config = function()
    local gs = require("gitsigns")
    gs.setup({
      signs = {
        add = {
          text = "▎",
        },
        change = {
          text = "▎",
        },
        delete = {
          text = "契",
        },
        topdelete = {
          text = "契",
        },
        changedelete = {
          text = "▎",
        },
      },
    })
    local register = require("which-key").register
    register({
      d = { gs.diffthis, "Diff this" },
      u = { gs.undo_stage_hunk, "Undo stage hunk" },
      S = { gs.stage_buffer, "Stage buffer" },
      b = { gs.blame_line, "Blame line" },
      p = { gs.preview_hunk_inline, "Preview hunk" },
    }, { prefix = "<leader>g" })
    register({
      U = { ":Gitsigns reset_hunk<CR>", "Reset hunk" },
      s = { ":Gitsigns stage_hunk<CR>", "Stage hunk" },
    }, { mode = { "n", "v" }, prefix = "<leader>g" })
  end,
  dependencies = "folke/which-key.nvim",
}
