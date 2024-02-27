return {
  "stevearc/conform.nvim",
  config = function()
    local utils = require("ehllie.utils")

    local conform = require("conform")

    --- For formatters that cover multiple filetypes
    local function many_filetypes(fts, formater)
      return utils.transform_table(function(_, format)
        return format, { formater }
      end, fts)
    end

    conform.setup({
      formatters_by_ft = vim.tbl_deep_extend(
        "force",
        {
          lua = { "stylua" },
          pyton = { "black", "isort" },
          haskell = { "fourmolu" },
          cabal = { "cabal-fmt" },
          toml = { "prettier_toml" },

          ["_"] = { "trim_whitespace", "trim_newlines" },
        },
        many_filetypes({
          "bash",
          "csh",
          "ksh",
          "sh",
          "zsh",
        }, "beautysh"),
        many_filetypes({
          "javascript",
          "javascriptreact",
          "typescript",
          "typescriptreact",
          "vue",
          "css",
          "scss",
          "less",
          "html",
          "json",
          "jsonc",
          "yaml",
          "markdown",
          "markdown.mdx",
          "graphql",
          "handlebars",
          "svelte",
        }, "prettier")
      ),
      formatters = {
        black = {
          prepend_args = { "--fast" },
        },
        prettier_toml = {
          command = "prettier",
          args = {
            ("--plugin=%s/lib/node_modules/prettier-plugin-toml/lib/index.js"):format(store.prettier_toml),
            "--stdin-filepath",
            "$FILENAME",
          },
        },
        isort = {
          prepend_args = { "--profile", "black" },
        },
        fourmolu = {
          prepend_args = { "--indentation", "2" },
        },
        beautysh = {
          prepend_args = { "-i", "2", "-s", "fnonly" },
        },
        stylua = {
          prepend_args = { "--indent-type", "spaces", "--indent-width", "2" },
        },
        prisma = {
          command = "prisma-fmt",
          args = { "format" },
          stdin = true,
        },
        ["cabal-fmt"] = {
          command = "cabal-fmt",
          stdin = true,
        },
      },
    })

    -- Convert a table of aucmd patterns into a single pattern,
    -- that matches when none of the patterns match.
    local lsp_formatters = require("ehllie.plugins.lsp.handlers").can_format
    local patterns = vim.tbl_map(function(aucmd_pat)
      return aucmd_pat:gsub("%*%.", ".*\\.") .. "$"
    end, lsp_formatters)
    local alternated = table.concat(patterns, [[\|]])
    local inverted = ([[^\(%s\)\@!.*$]]):format(alternated)
    local re = vim.regex(inverted)

    vim.api.nvim_create_autocmd({ "BufWritePost" }, {
      pattern = "*",
      callback = function(args)
        ---@diagnostic disable-next-line: undefined-field, need-check-nil
        if do_auto_format and re:match_str(args.file) then
          conform.format({
            async = true,
            bufnr = args.bufnr,
          })
        end
      end,
    })
  end,
}
