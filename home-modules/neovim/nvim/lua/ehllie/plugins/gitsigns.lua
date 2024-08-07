return {
  "lewis6991/gitsigns.nvim",
  opts = {
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
  },
  keys = {
    { "<leader>gS", "<cmd>Gitsigns stage_hunk<CR>", desc = "Stage buffer" },
    { "<leader>gb", "<cmd>Gitsigns blame_line<CR>", desc = "Blame line" },
    { "<leader>gd", "<cmd>Gitsigns diffthis<CR>", desc = "Diff this" },
    { "<leader>gp", "<cmd>Gitsigns preview_hunk_inline<CR>", desc = "Preview hunk" },
    { "<leader>gu", "<cmd>Gitsigns undo_stage_hunk<CR>", desc = "Undo stage hunk" },
    { "<leader>gU", "<cmd>Gitsigns reset_hunk<CR>", desc = "Reset hunk", mode = { "n", "v" } },
    { "<leader>gs", "<cmd>Gitsigns stage_hunk<CR>", desc = "Stage hunk", mode = { "n", "v" } },
  },
  dependencies = "folke/which-key.nvim",
}
