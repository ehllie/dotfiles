return {
  "mhartington/formatter.nvim",
  config = function()
    local futils = require("formatter.util")
    local utils = require("ehllie.utils")

    local function prefix_args(args, formatter)
      return function()
        return utils.prefix_key(formatter(), "args", args)
      end
    end

    --- For formatters that cover multiple filetypes
    local function many_filetypes(fts, formater)
      return utils.transform_table(function(_, format)
        return format, { formater }
      end, fts)
    end

    local filetypes = require("formatter.filetypes")
    local formatters = require("formatter.defaults")

    require("formatter").setup({
      logging = true,
      log_level = vim.log.levels.WARN,
      filetype = vim.tbl_deep_extend(
        "force",
        {
          lua = {
            prefix_args({ "--indent-type", "spaces", "--indent-width", "2" }, filetypes.lua.stylua),
          },
          prisma = {
            utils.const({
              exe = "prisma",
              args = { "format" },
              stdin = true,
            }),
          },
          python = {
            prefix_args({ "--fast" }, filetypes.python.black),
            prefix_args({ "--profile", "black" }, filetypes.python.isort),
          },
          haskell = {
            function()
              return {
                exe = "fourmolu",
                args = {
                  "--indentation",
                  "2",
                  "--stdin-input-file",
                  futils.escape_path(futils.get_current_buffer_file_path()),
                },
                stdin = true,
              }
            end,
          },
          cabal = {
            utils.const({
              exe = "cabal-fmt",
              to_stdin = true,
            }),
          },
          ["*"] = {
            filetypes.any.remove_trailing_whitespace,
          },
        },
        many_filetypes(
          {
            "bash",
            "csh",
            "ksh",
            "sh",
            "zsh",
          },
          utils.const({
            exe = "beautysh",
            args = { "-i", "2", "-s", "fnonly" },
          })
        ),
        many_filetypes(
          {
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
            "toml",
          },
          prefix_args({
            ("--plugin=%s/lib/node_modules/prettier-plugin-toml"):format(store.prettier_toml),
          }, formatters.prettier)
        )
      ),
    })

    vim.api.nvim_create_autocmd({ "BufWritePost" }, {
      callback = function()
        if do_auto_format then
          vim.cmd("FormatWrite")
        end
      end,
    })
  end,
}
