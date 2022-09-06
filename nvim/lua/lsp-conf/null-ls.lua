local function config()
  local null_ls = require("null-ls")

  local diagnostics = null_ls.builtins.diagnostics
  local formatting = null_ls.builtins.formatting
  null_ls.setup({
    debug = false,
    sources = {
      diagnostics.flake8.with({ extra_args = { "--max-line-length", "--extend-ignore", "E203" } }),
      diagnostics.mypy,

      formatting.black.with({ extra_args = { "--fast" } }),
      formatting.isort.with({ extra_args = { "--profile", "black" } }),

      formatting.stylua.with({ extra_args = { "--indent-type", "spaces", "--indent-width", "2" } }),

      formatting.prettier.with({ extra_args = { "--no-semi", "--single-quote", "--jsx-single-quote" } }),

      formatting.nixpkgs_fmt,

      formatting.fourmolu.with({ extra_args = { "--indentation", "2" } }),
      formatting.cabal_fmt,
    },
  })
end

return {
  "jose-elias-alvarez/null-ls.nvim",
  config = config,
}
