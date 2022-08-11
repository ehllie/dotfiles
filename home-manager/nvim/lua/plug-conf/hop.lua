local function setup()
  local hop = require("hop")
  local directions = require("hop.hint").HintDirection
  local function next_char()
    hop.hint_char1({
      direction = directions.AFTER_CURSOR,
      current_line_only = true,
    })
  end

  local function prev_char()
    hop.hint_char1({
      direction = directions.BEFORE_CURSOR,
      current_line_only = true,
    })
  end

  local function next_word()
    hop.hint_words({
      direction = directions.AFTER_CURSOR,
    })
  end

  local function prev_word()
    hop.hint_words({
      direction = directions.BEFORE_CURSOR,
    })
  end

  local register = require("which-key").register
  register({
    f = { next_char, "Hop forward to char" },
    F = { prev_char, "Hop back to char" },
    ["<leader>w"] = { next_word, "Hop forward to word" },
    ["<leader>W"] = { prev_word, "Hop back to word" },
  })

  hop.setup()
end

return {
  "phaazon/hop.nvim",
  branch = "v2",
  config = setup,
  requires = "folke/which-key.nvim",
}
