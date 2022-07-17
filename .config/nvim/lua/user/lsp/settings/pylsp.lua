return {
  settings = {
    pylsp = {
      plugins = {
        flake8 = { enabled = true, maxLineLength = 88, ignore = { "E203" } },
        jedi_completion = { enabled = false },
        pycodestyle = { enabled = false },
      },
    },
  },
}
