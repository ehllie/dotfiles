local function setup(hop, hint)
  local function next_char()
    hop.hint_char1({
      direction = hint.HintDirection.AFTER_CURSOR,
      current_line_only = true,
    })
  end

  local function prev_char()
    hop.hint_char1({
      direction = hint.HintDirection.BEFORE_CURSOR,
      current_line_only = true,
    })
  end

  local function next_word()
    hop.hint_words({
      direction = hint.HintDirection.AFTER_CURSOR,
    })
  end

  local function prev_word()
    hop.hint_words({
      direction = hint.HintDirection.BEFORE_CURSOR,
    })
  end
  local opts = { noremap = true, silent = true }
  local keymap = vim.keymap.set
  keymap("n", "f", next_char, opts)
  keymap("n", "F", prev_char, opts)
  keymap("n", "<leader>w", next_word, opts)
  keymap("n", "<leader>W", prev_word, opts)

  hop.setup()
end

return { deps = { "hop", "hop.hint" }, setup = setup }
