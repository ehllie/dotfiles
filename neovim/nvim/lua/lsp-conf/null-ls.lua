local function config()
  local null_ls = require("null-ls")
  local lspconfig = require("lspconfig")
  local utils = require("utils")
  local lsp_formatters = require("lsp-conf.handlers").can_format
  local FORMATTING = require("null-ls.methods").internal.FORMATTING

  local diagnostics = null_ls.builtins.diagnostics
  local formatting = null_ls.builtins.formatting
  local sources = {
    diagnostics.flake8.with({ extra_args = { "--max-line-length", "88", "--extend-ignore", "E203" } }),
    -- diagnostics.mypy,

    formatting.black.with({ extra_args = { "--fast" } }),
    formatting.isort.with({ extra_args = { "--profile", "black" } }),

    formatting.stylua.with({ extra_args = { "--indent-type", "spaces", "--indent-width", "2" } }),

    formatting.prettier.with({
      extra_args = {
        ("--plugin=%s/lib/node_modules/prettier-plugin-svelte"):format(store.prettier_svelte),
        ("--plugin=%s/lib/node_modules/prettier-plugin-toml"):format(store.prettier_toml),
      },
      extra_filetypes = { "svelte", "toml" },
    }),

    formatting.nixpkgs_fmt,

    formatting.beautysh.with({ extra_args = { "-i", "2", "-s", "fnonly" } }),

    formatting.fourmolu.with({ extra_args = { "--indentation", "2" } }),
    formatting.cabal_fmt,

    formatting.trim_whitespace,
  }

  local lsp_filetypes = utils.keys(utils.fold(
    function(acc, elem)
      return vim.tbl_deep_extend("force", acc, elem)
    end,
    {},
    vim.tbl_map(function(server)
      local filetypes = lspconfig[server].filetypes
      return utils.transform_table(function(_, v)
        return v, true
      end, filetypes)
    end, lsp_formatters)
  ))

  null_ls.setup({
    debug = false,
    sources = vim.tbl_map(function(builtin)
      return builtin.method == FORMATTING and builtin.with({ disabled_filetypes = lsp_filetypes }) or builtin
    end, sources),
  })
end

return {
  "jose-elias-alvarez/null-ls.nvim",
  config = config,
  requires = "neovim/nvim-lspconfig",
  after = { "nvim-lspconfig", "rust-tools.nvim" },
}
