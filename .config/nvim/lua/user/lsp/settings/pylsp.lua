return {
  settings = {
    pylsp = {
      plugins = {
        flake8 = { enabled = true, maxLineLength = 88, ignore = { "E203" } },
        jedi = { extraPaths = { "$HOME/.local/lib/python3.10/site-packages" } },
        jedi_completion = { eager = true },
        pycodestyle = { enabled = false },
      },
    },
  },
}
